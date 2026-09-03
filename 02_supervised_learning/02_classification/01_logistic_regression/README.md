# Lojistik Regresyon (Logistic Regression)

## 1. Giriş — Lojistik Regresyon Nedir?

Lojistik regresyon, **sınıflandırma** problemleri için kullanılan denetimli (supervised) bir makine öğrenmesi algoritmasıdır. İsminde "regresyon" geçmesine rağmen aslında bir **sınıflandırma** yöntemidir; bu, sınavlarda en sık karıştırılan noktalardan biridir.

**Temel Mantık:** Lineer regresyonda çıktı sürekli bir sayıdır (örn. bir evin fiyatı). Sınıflandırmada ise çıktının belirli bir sınıfa (örn. "hasta" / "sağlıklı", "evet" / "hayır") ait olma **olasılığı** hesaplanmak istenir. Lojistik regresyon, lineer bir kombinasyonun çıktısını **sigmoid fonksiyonundan** geçirerek bunu 0 ile 1 arasında bir olasılığa dönüştürür.

## 2. Matematiksel Temel

## 2.1. Lineer Kombinasyon (z)

Önce, tıpkı lineer regresyonda olduğu gibi, özniteliklerin ağırlıklı toplamı hesaplanır:

$$z = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \dots + \beta_n x_n$$

- $\beta_0$: kesişim (bias/intercept) terimi
- $\beta_1, \dots, \beta_n$: her özniteliğe karşılık gelen katsayılar (ağırlıklar)
- $x_1, \dots, x_n$: giriş öznitelikleri

Buraya kadar lineer regresyon ile birebir aynıdır. Fark, bir sonraki adımda ortaya çıkar.

## 2.2. Sigmoid (Lojistik) Fonksiyonu

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

Bu fonksiyon **herhangi bir gerçel sayıyı 0 ile 1 arasına sıkıştırır**:

- $z \to +\infty \Rightarrow \sigma(z) \to 1$
- $z \to -\infty \Rightarrow \sigma(z) \to 0$
- $z = 0 \Rightarrow \sigma(z) = 0.5$

Bu özellik sayesinde $\sigma(z)$ çıktısı doğrudan **"pozitif sınıfa ait olma olasılığı"** olarak yorumlanabilir: $\hat{y} = P(y=1 \mid x)$.

**Neden bu fonksiyon seçilmiştir?** Sigmoid, S şeklinde (S-curve), her yerde türevlenebilir ve monoton artan bir fonksiyondur. Bu özellikler, gradyan tabanlı optimizasyon (gradient descent) için idealdir ve olasılık yorumuna izin verir.

## 2.3. Karar Sınırı (Decision Boundary)

Model bir olasılık üretir; bu olasılığı bir sınıfa çevirmek için bir **eşik değeri** (genelde 0.5) kullanılır:

- $\sigma(z) \geq 0.5 \Rightarrow$ sınıf 1 tahmini
- $\sigma(z) < 0.5 \Rightarrow$ sınıf 0 tahmini

$\sigma(z) = 0.5$ olduğu nokta tam olarak $z = 0$ noktasına denk gelir; yani karar sınırı, öznitelik uzayında $\beta_0 + \beta_1 x_1 + \dots + \beta_n x_n = 0$ denklemiyle tanımlanan bir **doğru/düzlemdir**. Bu yüzden lojistik regresyon "doğrusal bir sınıflandırıcı" (linear classifier) olarak kabul edilir.

**Eşik değeri neden değiştirilir?** Dengesiz veri setlerinde (örn. pozitif sınıf çok az), eşik 0.5'ten düşürülerek modelin daha fazla pozitif tahmin yapması (recall'u artırmak için) sağlanabilir; bu, precision-recall dengesini değiştirir.

## 2.4. Maliyet Fonksiyonu — Çapraz Entropi (Cross-Entropy / Log-Loss)

Model, katsayıları ($\beta$) öğrenirken şu fonksiyonu **minimize edecek** şekilde eğitilir:

$$J(\beta) = -\frac{1}{m} \sum_{i=1}^{m} \Big[ y_i \log(\hat{y}_i) + (1 - y_i) \log(1 - \hat{y}_i) \Big]$$

**Neden Ortalama Kare Hata (MSE) değil?** Sınıflandırma problemlerinde MSE kullanılırsa, sigmoid fonksiyonunun doğrusal olmayan yapısı yüzünden maliyet fonksiyonu **dış bükey (non-convex)** hale gelir; bu da gradyan inişinin yerel minimumlarda takılmasına yol açabilir. Çapraz entropi ise lojistik regresyon için **konveks (convex)** bir fonksiyondur, yani tek bir global minimuma sahiptir.

**Sezgi:** Eğer gerçek etiket $y=1$ ise, formülün sadece $-\log(\hat{y})$ kısmı aktif olur: $\hat{y}$ 1'e yakınsa kayıp 0'a yaklaşır, $\hat{y}$ 0'a yakınsa kayıp sonsuza gider (modeli ağır şekilde cezalandırır). $y=0$ için simetrik mantık geçerlidir.

## 2.5. Gradyan İnişi (Gradient Descent)

Katsayılar, maliyet fonksiyonunun gradyanına göre iteratif olarak güncellenir:

$$\beta_j := \beta_j - \alpha \frac{\partial J}{\partial \beta_j}$$

- $\alpha$ (öğrenme oranı / learning rate): her adımda ne kadar büyük bir güncelleme yapılacağını kontrol eder.
- Çok büyük $\alpha$: optimizasyon minimumun etrafında salınabilir veya ıraksayabilir.
- Çok küçük $\alpha$: eğitim çok yavaş ilerler.

scikit-learn'de bu optimizasyon genelde `lbfgs`, `liblinear`, `saga` gibi hazır **solver**'lar aracılığıyla yapılır; bunlar klasik gradyan inişinin daha verimli varyantlarıdır.

## 3. Model Kurulumu — Uygulama Adımları (Veri Setinden Bağımsız)

Herhangi bir veri seti için lojistik regresyon uygulama süreci genel olarak şu adımları izler:

1. **Veriyi yükleme ve keşfetme:** Sütunlar, veri tipleri, eksik değerler, hedef değişkenin sınıf dağılımı incelenir.
2. **Özellik ve hedef ayırma:** Bağımsız değişkenler ($X$) ile hedef değişken ($y$) birbirinden ayrılır.
3. **Kategorik değişkenlerin kodlanması:** Metinsel/kategorik sütunlar One-Hot Encoding (ya da gerekirse Label/Ordinal Encoding) ile sayısal forma çevrilir.
4. **Eğitim/Test ayrımı:** Veri genelde %80/%20 oranında `train_test_split` ile bölünür; sınıf dengesizliği varsa `stratify=y` kullanılarak sınıf oranlarının her iki sette de korunması sağlanır.
5. **Özellik ölçeklendirme:** `StandardScaler` ile öznitelikler standartlaştırılır (ortalama 0, standart sapma 1). Bu adım, gradyan tabanlı optimizasyonun daha kararlı ve hızlı yakınsaması için önemlidir.
6. **Model eğitimi:** `LogisticRegression` sınıfı, eğitim verisiyle `fit()` edilir.
7. **Değerlendirme:** Test verisi üzerinde tahmin yapılır ve çeşitli metriklerle performans ölçülür.

## 4. Hiperparametreler

| Parametre | Anlamı | Etkisi |
|---|---|---|
| `penalty` | Regularizasyon türü (`l1`, `l2`, `elasticnet`, `none`) | Aşırı öğrenmeyi kontrol eder |
| `C` | Regularizasyon şiddetinin **tersi** | Küçük `C` → güçlü regularizasyon (daha basit model); büyük `C` → zayıf regularizasyon (eğitim verisine daha sıkı uyum) |
| `solver` | Optimizasyon algoritması (`lbfgs`, `liblinear`, `saga`, ...) | Veri boyutuna ve penalty türüne göre seçilir |
| `max_iter` | Maksimum iterasyon sayısı | Model yakınsamazsa artırılır |
| `class_weight` | Sınıflara verilen ağırlık (`None` veya `'balanced'`) | Dengesiz veri setlerinde azınlık sınıfına daha fazla önem verir |

**L1 vs L2 Regularizasyon:**

- **L1 (Lasso):** Katsayıların toplam mutlak değerini cezalandırır; bazı katsayıları tam olarak **0** yapabilir → doğal bir özellik seçimi (feature selection) etkisi yaratır.
- **L2 (Ridge):** Katsayıların karelerinin toplamını cezalandırır; katsayıları küçültür ama nadiren tam sıfıra indirir.

## 5. Model Değerlendirme Metrikleri

Bir lojistik regresyon modelinin performansı tek bir metrikle değil, birden fazla metrikle değerlendirilmelidir:

- **Accuracy (Doğruluk):** Doğru tahmin edilen örneklerin toplam örneklere oranı. Dengesiz veri setlerinde **yanıltıcı** olabilir.
- **Precision (Hassasiyet):** Pozitif tahmin edilenlerin ne kadarının gerçekten pozitif olduğu. $\frac{TP}{TP+FP}$
- **Recall / Duyarlılık:** Gerçek pozitiflerin ne kadarının doğru yakalandığı. $\frac{TP}{TP+FN}$
- **F1-Skoru:** Precision ve Recall'un harmonik ortalaması: $2 \cdot \frac{P \cdot R}{P + R}$
- **ROC-AUC:** Modelin farklı eşik değerlerindeki ayırt etme gücünü özetler; 1'e yakın değerler daha iyidir, 0.5 rastgele tahmine denk gelir.
- **Karışıklık Matrisi (Confusion Matrix):** TP (True Positive), TN (True Negative), FP (False Positive), FN (False Negative) sayılarını gösteren 2x2 tablo; diğer tüm metrikler buradan türetilir.

**Sınavda dikkat:** Dengesiz sınıflı problemlerde (örn. pozitif sınıf %10) sadece accuracy'e bakmak yanıltıcıdır — model her örneği "negatif" tahmin ederek bile %90 accuracy elde edebilir. Bu yüzden precision/recall/F1/AUC birlikte değerlendirilmelidir.

## 6. Katsayıların Yorumlanması

Eğitim sonrası her özniteliğe karşılık bir katsayı ($\beta_i$) elde edilir:

- **Pozitif katsayı:** İlgili özniteliğin değeri arttıkça, pozitif sınıfa (1) ait olma olasılığı (log-odds üzerinden) artar.
- **Negatif katsayı:** İlgili özniteliğin değeri arttıkça, pozitif sınıfa ait olma olasılığı azalır.
- **Katsayının mutlak büyüklüğü:** (Özellikler ölçeklendirilmişse) o özniteliğin modeldeki göreli etkisinin büyüklüğünü gösterir.

Matematiksel olarak, $\beta_i$ katsayısı **log-odds** (logit) üzerindeki etkiyi ifade eder:

$$\log\left(\frac{P(y=1)}{1-P(y=1)}\right) = \beta_0 + \beta_1 x_1 + \dots + \beta_n x_n$$

## 7. Avantajlar ve Dezavantajlar

**Avantajları:**

- Basit, hızlı eğitilir, yorumlanabilir (katsayılar üzerinden).
- Olasılık çıktısı verir (sadece sınıf etiketi değil).
- Az sayıda hiperparametre ile iyi sonuçlar verebilir.
- Doğrusal olarak ayrılabilir problemlerde çok etkilidir.

**Dezavantajları:**

- Doğrusal karar sınırı varsayımı; karmaşık, doğrusal olmayan ilişkileri yakalayamaz (polinom öznitelikler eklenmedikçe).
- Aykırı değerlere (outlier) duyarlı olabilir.
- Çoklu doğrusal bağlantı (multicollinearity) katsayı yorumunu zorlaştırabilir.
- Çok sayıda kategorik değişken one-hot encode edildiğinde boyut artışı (curse of dimensionality) yaşanabilir.

## 8. Sık Sorulan / Karıştırılan Noktalar

1. **"Lojistik regresyon bir regresyon algoritmasıdır" — Yanlış.** Sınıflandırma algoritmasıdır; adı tarihsel nedenlerle (logit fonksiyonundan) gelir.
2. **Sigmoid ile Softmax farkı:** Sigmoid ikili (binary) sınıflandırma için kullanılırken, çok sınıflı problemlerde **Softmax fonksiyonu** (multinomial lojistik regresyon) kullanılır.
3. **Ölçeklendirme şart mı?** Model matematiksel olarak ölçeklendirme olmadan da çalışır, ancak gradyan inişinin yakınsama hızı ve düzenli (regularized) modellerin adil katsayı karşılaştırması için ölçeklendirme şiddetle önerilir.
4. **`C` parametresi ile regularizasyon ters orantılıdır:** Küçük `C` = güçlü regularizasyon (bu, ilk bakışta kafa karıştırıcı olabilir).

## 9. Özet Tablo

| Kavram | Formül / Açıklama |
|---|---|
| Lineer kombinasyon | $z = \beta_0 + \beta_1 x_1 + \dots + \beta_n x_n$ |
| Sigmoid fonksiyonu | $\sigma(z) = \dfrac{1}{1+e^{-z}}$ |
| Karar sınırı | $\sigma(z) \geq 0.5 \Rightarrow$ sınıf 1 |
| Maliyet fonksiyonu | Çapraz Entropi (Log-Loss) |
| Optimizasyon | Gradyan İnişi / lbfgs, liblinear, saga |
| Regularizasyon | L1 (Lasso) / L2 (Ridge) |
| Değerlendirme | Accuracy, Precision, Recall, F1, ROC-AUC |
