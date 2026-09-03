# K-En Yakın Komşu (KNN)

## 1. Giriş — KNN Nedir?

**K-En Yakın Komşu (KNN)**, hem sınıflandırma hem regresyon problemlerinde kullanılabilen, "parametrik olmayan" (non-parametric) ve **tembel öğrenme (lazy learning)** yapan basit ama etkili bir algoritmadır.

**"Tembel öğrenme" ne demektir?** KNN, eğitim aşamasında herhangi bir model/katsayı **öğrenmez**; sadece tüm eğitim verisini hafızasında tutar. Gerçek hesaplama, ancak yeni bir tahmin istendiğinde (tahmin anında) yapılır. Bu, lojistik regresyon veya SVM gibi "istekli öğrenen (eager learning)" modellerin tam tersidir — onlar eğitim sırasında sabit sayıda parametre (katsayı) öğrenir.

**"Parametrik olmayan" ne demektir?** Model, veri dağılımı hakkında önceden belirlenmiş sabit sayıda parametre varsaymaz; model karmaşıklığı, elimizdeki veri miktarıyla birlikte büyür ve karar doğrudan depolanan verilere dayanır.

## 2. Algoritmanın Çalışma Mantığı

Yeni bir örnek için tahmin yapılırken KNN şu adımları izler:

1. **Mesafe hesabı:** Yeni örnek ile eğitim setindeki **tüm örnekler** arasındaki mesafe hesaplanır.
2. **En yakın k komşuyu bulma:** Mesafeler küçükten büyüğe sıralanır ve en yakın **k** komşu seçilir.
3. **Karar verme:**
   - **Sınıflandırmada:** k komşunun **çoğunluk sınıfı** yeni örneğe atanır (oylama).
   - **Regresyonda:** k komşunun hedef değerlerinin **ortalaması** alınır.

Bu mantık son derece sezgiseldir: "Bana arkadaşlarını söyle, sana kim olduğunu söyleyeyim" prensibine benzer — bir örneğin sınıfı, ona en çok benzeyen (en yakın) örneklerin sınıfına göre belirlenir.

## 3. Mesafe Ölçütleri

KNN'in kalbi, "yakınlık" kavramını matematiksel olarak tanımlayan **mesafe fonksiyonlarıdır**.

## 3.1. Öklid (Euclidean) Mesafesi — En Yaygın Kullanılan

$$d(x, x') = \sqrt{\sum_{i=1}^{n}(x_i - x'_i)^2}$$

İki nokta arasındaki "kuş uçuşu" (düz çizgi) mesafesidir; en sezgisel ve en sık kullanılan ölçüttür.

## 3.2. Manhattan Mesafesi

$$d(x, x') = \sum_{i=1}^{n}|x_i - x'_i|$$

Koordinatlar arasındaki farkların mutlak değerlerinin toplamıdır; adını, bir şehirde (Manhattan gibi ızgara planlı) yalnızca yatay/dikey hareket ederek gidilen yoldan alır. Yüksek boyutlu verilerde bazen Öklid'den daha kararlı sonuç verebilir.

## 3.3. Minkowski Mesafesi (Genel Form)

$$d(x, x') = \left(\sum_{i=1}^{n}|x_i - x'_i|^p\right)^{1/p}$$

- $p=1$ olduğunda Manhattan mesafesine,
- $p=2$ olduğunda Öklid mesafesine indirgenir.

## 3.4. Chebyshev Mesafesi

$$d(x, x') = \max_i |x_i - x'_i|$$

Sadece en büyük farkı dikkate alır; belirli özel uygulamalarda (örn. satranç tahtasında hamle mesafesi) kullanılır.

**Sınavda dikkat:** Mesafe ölçütü de bir **hiperparametredir**; farklı ölçütler farklı sonuçlar verebilir ve probleme göre en uygun olanı cross-validation ile seçilmelidir.

## 4. k Değerinin Önemi

k, KNN'in en kritik hiperparametresidir ve model karmaşıklığını doğrudan belirler.

| k Değeri | Etki | Risk |
|---|---|---|
| **Çok küçük** (örn. k=1) | Model, tek bir en yakın komşuya göre karar verir; karar sınırı çok "pürüzlü" ve esnek olur | **Overfitting** — gürültüye/aykırı değerlere karşı çok hassas |
| **Uygun** (genelde cross-validation ile bulunur) | Model, gürültüyü yumuşatırken önemli örüntüleri de yakalar | En iyi genelleme |
| **Çok büyük** | Çok fazla komşu oylamaya katılır, karar sınırı aşırı "yumuşar"/basitleşir | **Underfitting** — modelin önemli yerel örüntüleri kaçırması |

**En uygun k nasıl bulunur?** Genellikle çeşitli k değerleri (örn. 1'den 20'ye kadar) denenir, her biri için **cross-validation skoru** hesaplanır ve en yüksek/en dengeli skoru veren k seçilir. Bu yaklaşıma bazen **"dirsek yöntemi" (elbow method)** de denir — eğitim/test doğruluğu grafiğinde skorun stabilize olduğu "dirsek" noktası seçilir.

**Pratik bir ipucu:** k değeri genellikle **tek sayı** seçilir (özellikle ikili sınıflandırmada); bu, oylamada eşitlik (berabere kalma) durumunu önler.

## 5. Neden Özellik Ölçeklendirmesi Zorunludur?

KNN, tamamen **mesafe hesaplarına** dayandığından, öznitelikler farklı ölçeklerdeyse (örn. biri 0-1 arası, diğeri 0-10000 arası) büyük ölçekli öznitelik mesafe hesabına **haksız şekilde hakim olur** ve küçük ölçekli ama aslında önemli olabilecek öznitelikler göz ardı edilir.

**Çözüm:** Eğitimden önce `StandardScaler` (ortalama 0, standart sapma 1) veya `MinMaxScaler` (0-1 aralığına sıkıştırma) gibi bir ölçeklendirme yöntemi mutlaka uygulanmalıdır. Bu, tıpkı SVM'de olduğu gibi, mesafe tabanlı algoritmalar için **kritik bir ön işleme adımıdır**.

## 6. Model Kurulumu — Uygulama Adımları (Veri Setinden Bağımsız)

1. **Veri keşfi:** Öznitelikler, hedef değişkenin sınıf dağılımı incelenir; özellikle küçük/dengesiz veri setlerinde her sınıftan yeterli örnek olup olmadığına dikkat edilir.
2. **Özellik ve hedef ayırma:** $X$ ve $y$ ayrılır.
3. **Eğitim/test ayrımı:** `train_test_split` ile bölünür; çok sınıflı ve dengesiz veri setlerinde `stratify=y` kullanılması, az örnekli sınıfların test setinde hiç temsil edilmeme riskini azaltır.
4. **Özellik ölçeklendirme (ZORUNLU):** `StandardScaler` ile öznitelikler standartlaştırılır.
5. **En iyi k'nın bulunması:** Farklı k değerleri için cross-validation skorları karşılaştırılır.
6. **Model eğitimi:** `KNeighborsClassifier(n_neighbors=k)` ile model "eğitilir" (aslında sadece veri saklanır).
7. **Değerlendirme:** Test setinde tahmin yapılıp performans metrikleriyle değerlendirilir.
8. **(Opsiyonel) Mesafe ölçütü karşılaştırması:** Farklı `metric` değerleriyle (`euclidean`, `manhattan` vb.) sonuçlar karşılaştırılabilir.

## 7. Model Değerlendirme

KNN için de standart sınıflandırma metrikleri kullanılır:

- **Accuracy, Precision, Recall, F1-Skoru:** Özellikle çok sınıflı ve dengesiz veri setlerinde `classification_report` ile sınıf bazında incelenmelidir.
- **Karışıklık Matrisi (Confusion Matrix):** Hangi sınıfların birbiriyle sıkça karıştırıldığını gösterir.
- **`kneighbors()` çıktısı:** Bir tahminin hangi komşulara ve ne kadar yakınlığa dayandığını incelemeyi sağlar; bu, modelin "neden bu tahmini yaptığını" yorumlamaya yardımcı olur (bir tür yorumlanabilirlik/explainability aracı).

## 8. Avantajlar ve Dezavantajlar

**Avantajları:**

- Anlaşılması ve uygulanması çok basittir; sezgisel bir mantığa dayanır.
- Eğitim aşaması yoktur (veri sadece saklanır), bu yüzden "eğitim süresi" neredeyse sıfırdır.
- Doğrusal olmayan karar sınırlarını doğal olarak öğrenebilir (herhangi bir fonksiyon biçimi varsaymaz).
- Hem sınıflandırma hem regresyon problemlerinde kullanılabilir.

**Dezavantajları:**

- **Tahmin aşaması yavaştır:** Her yeni tahmin için eğitim setindeki tüm örneklerle mesafe hesaplanması gerekir; büyük veri setlerinde bu ciddi bir performans sorunudur (bu yüzden "tembel öğrenme" hem avantaj hem dezavantajdır).
- **Boyut laneti (curse of dimensionality):** Öznitelik sayısı arttıkça, tüm noktalar birbirine "eşit derecede uzak" görünmeye başlar ve mesafe kavramı anlamını yitirir; bu, yüksek boyutlu verilerde KNN performansını ciddi şekilde düşürebilir.
- **Ölçeklendirmeye aşırı duyarlıdır:** Ölçeklendirme yapılmazsa sonuçlar büyük ölçüde yanlış olabilir.
- **Bellek kullanımı yüksektir:** Tüm eğitim verisi saklanmalıdır (model, veriden ayrı, "sıkıştırılmış" bir temsil öğrenmez).
- **Dengesiz veri setlerinde zayıf kalabilir:** Çoğunluk sınıfının komşulukta baskın çıkması, azınlık sınıfının doğru tahmin edilme oranını düşürebilir.

## 9. Sık Sorulan / Karıştırılan Noktalar

1. **"KNN, k-means kümeleme (clustering) ile aynı şeydir" — Yanlış.** KNN **denetimli (supervised)** bir sınıflandırma/regresyon algoritmasıdır (etiketli veri gerektirir); K-Means ise **denetimsiz (unsupervised)** bir kümeleme algoritmasıdır (etiket gerektirmez). Sadece "K" harfini ve mesafe kavramını paylaşırlar.
2. **"KNN parametre öğrenmez, o yüzden hiperparametresi de yoktur" — Yanlış.** Model iç parametre (katsayı) öğrenmez, ama **k değeri, mesafe ölçütü, ağırlıklandırma stratejisi (uniform/distance)** gibi önemli hiperparametreleri vardır.
3. **k=1 her zaman en iyi sonucu mu verir?** Hayır; k=1 eğitim verisinde mükemmele yakın performans gösterebilir (çünkü bir noktanın en yakın komşusu genelde kendisidir) ama bu genelde **overfitting**'in bir işaretidir ve test performansı daha düşük olabilir.
4. **KNN büyük veri setlerinde neden tercih edilmez?** Her tahmin, tüm eğitim verisiyle mesafe karşılaştırması gerektirdiğinden, veri seti büyüdükçe tahmin süresi doğrusal (veya daha kötü) şekilde artar; bu yüzden çok büyük veri setlerinde yaklaşık en yakın komşu (approximate nearest neighbor) yöntemleri veya farklı algoritmalar tercih edilir.

## 10. Özet Tablo

| Kavram | Formül / Açıklama |
|---|---|
| Öklid Mesafesi | $\sqrt{\sum (x_i-x'_i)^2}$ |
| Manhattan Mesafesi | $\sum \lvert x_i-x'_i \rvert$ |
| Minkowski Mesafesi | $(\sum \lvert x_i-x'_i \rvert^p)^{1/p}$ |
| k'nın etkisi | Küçük k → overfitting; Büyük k → underfitting |
| En iyi k'nın bulunması | Cross-validation / dirsek yöntemi |
| Ölçeklendirme İhtiyacı | Zorunlu (mesafe tabanlı algoritma) |
| Öğrenme türü | Tembel öğrenme (lazy learning), parametrik olmayan |
| Ana zayıflık | Boyut laneti, büyük veride yavaş tahmin |
