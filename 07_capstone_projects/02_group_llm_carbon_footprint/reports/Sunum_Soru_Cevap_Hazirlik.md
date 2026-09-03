# Sunum Sonrası Gelebilecek Sorular ve Cevapları

### AI Modellerinin Karbon Emisyonu Analizi, Tahmini ve Raporlanması Projesi

Bu doküman, sunum sonrasında jüri/eğitmen/dinleyicilerden gelebilecek soruları kategorilere ayırarak, projenin gerçek verilerine dayanan hazır cevaplarla derlemektedir. Her cevap kısa ve net tutulmuş, gerektiğinde arkasına "detaylandırmak isterseniz" notu eklenmiştir.

---

## 1. Genel Metodoloji Soruları

**S: Bu projenin diğer "karbon tahmini" projelerinden farkı ne?**
Çoğu benzer çalışma doğrudan bir regresyon modeli kurup emisyonu tahmin etmekle yetinir. Biz bunun yerine üç katmanlı bir sistem kurduk: önce elimizde gerçek/bildirilen veri var mı diye bakıyoruz, yoksa fiziksel formülle doğrudan hesaplıyoruz, o da mümkün değilse ancak o zaman ML'e başvuruyoruz. Sonucu da tek bir sayı olarak değil, kaynağı, güvenilirlik seviyesi ve sürdürülebilirlik bağlamıyla birlikte sunuyoruz.

**S: Neden ML'i her yerde kullanmadınız, bazı yerlerde doğrudan hesaplama tercih ettiniz?**
Çünkü gerçek/ölçülmüş bir veri varken istatistiksel bir tahmine güvenmek gereksiz belirsizlik eklemek olur. ML'in değeri, bilgi eksik olduğunda ortaya çıkar. Bu, projenin en temel tasarım kararıydı.

**S: Projenin genel iş akışını özetler misiniz?**
Ham veri → EDA → veri kalitesi kontrolleri → feature engineering → leakage kontrolü → ML feature seti → Linear Regression baseline → XGBoost → cross validation → overfitting analizi → regularization + hyperparameter tuning → final model seçimi → residual/outlier analizi → hybrid sistem → confidence score → sustainability score → final raporlama çıktısı → modelin tüm veriyle yeniden eğitilmesi → kaydetme → yeniden kullanılabilir tahmin fonksiyonu → demo doğrulaması.

**S: Bu proje kaç saatlik/kaç aşamalı bir çalışmanın ürünü?**
Süreç EDA'dan final model kaydına kadar onlarca ayrı adımdan oluşuyor; her adımda önceki adımın bulgusu bir sonrakinin gerekçesi oldu (örneğin çarpık dağılım → log dönüşümü, overfitting → regularization gibi). Doğrusal değil, birbirini besleyen bir süreçti.

---

## 2. Veri Seti ve EDA Soruları

**S: Veri setiniz kaç satır, kaç sütun ve nereden geliyor?**
Başlangıçta 5.227 satır, 24 sütun. Açık kaynaklardan derlenmiş AI modellerine ait eğitim/donanım/emisyon bilgileri içeriyor. disclosed_electricity_used_mwh değeri 0 olan 81 kaydı çıkardıktan sonra 5.146 satır üzerinden çalıştık.

**S: Veri setinde eksik değer var mıydı, nasıl ele aldınız?**
Ham veri setinde hiçbir sütunda null değer yoktu çünkü veri seti bize ulaşmadan önce zaten imputation/sentetik tamamlama yöntemleriyle doldurulmuştu. Bunu bir sınırlılık olarak açıkça belirtiyoruz — bazı dağılımlar kusursuz gerçek dünya dağılımını yansıtmayabilir.

**S: Sentetik/imputed veri kullanmak sonuçlarınızı geçersiz kılar mı?**
Hayır, ama yorumlama koşulunu değiştirir. Modelin öğrendiği ilişkiler kısmen veri üretim metodolojisinin izlerini taşıyor olabilir. Bu yüzden çok yüksek performans gördüğümüzde bunu körü körüne kutlamak yerine, feature importance ve permutation importance ile bulguların fiziksel mantıkla (örn. compute arttıkça emisyon artması) uyumlu olup olmadığını ayrıca sorguladık.

**S: emissions_tCO2e sütununda neden sıfır değerler vardı, bunları nasıl yorumladınız?**
80 kayıt (%1,53) tam sıfırdı. Bunun "gerçekten ihmal edilebilir emisyon" mu yoksa "veri eksik" mi olduğunu ayırt etmek gerekiyordu. Bu soru bizi cleaned_emissions_tCO2e / calculation_method zincirini kurmaya yönlendirdi: sıfır değeri, başka kaynaklardan (disclosed_emissions, hesaplanan değer, compute mevcudiyeti) çapraz kontrol ederek doğruladık.

**S: Aykırı değerleri (outlier) neden silmediniz?**
Çünkü bu projede "aykırı" olan modeller (örneğin Llama-3-70B gibi devler) tam olarak ilgilendiğimiz modeller. Onları istatistiksel gürültü diye çıkarmak, projenin amacına aykırı olurdu. Bunun yerine modelin bu bölgedeki performansını ayrı ayrı ölçtük (bkz. outlier tier analizi).

**S: Kategorik değişkenlerdeki dengesizlikle (imbalance) nasıl başa çıktınız?**
Satır silme veya majority-class'tan örnek atma gibi yöntemlere başvurmadık; bu, veri setinin doğal yapısının bir parçası. Bunun yerine seyrek kategorileri (train setinde 15'ten az gözlemi olanlar) "Other" etiketi altında topladık — bilgiyi kaybetmeden modelin seyrek kategorilere aşırı uyum sağlamasını engelledik.

**S: Korelasyon analizinde en çok neyi merak ettiniz?**
Hangi değişkenlerin hedefle "gerçek" bir ilişki mi yoksa "sahte/matematiksel" bir örtüşme mi taşıdığını. Örneğin disclosed_emissions_tco2e ile korelasyon 0,986 çıktı — bu güçlü ama tehlikeli bir sinyal, çünkü bu değişken hedefin neredeyse birebir kopyası. Buna karşın training_flops (r≈0,44) güvenle kullanabileceğimiz, dolaylı bir ilişkiydi.

---

## 3. Feature Engineering Soruları

**S: Kaç feature ürettiniz ve neden bu kadarla sınırlı kaldınız?**
14 ML feature ürettik. Sayıyı bilinçli olarak sınırlı tuttuk çünkü her feature'ın somut, savunulabilir bir gerekçesi olmasını istedik — "belki işe yarar" diye rastgele feature eklemedik.

**S: Neden log dönüşümü uyguladınız, ham değerleri neden tutmadınız?**
FLOPs, parametre ve token sayıları birkaç mertebe büyüklük farkı gösteriyor ve aşırı sağa çarpık. Log1p dönüşümü hem uç değer etkisini azaltıyor hem Linear Regression için daha doğrusal bir ilişki oluşturuyor. Ham değerleri veri setinden silmedik, sadece ML tarafında log versiyonlarını tercih ettik — böylece orijinal ölçekle karşılaştırma imkânını kaybetmedik.

**S: gpu_family feature'ını nasıl oluşturdunuz?**
training_gpu_type sütunundaki onlarca farklı yazımı regex tabanlı bir eşleştirmeyle altı ana aile (A100, V100, H100, A800, H800, TPU) ve geri kalanlar için Unknown/Other kategorilerine indirdik. Bu, kategori seyrekliğini azalttı ve modelin benzer donanımları birlikte değerlendirmesini sağladı.

**S: flops_per_parameter ve flops_per_token neyi ölçüyor, neden gerekliler?**
Bir modelin ne kadar "büyük" olduğu değil, ne kadar "yoğun" eğitildiğini gösteriyorlar. Aynı parametre sayısına sahip iki model çok farklı miktarda compute ile eğitilmiş olabilir; bu oranlar ham FLOPs bilgisinden daha zengin, göreli bir bilgi taşıyor.

**S: region_carbon_intensity'yi nasıl hesapladınız?**
Her standardized_region için ortalama emission_factor_tco2e_per_mwh değerini aldık. Mantık şu: aynı miktarda enerji tüketen iki model, eğitildikleri bölgenin elektrik şebekesi karmasına göre çok farklı emisyona sahip olabilir.

**S: sustainability_score'u nasıl hesapladınız, neden bu ağırlıklar (%50/%30/%20)?**
Üç bileşen: Carbon Footprint (%50, log-normalize edilmiş emisyonun percentile-rank'i), Compute Efficiency (%30, flops_per_parameter ve flops_per_token'ın ortalama percentile-rank'i), Grid Cleanliness (%20, region_carbon_intensity'nin percentile-rank'i). Karbon ayak izine en yüksek ağırlığı verdik çünkü projenin ana odağı bu; diğer ikisi tamamlayıcı sürdürülebilirlik göstergeleri.

**S: sustainability_score'da double-counting riskini nasıl engellediniz?**
Grid Cleanliness bileşeni yalnızca region_carbon_intensity'yi kullanıyor, ham elektrik tüketimini tekrar dahil etmedik. Carbon Footprint zaten nihai emisyon değerini kullanıyor; Compute Efficiency ise tamamen farklı bir boyutu (verimlilik) ölçüyor. Aynı ham bilginin birden fazla bileşende tekrar sayılmamasına özellikle dikkat ettik.

**S: data_quality_flag'i neye göre belirlediniz?**
calculation_method, bölge bilgisinin bilinip bilinmediği ve emisyon faktörünün mevcut olup olmadığına göre high/medium/low seviyesinde bir etiket ürettik. Veri kesitimizde 3.014 kayıt "high", 2.132 kayıt "medium" kalite seviyesinde çıktı.

**S: Yeni feature eklemeyi veya mevcut feature'ları çıkarmayı düşündünüz mü?**
Feature engineering ve feature selection aşamasını uzun tuttuk ve bir kez tamamlandıktan sonra feature setini sabit kabul ettik. Yalnızca performansı artırmak için feature eklemek/çıkarmak, sonuçları yapay biçimde iyileştirme riski taşır. method feature'ını sorguladığımızda bile (bkz. ilgili soru) feature'ı çıkarmadık, sadece etkisini test edip belgeledik.

---

## 4. Data Leakage Soruları

**S: Data leakage'ı nasıl tanımlıyorsunuz ve projenizde nasıl kontrol ettiniz?**
Leakage, hedef değişkenden doğrudan veya dolaylı türetilmiş bir bilginin modele girmesi ve modelin gerçek bir ilişki yerine hedefi "geri okumasıdır". Bunu önlemek için tüm değişkenleri üç gruba ayırdık (ML Prediction / Direct Calculation / Reporting) ve ML feature listesinin yasaklı sütunlarla kesişmediğini kod içinde otomatik `assert` ifadeleriyle doğruladık.

**S: En çarpıcı leakage örneğiniz neydi?**
intensity_tCO2e_per_FLOP sütunu. Bunu emissions_tCO2e / training_flops formülüyle yeniden hesapladığımızda korelasyon 1,0000 çıktı — yani bu sütun hedefin matematiksel bir türeviydi, "güçlü feature" değil, saf bir özdeşlikti.

**S: Encoding veya scaling işlemlerinde test verisine sızıntı oldu mu?**
Hayır. One-Hot Encoding ve StandardScaler yalnızca train setine fit edildi, test setine yalnızca transform uygulandı. Aynı şekilde seyrek kategori birleştirme eşiği de yalnızca train setinden öğrenildi.

**S: Cross validation sırasında leakage riski var mıydı?**
Preprocessing adımlarının (encoding, scaling, seyrek kategori birleştirme) her fold içinde ayrı ayrı öğrenilmesi gerekir, aksi halde fold dışı bilgi sızabilir. Bizim pipeline'ımız bu ayrımı koruyacak şekilde kuruldu.

**S: sustainability_score'u neden modele feature olarak vermediniz?**
Çünkü bu skor doğrudan hedeften (cleaned_emissions_tCO2e) türetiliyor. Modele girdi olarak verilirse, model dolaylı yoldan hedefi görmüş olur — klasik bir circular dependency / leakage senaryosu. Bu yüzden skoru yalnızca final tahmin üretildikten sonra, raporlama katmanında hesapladık.

---

## 5. Modelleme Stratejisi Soruları

**S: Neden Linear Regression ve XGBoost'u seçtiniz, başka model denemediniz mi?**
Linear Regression basit, hızlı ve tamamen yorumlanabilir bir baseline sunuyor; XGBoost ise doğrusal olmayan ilişkileri ve feature etkileşimlerini yakalayabiliyor. İki modelin karşılaştırılması bize "basit bir doğrusal ilişki yeterli mi, yoksa karmaşık bir model gerçekten gerekli mi?" sorusunun cevabını verdi. Kapsamı bilinçli olarak bu iki yaklaşımla sınırladık çünkü amaç model çeşitliliği değil, metodolojik derinlikti.

**S: Hedef değişken olarak neden cleaned_emissions_tCO2e'yi seçtiniz, ham emissions_tCO2e'yi değil?**
Ham sütun, başka kaynaklardan kurtarılabilir olan sıfırları gereksiz yere kayıp bırakıyordu. cleaned_emissions_tCO2e, mevcut güvenilir bilgiyi koruyup gerektiğinde hesaplanan değeri kullanarak daha tutarlı ve eksiksiz bir hedef sundu.

**S: Neden log1p(hedef) üzerinde modelleme yaptınız?**
Hedef aşırı sağa çarpıktı (birkaç dev model ölçeği domine ediyordu). log1p, yüksek emisyonlu modellerin eğitimi domine etmesini azalttı ve hataları farklı büyüklük ölçeklerinde daha dengeli hale getirdi. log(0) tanımsız olduğu için çıplak log değil log1p tercih edildi (hedefte 0 değerleri var).

**S: Linear Regression ve XGBoost için farklı preprocessing kullanmanızın nedeni ne?**
Algoritmaların yapısı farklı. Linear Regression, kategorik değişkenleri sayısal forma çevirmek (One-Hot Encoding) ve değişkenleri aynı ölçeğe getirmek (StandardScaler) zorunda çünkü doğrusal katsayılar ölçeğe duyarlı. XGBoost ağaç tabanlı olduğu için ölçeğe duyarsız ve native categorical desteğiyle ayrı encoding'e ihtiyaç duymuyor.

**S: Train/test split'i nasıl yaptınız, neden stratifiye?**
%80/%20 oranında, log_training_flops'un çeyreklik dilimlerine göre stratifiye ederek böldük. Rastgele bir split, büyük/küçük modellerin train ve test setlerinde dengesiz dağılmasına yol açabilirdi; stratifikasyon bunu önledi (train ve test setlerinde log_training_flops ortalaması neredeyse özdeş çıktı: 46,60 vs 46,62).

**S: DummyRegressor'ı neden medyan ile kurdunuz, ortalama ile değil?**
Hedef aşırı çarpık olduğu için ortalama, birkaç uç değerden etkilenip adaletsiz bir referans noktası oluştururdu. Medyan, çarpık dağılımlarda daha sağlam (robust) bir merkezi eğilim ölçüsüdür.

---

## 6. Model Değerlendirme ve Metrik Soruları

**S: Neden tek bir metrik yerine dört metrik (MAE, RMSE, R², RMSLE) kullandınız?**
Her biri farklı bir şeyi gösteriyor. MAE ortalama hatayı sade biçimde gösterir ama büyük hataları küçük hatalarla eşit tartar. RMSE büyük hataları orantısız cezalandırır — bizim için önemli çünkü yüksek emisyonlu modellerdeki büyük hatalar kritik. R² açıklanan varyansı gösterir. RMSLE ise 0,001 tCO2e'den 8.000 tCO2e'ye kadar uzanan bir ölçekte oransal hatayı dengeli değerlendirir. Tek bir metriğe bakmak yanıltıcı bir resim verebilirdi.

**S: Linear Regression'ın test R²'si neden bu kadar düşük (0,068) çıktı, model başarısız mı?**
Hayır, bu sonuç ham (orijinal) tCO2e ölçeğinde hesaplandı ve birkaç dev model varyansın büyük kısmını yutuyor. Aynı modeli log-uzayda 5-fold CV ile değerlendirdiğimizde R² ortalaması 0,571 çıktı. Bu, "hangi ölçekte konuştuğunuz" önemli — ham ölçek ve log ölçek R²'leri doğrudan karşılaştırılabilir değil.

**S: Bu iki farklı R² değerini (ham vs log) neden ayrı raporladınız, kafa karıştırıcı değil mi?**
Tam tersine, ayrı raporlamazsak kafa karıştırıcı olur. İkisini karıştırıp tek bir "R² şu" demek yanıltıcı olurdu. Biz notebook içinde bu farkı açık bir "KRİTİK UYARI" notuyla belirttik ki hangi sayının hangi bağlamda yorumlanması gerektiği net olsun.

**S: RMSLE'yi neden özellikle önemsediniz?**
Çünkü veri setimizde emisyon değerleri 0,001 tCO2e ile 8.000+ tCO2e arasında, yani neredeyse 7 mertebe fark var. RMSE gibi mutlak hataya bakan metrikler böyle durumlarda büyük modellerdeki hataya aşırı odaklanır; RMSLE oransal hatayı ölçtüğü için küçük modellerdeki performansı da adil biçimde yansıtır.

---

## 7. Overfitting, Cross Validation ve Tuning Soruları

**S: Overfitting'i nasıl tespit ettiniz?**
Train ve test R²'leri arasındaki farka baktık. İlk XGBoost modelinde train R² = 0,97, test R² = 0,78 — 0,19'luk bir fark, ciddi bir overfitting sinyaliydi. Linear Regression'da ise fark yalnızca −0,05 idi, yani neredeyse hiç overfitting riski yoktu (zaten yeterince esnek olmayan bir model).

**S: Neden 5-fold Cross Validation kullandınız, tek bir train/test split yetmez miydi?**
Tek bir split, şans eseri kolay veya zor bir test kümesi oluşturabilir. 5-fold CV, performansın farklı veri bölünmelerinde ne kadar tutarlı olduğunu gösteriyor. Bizim durumumuzda CV standart sapması düşüktü (XGBoost için 0,027), bu da sonuçların "şanslı bir split" olmadığını kanıtladı.

**S: Hangi hiperparametreleri neden değiştirdiniz?**
max_depth'i (6→5) düşürdük çünkü derin ağaçlar veri setindeki nadir kombinasyonları ezberleyebilir; min_child_weight'i artırdık çünkü varsayılan değer az örnekli dallara izin veriyordu; reg_alpha ve reg_lambda'yı (L1/L2 regularization) ekledik çünkü model karmaşıklığını cezalandırarak overfitting'i azaltıyorlar. Bu değişikliklerle train-test farkı 0,19'dan 0,011'e düştü.

**S: Neden GridSearch değil RandomizedSearchCV kullandınız?**
Çünkü arama uzayını zaten manuel regularization denemesiyle daraltmıştık. Kapsamlı bir GridSearch, zaten mantıksız olduğunu bildiğimiz kombinasyonları da tek tek deneyerek hesaplama açısından gereksiz maliyetli olurdu. RandomizedSearchCV, dar ve gerekçeli bir uzayda 25 deneme ile yeterli oldu.

**S: Optimizasyon metriği olarak neden RMSE seçtiniz?**
Çünkü RMSE, büyük hataları orantısız cezalandırıyor — "büyük modellerde büyük hata yapmamak" önceliğimizle birebir örtüşüyor. Log-hedef üzerinde RMSE'yi optimize etmek, orijinal ölçekte RMSLE'yi optimize etmeye eşdeğerdi.

**S: Tuned modelin train R²'si (0,724) neden orijinal modelden (0,969) daha düşük ama test R²'si (0,87) daha yüksek?**
Regularization, modelin train setini "ezberlemesini" kısıtlıyor — bu yüzden train R² düşüyor. Ama bu kısıtlama, modelin daha genellenebilir örüntüler öğrenmesini sağladığı için test R² artıyor. Train-test farkının 0,19'dan −0,146'ya dönmesi, modelin artık train setine aşırı uymadığının işareti.

**S: Tuned modelin test R²'si train R²'sinden bile yüksek çıkması normal mi, şüpheli değil mi?**
Haklı bir şüphe — biz de bunu sorguladık. Bunu tek başına "harika, model süper genelliyor" diye yorumlamadık; 5-fold CV ile çapraz kontrol ettik. CV ortalaması aslında çok hafif geriledi (0,893→0,888). Bu bize, kazanımın büyük ölçüde bu özel test bölünmesinin "şansı" değil ama esas olarak train-test stabilitesindeki iyileşme olduğunu, mutlak performans artışının CV ile tam desteklenmediğini gösterdi. Bunu raporda saklamadık, açıkça not ettik.

---

## 8. Feature Importance ve method Feature'ı Soruları

**S: En önemli feature'lar hangileri, bu mantıklı mı?**
log_training_flops ve method, hem built-in hem permutation importance'ta ilk iki sırada. log_training_flops'un lider olması fizikle tam örtüşüyor: daha fazla hesaplama = daha fazla enerji = daha fazla emisyon. Bu, modelin gerçek, açıklanabilir bir ilişki öğrendiğinin güçlü bir kanıtı.

**S: Built-in ve permutation importance arasındaki fark ne, neden ikisini de kullandınız?**
Built-in (gain tabanlı) importance, çok kategorili değişkenleri (örn. standardized_region, 50+ kategori) suni biçimde daha önemli gösterme eğilimindedir çünkü bu değişkenler daha fazla bölme noktası sunar. Permutation importance, bir feature'ı rastgele karıştırıp performans düşüşünü ölçtüğü için bu yanlılıktan bağımsızdır. İkisinin aynı feature'ları öne çıkarması, sonuca olan güvenimizi artırdı.

**S: method feature'ı neden şüphe uyandırdı, bunu nasıl test ettiniz?**
method, emisyonun nasıl ölçüldüğünü gösteren bir üst-veri sütunu — tahmin anında gerçek dünyada her zaman elimizde olmayabilir. Bu riski test etmek için modeli bir kez method dahil, bir kez hariç eğittik. Test R²'deki fark yalnızca −0,013 çıktı; yani model method'a aşırı bağımlı değil, ağırlıklı olarak compute büyüklüğü gibi daha temel sinyallerden öğreniyor.

**S: method'u modelden çıkarmadınız, bu riskli değil mi?**
Test sonucunda etkisinin sınırlı olduğunu gördüğümüz için mevcut haliyle bıraktık — feature setini yalnızca performans kaygısıyla değiştirmemek, projenin genel ilkesiydi. Ama bu, production'a taşınırken method'un gerçekten erişilebilir olup olmadığının ayrıca doğrulanması gerektiği anlamına geliyor; bunu raporda bir nüans olarak belirttik.

**S: is_moe ve low_carbon_region gibi düşük importance'lı feature'ları neden çıkarmadınız?**
Düşük importance, bir feature'ın "gereksiz" olduğu anlamına gelmez — özellikle az sayıda kayıtta (örn. MoE modelleri azınlıkta) etkili olabilir. Feature seçimini yalnızca importance skoruna bakarak yapmak, projenin "yalnızca performans için feature silme" ilkesine aykırı olurdu.

---

## 9. Residual, Outlier ve Final Model Seçimi Soruları

**S: Residual analizinde en dikkat çekici bulgu neydi?**
Model hem eksik hem aşırı tahmin yapabiliyor — tek yönlü sistematik bir yanlılık yok. Örneğin Meta-Llama-3-70B'de eksik tahmin (gerçek 1010, tahmin 545,5) görürken, CLIP-ViT-B-32 gibi bazı orta ölçekli modellerde belirgin aşırı tahmin (gerçek 0,54, tahmin 298,1) gördük.

**S: Yüksek emisyonlu modellerde hata neden bu kadar büyük (69 kat)?**
Çünkü bu grup zaten mutlak değer olarak çok daha büyük sayılarla çalışıyor (ortalama gerçek değer ~28 tCO2e'ye karşı düşük grupta ~0,02 tCO2e). Asıl önemli olan mutlak hatanın büyüklüğü değil, modelin bu grupta da yön ve büyüklük olarak makul tahminler üretebilmesi.

**S: Final model seçim kriterinizi açıklar mısınız?**
Tek bir metriğe değil, yedi kritere birlikte baktık: Test R², train-test farkı, CV R² ortalaması ve std'si, MAE, RMSE, RMSLE. Karar kuralımız: "train-test farkı en az 0,03 azaldıysa VE test R² kaybı en fazla 0,05 ise tuned model seçilsin." Bu kural nesnel ve tekrarlanabilir, sübjektif bir "bence daha iyi" kararı değil.

**S: Final modeliniz neden Tuned XGBoost, Original veya Regularized değil?**
Tuned model, train-test farkında en büyük iyileşmeyi (0,19→−0,146) ve test performansında kayıp değil kazanım (0,78→0,87) gösterdi. Karar kuralımızı en iyi karşılayan oydu. Ama CV ortalamasının hafifçe gerilediğini de (0,893→0,888) not ettik — final karar bu nüansla birlikte, şeffaf biçimde verildi.

---

## 10. Hybrid Sistem, Confidence Score ve Sustainability Score Soruları

**S: Hybrid Carbon Estimation System tam olarak nasıl çalışıyor?**
Beş kademeli bir öncelik zinciri izliyor: bildirilen veri varsa doğrudan kullan → yoksa fiziksel formülle hesapla → o da yoksa ama diğer kaynaklar sıfıra işaret ediyorsa doğrulanmış sıfır kabul et → hiçbiri yoksa ML tahminine başvur. Her tahminle birlikte hangi yöntemin kullanıldığı (calculation_method) da raporlanıyor.

**S: Veri setinizde ML dalı hiç tetiklenmedi mi, bu bir sorun değil mi?**
Kullandığımız veri kesitinde (disclosed_electricity_used_mwh≠0 olan kayıtlar) tüm kayıtlar zaten "reported" olarak çözüldü, bu yüzden ML dalı fiilen tetiklenmedi. Ama sistemin bu dalının çalıştığını, hiçbir kaynağın mevcut olmadığı bir kaydı simüle ederek ayrıca doğruladık — model gerçek değeri 1,00 tCO2e olan bir kayıt için 1,04 tCO2e tahmin üretti.

**S: Confidence Score'u istatistiksel bir güven aralığı olarak mı tasarladınız?**
Hayır, bilinçli olarak kural tabanlı bir gösterge olarak tasarladık (High/Medium/Low). reported ve direct_calculation her zaman High; ML tahminleri veri kalitesine göre Medium/Low. İstatistiksel bir güven aralığı iddia etmek, sahip olmadığımız bir kesinlik hissi verirdi.

**S: sustainability_score'u final tahminle yeniden hesaplamanızın amacı ne?**
Skorun, modelin girdisi değil final karbon sonucu üzerinden hesaplanan bir raporlama metriği olduğunu kanıtlamak. Gerçek emisyon değeriyle çağrıldığında, yeniden hesaplanan skor ile veri setindeki mevcut skor birbirine çok yakın çıktı — bu da mekanizmanın tutarlı çalıştığını doğruladı.

**S: Final teknik çıktınız kullanıcıya tam olarak neyi gösteriyor?**
Model ID, Carbon Emission (tCO2e), Calculation Method, Confidence, Region, GPU Family, Sustainability Score ve Data Quality alanlarını içeren tek bir satır. Kullanıcı yalnızca bir sayı değil, o sayının nereden geldiğini ve ne kadar güvenilir olduğunu da görüyor.

---

## 11. Final Model Kaydetme ve Production Soruları

**S: Final modeli neden tüm veri seti üzerinde yeniden eğittiniz?**
Çünkü genellenebilirlik kanıtımızı (train/test split ve 5-fold CV ile) zaten aldık. Artık ayrı bir test seti tutmanın maliyeti (daha az veriyle eğitilmiş bir üretim modeli) faydasından yüksek. Bu adım, test performansını yeniden ölçmek için değil, üretim modelinin elimizdeki tüm bilgiden öğrenmesi için yapıldı.

**S: Tüm veri üzerinde eğitilen modelin metrikleri (R²=0,66) düşük görünüyor, bu bir sorun mu?**
Hayır — bu metrikler modelin kendi eğitim verisi üzerinde (fit) ölçüldü, bir "test performansı" değil. Gerçek genelleme kanıtı için Bölüm 16 (CV) ve Bölüm 23'teki (train/test) sonuçlara bakılmalı; bu rakamı onlarla karıştırmamak gerekiyor.

**S: Modeli neden joblib ile kaydettiniz, başka artefaktlar da kaydettiniz mi?**
Yalnızca modeli kaydetmek yetmez — yeni bir kayıt için tutarlı tahmin üretebilmek için feature listelerini, seyrek kategori haritasını, kategori seviyelerini ve hedef dönüşüm bilgisini de aynı pakette sakladık. Aksi halde model, eğitildiği preprocessing bağlamından koparılmış olurdu.

**S: Round-trip testi nedir, neden yaptınız?**
Kaydedilen modeli diskten tekrar yükleyip aynı verilerle aynı tahminleri üretip üretmediğini kontrol ettik. Fark tam olarak 0 çıktı. Bunu yapmasaydık, diske yazma/okuma sırasında oluşabilecek sessiz bir bozulmayı (örn. kategori sırasının değişmesi) fark etmeden production'a taşıyabilirdik.

**S: predict_carbon_emission_ml() fonksiyonu ne işe yarıyor?**
Yeni bir AI modeli geldiğinde, gerekli preprocessing'i (seyrek kategori birleştirme, kategori hizalama) otomatik uygulayıp modeli çağıran ve tahmini orijinal tCO2e ölçeğine çeviren tek bir arayüz sunuyor. Modelin her seferinde yeniden eğitilmesine gerek kalmıyor.

---

## 12. Zor / Eleştirel Sorular

**S: Bu model gerçekten güvenilir mi, yoksa sadece iyi görünen sayılar mı ürettiniz?**
Tamamen "mükemmel" demiyoruz — CV/tek-split nüansını, method feature'ının riskini, yüksek emisyonlu modellerdeki büyük hataları ve sentetik veri sınırlılığını raporda açıkça belirttik. Güvenilirlik iddiamız "hatasız bir model" değil, "sınırları bilinen, şeffaf biçimde raporlanmış bir model".

**S: Sonuçlarınız gerçek ölçüm verisiyle doğrulandı mı, yoksa hâlâ veri setine mi bağımlısınız?**
Kullandığımız "bildirilen" (disclosed/reported) değerler büyük ölçüde kaynakların kendi beyanına dayanıyor; bağımsız, üçüncü taraf doğrulamalı bir ölçüm setiyle çapraz doğrulama yapılmadı. Bunu bir sınırlılık olarak açıkça belirtiyoruz.

**S: Veri setiniz dengesiz (örn. Unknown/US bölgeleri baskın), bu modelin genel geçerliliğini etkilemiyor mu?**
Etkiliyor olabilir — az temsil edilen bölge/donanım kombinasyonlarında tahminler daha az güvenilir olabilir. Bunu düzeltmek için satır silme/kategori kaldırma gibi yöntemlere başvurmadık çünkü bu, veri setinin doğal yapısını bozardı; bunun yerine seyrek kategorileri güvenli biçimde birleştirdik ve bu sınırlılığı raporda belirttik.

**S: Neden daha fazla model denemediniz (örn. Random Forest, Neural Network)?**
Projenin amacı model çeşitliliği yarıştırmak değil, seçilen iki yaklaşımı (basit/yorumlanabilir vs. karmaşık/güçlü) metodolojik derinlikle karşılaştırmaktı. Zaman ve kapsam sınırları içinde, XGBoost'un zaten güçlü bir doğrusal olmayan model olması nedeniyle ek ağaç tabanlı modeller marjinal katkı sağlayacaktı; bu, gelecek çalışma önerisi olarak değerlendirilebilir.

**S: Modelin RMSE'si (17,35 tCO2e) yüksek görünüyor, bu kabul edilebilir mi?**
Hedef değişkenin 0,001'den 8.000+ tCO2e'ye kadar uzandığı düşünüldüğünde, RMSE'nin büyük ölçekli modellerden etkilenmesi beklenen bir durum. Daha adil bir değerlendirme için RMSLE'ye (0,327) ve emisyon seviyesine göre gruplu MAE'ye bakılmalı — düşük emisyon grubunda MAE yalnızca 0,09 tCO2e.

**S: Projenizin en zayıf noktası nedir?**
Muhtemelen, final model kararının CV ortalamasıyla tam desteklenmeyen bir tek-split iyileşmesine dayanması ve ML dalının gerçek veri üzerinde hiç tetiklenmemiş olması (yalnızca simülasyonla test edilebilmesi). Bu iki noktayı raporda saklamadık, aksine ayrı birer bölümde ele aldık.

**S: Bu sistemi gerçek bir üretim ortamına koymadan önce ne eklerdiniz?**
Bağımsız/üçüncü taraf doğrulamalı gerçek ölçüm verisiyle çapraz doğrulama, method feature'ının production'da gerçekten erişilebilir olup olmadığının netleştirilmesi ve az temsil edilen bölge/donanım kombinasyonları için ek veri toplanması öncelikli olurdu.

---

*Bu doküman, sunumu takiben gelebilecek soruları öngörmek amacıyla hazırlanmıştır; tüm sayısal değerler projenin gerçek notebook çıktılarından alınmıştır.*
