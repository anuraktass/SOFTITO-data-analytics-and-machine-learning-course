# Bir Yapay Zekâ Modelinin Karbon Ayak İzini Tahmin Etmeye Çalışırken Öğrendiklerimiz

### Veri temizlemekten "en iyi modeli" seçmeye: 5.227 satırlık bir veri setinden şeffaf bir karbon raporlama sistemine giden yolculuk

---

Her yeni büyük dil modeli duyurulduğunda aklımıza aynı soru takılıyor: *bu modeli eğitmek atmosfere kaç ton karbon saldı?* Bazen bu bilgi araştırma makalesinde bir cümleyle geçiyor, bazen hiç geçmiyor, bazen de üç farklı kaynakta üç farklı sayı görüyorsunuz. Biz de veri analizi kursumuzun bitirme projesi olarak tam bu soruyu ele almaya karar verdik: **AI modellerinin eğitim sürecinden kaynaklanan karbon emisyonunu, elimizdeki bilgiye göre ya doğrudan hesaplayan ya da makine öğrenmesiyle tahmin eden, sonucu da şeffaf biçimde raporlayan bir sistem kurabilir miyiz?**

Bu yazıda, o yolculuğun tamamını anlatıyoruz — veri setini ilk açtığımız andan, final modeli diske kaydedip geri yükleyip tekrar test ettiğimiz ana kadar. Kod satırı yok; sadece kararlarımız, gerekçelerimiz ve gerçek sonuçlarımız var.

## Neden "sadece bir regresyon modeli" değil?

Projeye başlarken kendimize koyduğumuz ilk kural şuydu: **elimizde zaten güvenilir bir bilgi varsa, ML'e hiç gerek yok.** Bir model sahibi elektrik tüketimini ve o bölgenin emisyon faktörünü bildirmişse, karbon emisyonunu `enerji × faktör` formülüyle dosdoğru hesaplayabiliriz — bunun için istatistiksel bir tahmine ihtiyacımız yok. ML, ancak bu bilgi gerçekten eksik olduğunda devreye girmeli.

Bu basit ama önemli karar, projeyi üç katmana ayırdı:

- **Direct Carbon Calculation** — fiziksel formülle doğrudan hesaplama
- **Machine Learning Prediction** — bilgi eksikse istatistiksel tahmin
- **Reporting / Sustainability Layer** — sonucu kaynağıyla, güvenilirliğiyle ve sürdürülebilirlik bağlamıyla birlikte sunma

Yazının geri kalanı, bu üç katmanın nasıl inşa edildiğinin hikâyesi.

## Veri setiyle ilk tanışma

Elimizdeki veri seti 5.227 AI modeline ait eğitim ve donanım bilgisi içeriyordu: kaç FLOP harcandığı, kaç parametre olduğu, kaç token ile eğitildiği, hangi GPU/TPU'nun kullanıldığı, hangi bölgede eğitildiği, elektrik tüketimi, emisyon faktörü ve — varsa — bildirilen karbon emisyonu.

İlk göze çarpan şey, veri setinin bazı kısımlarının daha önce **imputation/sentetik tamamlama** yöntemleriyle doldurulmuş olmasıydı (dosya adı bile bunu "imputed_realistic" diyerek itiraf ediyordu). Bunu görmezden gelmek yerine baştan bir metodolojik sınırlılık olarak kabul ettik: bazı dağılımlar kusursuz bir gerçek dünya dağılımı yansıtmayabilir, ama bu projeyi geçersiz kılmaz — sadece sonuçları yorumlarken bu bağlamı hatırlamamız gerektiği anlamına gelir.

Temel keşif (EDA) bize şunu gösterdi:

- Veri setinde hiç eksik (null) değer yoktu — beklenen bir şeydi, çünkü eksikler zaten daha önce dolduruşmuştu.
- Duplicate satır ya da tekrar eden model ID yoktu.
- Ama `emissions_tCO2e` sütununda 80 kayıt (%1,53) tam olarak **sıfırdı**. Bu sıfırlar bizi düşündürdü: gerçekten ihmal edilebilir emisyonlu küçük bir model mi, yoksa "veri yok" anlamına gelen bir yer tutucu mu?

Bu soru, projenin en çok emek verdiğimiz feature'ından birinin doğuşuydu.

Biraz daha derine indiğimizde, sayılar bize veri setinin ne kadar "uçlarda" bir dünyayı temsil ettiğini gösterdi. `training_flops` ortalaması 1,34×10²³ iken standart sapması 1,14×10²⁴'e kadar çıkıyordu — yani ortalamanın kendisi neredeyse anlamsızdı, çünkü birkaç dev model (muhtemelen GPT/Llama ölçeğinde) tüm dağılımı domine ediyordu. Aynı örüntü `emissions_tCO2e`'de de vardı: ortalama 11,41 tCO2e ama maksimum 8.176 tCO2e. Boxplot'lara baktığımızda bu "uç değerler" istatistiksel bir gürültü değil, gerçekten var olan, hatta projenin asıl ilgilendiği modellerdi. Bu yüzden EDA'nın en başında kendimize bir söz verdik: **bu uç değerleri sırf rahatsız edici oldukları için silmeyeceğiz.**

Korelasyon analizi de bize erken bir uyarı verdi. `emissions_tCO2e` ile `disclosed_emissions_tco2e` arasındaki korelasyon 0,986, `disclosed_electricity_used_mwh` ile korelasyon ise 0,977 çıktı. Bu sayılar kulağa "harika, güçlü bir öngörücü bulduk" gibi gelebilir ama aslında tam tersini işaret ediyordu: bu değişkenler hedefle *neredeyse birebir aynı şeydi*, dolayısıyla modele değil, doğrudan hesaplama katmanına ait olmalıydılar. Buna karşılık `training_flops` (r ≈ 0,44) ve `parameter_values` (r ≈ 0,43) ile olan orta düzey korelasyonlar, gerçek ve modele güvenle verebileceğimiz dolaylı ilişkilerdi.

## `cleaned_emissions_tCO2e`: Hedefimizi inşa etmek

Ham `emissions_tCO2e` sütununu doğrudan hedef almak yerine, beş kademeli bir öncelik zinciri kurduk:

1. Emisyon zaten bildirilmişse → doğrudan kullan (`reported`)
2. Sıfırsa ama başka bir sütunda bildirilmiş bir değer varsa → oradan kurtar (`recovered_from_disclosed`)
3. O da yoksa, elektrik tüketimi × emisyon faktörü ile hesapla (`direct_calculation`)
4. Hiçbir kaynak yok ama compute bilgisi (FLOPs) mevcutsa ve diğer kaynaklar da sıfıra işaret ediyorsa → doğrulanmış bir sıfıra yakın değer (`validated_zero`)
5. Hiçbiri yoksa → ML tahminine bırak (`ml_estimated`)

Her kaydın bu beşliden hangisiyle çözüldüğünü gösteren `calculation_method` sütununu da paralel olarak ürettik. Bu, projenin en kritik şeffaflık aracı oldu: kullanıcıya sunduğumuz her sayının arkasında "bu nasıl elde edildi?" sorusunun cevabı var.

İlginç bir detay: disclosed elektrik tüketimi sıfır olan 81 kaydı çıkardıktan sonra elimizde kalan 5.146 satırın **tamamı** `reported` olarak çözüldü. Yani bu özel veri kesitinde direct calculation veya ML tahminine hiç ihtiyaç kalmadı — ama sistemi yine de bu senaryolar için kurduk ve simülasyonla test ettik (birazdan geleceğiz).

## Veri sızıntısına (leakage) karşı paranoyaklık

Karbon emisyonu projelerinde en sinsi tuzaklardan biri şu: bazı değişkenler hedefle *çok* güçlü ilişkili çünkü hedefin kendisinden matematiksel olarak türetilmişler. Örneğin `intensity_tCO2e_per_FLOP` sütununu `emissions_tCO2e / training_flops` ile yeniden hesapladığımızda, orijinal sütunla korelasyon **1,0000** çıktı. Bu bir "güçlü feature" değil, saf bir özdeşlikti — modele verirsek model gerçek bir ilişki öğrenmek yerine hedefi geri okuyacaktı.

Bu yüzden her değişkeni üç kutudan birine koyduk:

- **ML Prediction Features** — tahmin anında gerçekten elimizde olan, hedeften türetilmemiş 14 değişken
- **Direct Calculation Features** — fiziksel hesaplama için kullanılan ama modele asla verilmeyen değişkenler
- **Reporting Features** — kullanıcıya sunum için kullanılan ama model girdisi olmayan değişkenler (`sustainability_score` dahil)

Bu ayrımı kod içinde `assert` ifadeleriyle otomatik doğruladık — "muhtemelen doğrudur" değil, "kanıtlanmış biçimde doğrudur" demek istedik.

## 14 feature'ın hikâyesi

Feature engineering aşamasında kendimize kısıt koyduk: rastgele feature üretip modele atmak yerine, her feature'ın fiziksel/mantıksal bir gerekçesi olmasını istedik.

**Log dönüşümleri** (`log_training_flops`, `log_parameters`, `log_training_tokens`) — çünkü FLOPs, parametre ve token sayıları birkaç mertebe büyüklük farkı gösterebiliyor ve ham haliyle aşırı sağa çarpık. Log1p dönüşümü hem uç değerlerin etkisini yumuşattı hem de özellikle Linear Regression için daha doğrusal bir ilişki yarattı.

**`gpu_family`** — `training_gpu_type` sütununda onlarca farklı yazım varyasyonu vardı. Bunları A100, V100, H100, A800, H800, TPU gibi altı ana aile altında topladık. Sonuç: A100 (2.240 kayıt), V100 (2.072) baskın; tanımlanamayan donanımların oranı sadece %3,25.

**`flops_per_parameter`** ve **`flops_per_token`** — bir modelin ne kadar "yoğun" eğitildiğini gösteren oranlar. Sadece "ne kadar büyük" değil, "ne kadar hesaplama-yoğun eğitildi" sorusuna da cevap veriyorlar.

**`region_carbon_intensity`** ve **`low_carbon_region`** — aynı enerjiyi tüketen iki model, Fransa'da mı yoksa kömürle çalışan bir şebekede mi eğitildiğine göre çok farklı emisyona sahip olabilir. Bu feature tam olarak bu etkiyi yakalıyor.

**`data_quality_flag`** — doğrudan bildirilen bir veri ile bir ML tahmini aynı güvenilirlik seviyesinde sunulmamalı. Bu flag, kullanıcıya "bu sayıya ne kadar güvenebilirsin?" sorusunun cevabını veriyor.

Ve belki en sevdiğimiz feature: **`sustainability_score`**. Tek başına karbon emisyonu bir modelin "iyi" mi "kötü" mü olduğunu tam anlatmıyor — büyük bir modelin yüksek mutlak emisyonu doğaldır. Bu yüzden üç bileşenli bir skor tasarladık: karbon ayak izi (%50), compute verimliliği (%30) ve şebeke temizliği (%20), hepsi percentile-rank ile 0-100 arasına normalize edildi. Sonuç fizikle örtüştü: en yüksek skorlu modeller küçük, niş modellerken; en düşük skorlu modeller arasında Qwen2.5-72B, DeepSeek-V3-Base ve GLM-4.5 gibi devler vardı. Önemli bir detay: bu skor **modelin girdisi değil**, tahmin sonucundan hesaplanan bir raporlama metriği — yoksa kendi kendini besleyen bir döngü (circular dependency) yaratırdık.

## Bölgeler eşit yaratılmamış

Bölge bilgisi veri setinde üç farklı sütuna (`model_region`, `disc_region_text`, `disclosed_region`) dağılmış, farklı yazımlarla ("USA", "US", "United States" gibi) doluydu. Önce bir öncelik sırasıyla bu üçünü birleştirdik, sonra kural tabanlı bir normalize fonksiyonuyla (alias eşleştirme + ülke listesi taraması) tek bir `standardized_region` sütununa indirdik. Sonuçta en sık görülen kategoriler Unknown (2.126), United States (1.630) ve China (621) oldu; yalnızca 5 kayıt (%0,10) sınıflandırılamadı — bu da kural setimizin oldukça kapsayıcı olduğunu gösterdi.

Bölge standardizasyonu bize bölgesel karbon yoğunluğunu (`region_carbon_intensity`) hesaplama imkânı verdi: her bölge için ortalama emisyon faktörünü hesaplayıp, medyanın altında kalan bölgeleri "düşük karbonlu" (`low_carbon_region`) olarak işaretledik. Buradaki sezgi basit ama güçlü: Fransa'da (büyük ölçüde nükleer enerjiyle) eğitilen bir model ile kömüre dayalı bir şebekede eğitilen aynı büyüklükteki bir model, aynı miktarda elektrik tüketse bile çok farklı karbon ayak izine sahip olabilir. Ham FLOPs veya parametre sayısı bu farkı hiç yakalayamaz; region_carbon_intensity tam olarak bu boşluğu dolduruyor.

## Baseline'dan başlamak: DummyRegressor

Herhangi bir modelin "iyi" olduğunu iddia etmeden önce, "hiçbir şey öğrenmeyen" bir modelden daha iyi olduğunu göstermemiz gerekiyordu. `DummyRegressor(strategy='median')` her zaman 1,00 tCO2e tahmin etti (eğitim setinin medyanı). Test setinde MAE = 9,60, R² = −0,03. Bu bizim sıfır noktamızdı.

## Linear Regression: mütevazı ama dürüst bir başlangıç

14 feature'ı One-Hot Encoding ve StandardScaler ile hazırlayıp bir Linear Regression kurduk. Test setinde MAE = 7,84, R² = 0,068 çıktı — ilk bakışta hayal kırıklığı gibi görünebilir. Ama burada önemli bir nüans var: bu R², **ham tCO2e ölçeğinde** hesaplandı ve birkaç dev model (Llama-3-70B gibi) toplam varyansın büyük kısmını yutuyor. Aynı modeli log-uzayda 5-fold cross validation ile değerlendirdiğimizde R² ortalaması **0,571**'e çıktı. Yani model dediğimiz kadar kötü değildi — sadece hangi ölçekte konuştuğumuza dikkat etmemiz gerekiyordu.

Linear Regression'ın projedeki rolü zaten "en iyi model olmak" değildi. Amacı, XGBoost gibi daha karmaşık bir modelin gerçekten gerekli olup olmadığını sınamaktı. Ve gerekliydi.

## XGBoost sahneye çıkıyor

Aynı 14 feature'ı, bu sefer hiçbir encoding/scaling yapmadan (XGBoost'un native categorical desteğini kullanarak) bir XGBRegressor'a verdik. Sonuç: test setinde MAE = 2,88, R² = 0,78. Linear Regression'a göre büyük bir sıçrama.

Ama bir sorun vardı: train setinde R² = 0,97 çıkmıştı. Train ve test arasındaki bu 0,19'luk fark bize tek bir şey söylüyordu: **model ezberliyor olabilir.**

## "Yüksek train skoru başarı değildir"

Bu cümleyi proje boyunca kendimize sık sık hatırlattık. Overfitting'i azaltmak için önce sekiz XGBoost hiperparametresini (max_depth, min_child_weight, reg_alpha, reg_lambda, learning_rate, n_estimators, subsample, colsample_bytree) tek tek gerekçelendirerek elle ayarladık. Sonuç: train-test farkı 0,19'dan 0,011'e düştü, test performansında neredeyse hiç kayıp olmadan.

Sonra işi biraz daha sistematik hale getirdik: manuel ayarımızın etrafında dar bir arama uzayı tanımlayıp `RandomizedSearchCV` (25 deneme, 5-fold) çalıştırdık. Neden GridSearch değil? Çünkü arama uzayını zaten daraltmıştık; her kombinasyonu tek tek denemek hesaplama açısından anlamsız olurdu. Optimizasyon metriği olarak RMSE seçtik — çünkü büyük hataları orantısız cezalandırıyor, ki bu tam olarak istediğimiz şeydi: büyük modellerde büyük hata yapmamak.

Bulunan en iyi parametrelerle (n_estimators=628, max_depth=5, learning_rate≈0,072, reg_lambda≈4,80 gibi) test R²'si **0,87**'ye, train-test farkı ise **−0,146**'ya (yani test, train'den bile iyi çıktı) ulaştı.

Burada dürüst olmamız gereken bir nokta var: 5-fold CV ortalaması bu tuned modelde aslında çok hafif geriledi (0,893 → 0,888). Yani asıl kazanım "mutlak olarak daha iyi bir model" değil, train-test arasındaki farkın kapanmasıyla gelen **stabilite**ydi. Final model seçim kuralımız (train-test farkı belirgin azaldıysa VE test performansında ciddi kayıp yoksa tuned model seçilsin) bu koşulları karşıladığı için Tuned XGBoost'u final model seçtik — ama bu nüansı raporumuzda saklamadık.

## Model neye bakıyor?

Feature importance analizinde hem built-in (gain tabanlı) hem permutation importance hesapladık — çünkü built-in importance, çok kategorili değişkenleri (örneğin bölge) suni biçimde şişirme eğiliminde. İki yöntem de aynı iki feature'ı zirveye koydu: **`log_training_flops`** ve **`method`**.

`log_training_flops`'un en önemli feature olması bizi hiç şaşırtmadı — fizikle birebir örtüşüyor: ne kadar çok hesaplama, o kadar çok enerji, o kadar çok emisyon. Ama `method`'un (emisyonun nasıl ölçüldüğünü gösteren bir üst-veri sütunu) bu kadar yüksek çıkması bizi tedirgin etti: *gerçek dünyada tahmin anında bu bilgi elimizde olacak mı?*

Bunu test etmek için modeli bir kez `method` dahil, bir kez hariç eğittik. Test R²'deki değişim sadece −0,013 çıktı — yani model `method`'a aşırı bağımlı değildi, ağırlıklı olarak compute büyüklüğü gibi daha temel sinyallerden öğreniyordu. Bu bizi rahatlattı ama bu kontrolü yapmamış olsaydık, production'da hiç fark etmeden kırılgan bir modeli devreye almış olabilirdik.

## Hatalarımızla yüzleşmek

Ortalama metrikler (MAE, RMSE) rahatlatıcı olabiliyor ama nerede battığımızı gizliyor. Residual analizinde en büyük hatalara baktığımızda beklediğimiz gibi dev modelleri gördük: Meta-Llama-3-70B'de gerçek 1.010 tCO2e'ye karşı tahmin 545,5 (eksik tahmin); GLM-4.5'te gerçek 528'e karşı tahmin 196,6 (yine eksik tahmin). Ama bazı orta ölçekli modellerde de belirgin aşırı tahminler vardı.

Test setini emisyon seviyesine göre üçe böldüğümüzde (Düşük/Orta/Yüksek), yüksek emisyon grubunun MAE'si düşük gruba göre **69 kat** daha büyük çıktı. Beklenen bir sonuç — ama önemli olan şuydu: **bu uç modelleri veri setinden silmedik.** Gerçek dünyada yüksek karbonlu modeller tam da bu projenin ilgilendiği modeller; onları istatistiksel olarak "rahatsız edici" diye çıkarmak, projenin amacına ihanet olurdu.

## Sistemi bir araya getirmek: Hybrid Carbon Estimation

Buraya kadar anlattığımız her şey, aslında tek bir karar zincirinin parçalarıydı:

> Gerçek/Bildirilen Veri → Doğrudan Hesaplama → Doğrulanmış Sıfır → ML Tahmini

Bu zinciri kodladık ve gerçek kayıtlarla test ettik. Örneğin `Qwen/Qwen3-4B` için sistem şunu üretti: *Carbon Emission: 0,56 tCO2e, Method: Reported, Confidence: High.* Veri setimizde ML dalına düşen gerçek bir örnek olmadığı için (hatırlarsanız, tüm kayıtlar `reported` olarak çözülmüştü), bu dalı simüle ederek test ettik: hiçbir kaynağın olmadığını varsaydığımız bir kayıt için model 1,04 tCO2e tahmin üretti (gerçek değer 1,00 tCO2e'ydi) ve sistem bunu otomatik olarak *"ML Estimated"*, *Confidence: Medium*, *Data Quality: low* olarak etiketledi.

Bu son nokta bizim için önemliydi: sistem, bir ML tahminini asla bildirilen bir veriyle aynı güven seviyesinde sunmuyor. Kullanıcı her zaman *"bu sayı nereden geldi?"* sorusunun cevabını alıyor.

## Modeli rafa kaldırmak

Final modeli seçtikten sonra son bir adım kaldı: onu gerçekten kullanılabilir hale getirmek. Önce modeli **tüm veri setinde** (train+test birleşik, 5.146 kayıt) yeniden eğittik — çünkü genellenebilirlik kanıtımızı zaten CV ve train/test split ile almıştık, artık ayrı bir test seti tutmanın maliyeti faydasından yüksekti.

Sonra modeli, ihtiyaç duyduğu her şeyle (feature listeleri, seyrek kategori haritası, kategori seviyeleri, hedef dönüşüm bilgisi) birlikte tek bir `joblib` paketine koyup diske kaydettik. Bunu diskten geri yükleyip aynı 10 kayıt için tahmin ürettirdik — orijinal modelle aradaki fark tam olarak **0,0000000000** çıktı. Round-trip testi bunun için var: bir model notebook içinde çalışıyor olması yetmez, kaydedilip yeniden yüklendiğinde de birebir aynı davranmalı.

Son olarak, yeni bir model geldiğinde tek bir fonksiyon çağrısıyla tahmin üretebilen `predict_carbon_emission_ml()` fonksiyonunu yazdık ve üç rastgele kayıtla demo ettik — biri için tahmin 31,27 tCO2e (gerçek: 31,00), biri için 0,0259 tCO2e (gerçek: 0,0052). Bazı sapmalar var, ama bu da residual analizinde zaten gördüğümüz, saklamadığımız bir gerçek.

## Güven skorunu neden "istatistiksel" yapmadık

Confidence Score mekanizmasını tasarlarken bilinçli bir tercih yaptık: bunu bir istatistiksel güven aralığı (confidence interval) olarak değil, **kural tabanlı, açıklanabilir bir etiket** olarak kurduk. `reported` ve `direct_calculation` kayıtları her zaman *High* confidence alıyor, çünkü bunlar zaten ölçülmüş/hesaplanmış değerler. ML tahminleri ise veri kalitesine ve tahmin edilen emisyon seviyesine göre *Medium* veya *Low* olarak etiketleniyor.

Bunu neden böyle kurduk? Çünkü bir kullanıcıya "%73 güvenle 12,4 tCO2e" demek, aslında sahip olmadığımız bir kesinlik hissi verir — bu sayı arkasındaki modelin residual analizinde gördüğümüz gibi bazı bölgelerde 69 kat daha büyük hata yapabildiğini biliyoruz. Kural tabanlı bir etiket ("Bu bir ML tahminidir, veri kalitesi düşüktür") daha az gösterişli ama çok daha dürüst bir iletişim biçimi.

## Sayılarla proje: hızlı bir özet

Yazının bu kadar detayından sonra, akılda kalması gereken birkaç rakamı toparlayalım:

- **Veri seti:** 5.227 kayıt, 24 ham değişken → temizlik sonrası 5.146 kayıt, 14 türetilmiş feature
- **Leakage kontrolleri:** 10/10 otomatik kontrol ✅ (hiçbir yasaklı değişken ML setine sızmadı)
- **Baseline (Dummy):** MAE 9,60 tCO2e, R² −0,03
- **Linear Regression:** log-uzayda CV R² ortalaması 0,571
- **İlk XGBoost:** Test R² 0,78, ama train-test farkı 0,19 (overfitting sinyali)
- **Regularization sonrası:** train-test farkı 0,19 → 0,011
- **Tuned (RandomizedSearchCV) final model:** Test R² 0,87, MAE 2,31 tCO2e
- **En önemli iki feature:** `log_training_flops` ve `method` (hem built-in hem permutation importance'ta)
- **Round-trip testi:** kaydedilen model ile orijinali arasındaki fark → tam olarak 0
- **Sustainability Score aralığı:** 1,46 (Qwen2.5-72B gibi devler) — 98,82 (küçük niş modeller)

## Peki, ne öğrendik?

Bu projeden çıkardığımız en büyük ders teknik değil, metodolojikti: **iyi bir sayı üretmek, doğru sayıyı üretmekle aynı şey değil.**

Data leakage'a karşı paranoyak davranmasaydık, `intensity_tCO2e_per_FLOP` gibi bir sütun bize sahte bir mükemmellik hissi verebilirdi. Overfitting kontrolü yapmasaydık, %97 train R²'sini kutlayıp production'da hayal kırıklığına uğrayabilirdik. `method` feature'ını sorgulamasaydık, gerçek dünyada var olmayan bir bilgiye bağımlı kırılgan bir model teslim edebilirdik. Outlier'ları silmiş olsaydık, projenin asıl önemsediği yüksek-emisyonlu modelleri kör noktamıza alabilirdik.

Ve belki en önemlisi: final model seçimimizde CV ortalamasının hafifçe gerilediğini fark edip bunu saklamak yerine raporladık. Çünkü bir veri projesinin güvenilirliği, en yüksek R²'yi bulmaktan değil, bulduğunuz sayının ne anlama geldiğini — ve ne anlama gelmediğini — dürüstçe söylemekten geliyor.

---

*Bu yazı, veri analizi kursu kapsamında geliştirdiğimiz "AI Modellerinin Karbon Emisyonu Analizi, Tahmini ve Raporlanması" projesinin teknik sürecini özetlemektedir. Proje; EDA, feature engineering, leakage kontrolü, model karşılaştırması, hiperparametre optimizasyonu, hibrit karbon tahmin sistemi ve production'a hazır model kaydını kapsayan uçtan uca bir çalışmadır.*
