# Support Vector Machine (SVM)

## 1. Giriş — SVM Nedir?

**Support Vector Machine (Destek Vektör Makinesi)**, sınıfları birbirinden ayıran **en iyi karar sınırını (hyperplane)** bulmaya çalışan, denetimli bir öğrenme algoritmasıdır. Hem sınıflandırma (SVC) hem de regresyon (SVR) problemlerinde kullanılabilir; bu notta sınıflandırma versiyonuna odaklanılmıştır.

**Temel Kavramlar:**

- **Hyperplane (Hiper-düzlem):** Sınıfları ayıran doğru/düzlem/yüzey. 2 boyutlu uzayda bir doğru, 3 boyutlu uzayda bir düzlemdir; daha yüksek boyutlarda genel olarak "hiper-düzlem" denir.
- **Support Vector (Destek Vektörü):** Hiper-düzleme **en yakın** olan, karar sınırını doğrudan belirleyen eğitim örnekleri.
- **Margin (Marj):** Hiper-düzlem ile en yakın destek vektörleri arasındaki mesafe. SVM bu marjı **maksimize** etmeye çalışır.

## 2. Matematiksel Temel

## 2.1. Maksimum Marj Prensibi

Doğrusal olarak ayrılabilen bir veri setinde, sınıfları ayıran sonsuz sayıda doğru/düzlem çizilebilir. SVM, bunlar arasından **marjini maksimize eden** düzlemi seçer:

$$w \cdot x + b = 0$$

Burada $w$ hiper-düzlemin normal vektörü, $b$ ise bias terimidir. Amaç fonksiyonu:

$$\min_{w,b} \frac{1}{2}\|w\|^2 \quad \text{öyle ki} \quad y_i(w \cdot x_i + b) \geq 1 \; \forall i$$

**Neden marjini maksimize etmek önemli?** Geniş bir marj, modelin eğitim verisine aşırı uyum sağlamak yerine daha **genel (generalizable)** bir sınır öğrenmesini sağlar; bu da yeni/görülmemiş verilerde daha iyi performans anlamına gelir.

## 2.2. Yumuşak Marj (Soft Margin) ve C Parametresi

Gerçek dünya verileri nadiren mükemmel şekilde doğrusal olarak ayrılabilir. Bu yüzden SVM, bazı örneklerin marjin içinde kalmasına ya da yanlış sınıflandırılmasına **izin veren** bir "yumuşak marj" (soft margin) yaklaşımı kullanır:

$$\min_{w,b,\xi} \frac{1}{2}\|w\|^2 + C\sum_{i=1}^{m}\xi_i$$

- $\xi_i$ (ksi): her örnek için "ihlal miktarı" (slack variable).
- **C parametresi**, marjin genişliği ile sınıflandırma hatası arasındaki dengeyi kontrol eder:
  - **Küçük C:** Modele daha fazla hataya izin verilir → daha **geniş** marj, daha **basit** (yüksek bias, düşük varyans) model.
  - **Büyük C:** Hatalara daha az tolerans gösterilir → daha **dar** marj, eğitim verisine daha sıkı uyum (düşük bias, yüksek varyans) → overfitting riski artar.

## 2.3. Kernel Trick (Çekirdek Hilesi)

Veri **doğrusal olarak ayrılamıyorsa**, SVM veriyi daha yüksek boyutlu bir uzaya taşıyan bir dönüşüm uygular; bu yeni uzayda veri doğrusal olarak ayrılabilir hale gelebilir. Bu dönüşümü açıkça hesaplamak yerine, **kernel fonksiyonları** iki nokta arasındaki iç çarpımı doğrudan yüksek boyutlu uzayda hesaplar (bu yüzden "hile" denir — asıl dönüşüm hiç hesaplanmaz, sadece sonucu hesaplanır).

| Kernel | Formül | Kullanım Alanı |
|---|---|---|
| **Linear** | $K(x,x') = x \cdot x'$ | Veri doğrusal olarak ayrılabiliyorsa |
| **RBF (Radial Basis Function)** | $K(x,x') = \exp(-\gamma\|x-x'\|^2)$ | Doğrusal olmayan, karmaşık ilişkiler (en popüler/varsayılan) |
| **Polynomial** | $K(x,x') = (x \cdot x' + c)^d$ | Polinom dereceli ilişkiler; $d$ derece parametresidir |
| **Sigmoid** | $K(x,x') = \tanh(\alpha \, x\cdot x' + c)$ | Nadiren kullanılır, sinir ağlarına benzer davranış |

## 2.4. Gamma (γ) Parametresi (RBF / Poly Kernel için)

Gamma, bir eğitim örneğinin etki alanının ne kadar geniş/dar olduğunu belirler:

- **Küçük gamma:** Her örneğin etkisi geniş bir alana yayılır → daha **yumuşak/genel** karar sınırı (underfitting riski).
- **Büyük gamma:** Her örneğin etkisi sadece kendi yakın çevresiyle sınırlıdır → daha **dar/yerel/karmaşık** karar sınırı (overfitting riski).

**C ve gamma birlikte düşünülmelidir:** İkisi de model karmaşıklığını etkiler; büyük C + büyük gamma kombinasyonu genelde ciddi overfitting riskine yol açar.

## 3. Model Kurulumu — Uygulama Adımları (Veri Setinden Bağımsız)

1. **Veri keşfi:** Öznitelikler ve hedef değişken (sınıflar) incelenir.
2. **Kategorik değişkenlerin sayısallaştırılması:** LabelEncoder veya One-Hot Encoding kullanılır.
3. **Hedef değişkenin kodlanması:** Metinsel etiketler (örn. "evet"/"hayır") LabelEncoder ile sayısala çevrilir.
4. **Eğitim/Test ayrımı:** `train_test_split` ile bölünür; sınıf dengesizliği varsa `stratify` kullanılır.
5. **Özellik ölçeklendirme (ZORUNLU):** SVM mesafe/iç-çarpım tabanlı bir algoritma olduğundan, `StandardScaler` ile ölçeklendirme yapılmadan farklı ölçekli öznitelikler modeli ciddi şekilde yanıltır.
6. **Kernel seçimi ve model eğitimi:** Linear, RBF, Polynomial gibi farklı kerneller denenip karşılaştırılabilir.
7. **Hiperparametre optimizasyonu:** `GridSearchCV` (veya `RandomizedSearchCV`) ile en iyi `C`, `gamma`, `kernel` kombinasyonu çapraz doğrulama ile bulunur.
8. **Değerlendirme:** Test setinde performans metrikleri hesaplanır.

## 4. GridSearchCV ile Hiperparametre Optimizasyonu

```
param_grid = {
    'C': [0.1, 1, 10, 100],
    'gamma': ['scale', 'auto', 0.1, 0.01],
    'kernel': ['rbf']
}
GridSearchCV(SVC(), param_grid, cv=5, scoring='accuracy')
```

**Nasıl çalışır?** GridSearchCV, verilen parametre ızgarasındaki **tüm kombinasyonları** dener; her kombinasyon için veriyi `cv` (örn. 5) parçaya bölüp çapraz doğrulama yapar ve en yüksek ortalama skoru veren kombinasyonu seçer. Bu, elle deneme-yanılma yapmaktan çok daha sistematik ve güvenilirdir.

`gamma='scale'` (scikit-learn varsayılanı), gamma değerini `1 / (n_features * X.var())` olarak otomatik hesaplar; `'auto'` ise `1 / n_features` kullanır.

## 5. Destek Vektör Analizi

Eğitim sonrası incelenebilecek önemli bir çıktı, **destek vektör sayısıdır** (`model.n_support_`):

- **Düşük destek vektör oranı** (toplam eğitim örneğine göre): Sınıflar arasında **net bir ayrım** olduğunu gösterir.
- **Yüksek destek vektör oranı:** Sınıflar arasında daha fazla **örtüşme/karmaşıklık** olduğunu, modelin karar sınırını belirlemek için verinin büyük kısmına ihtiyaç duyduğunu gösterir.

## 6. Model Değerlendirme

SVM için de standart sınıflandırma metrikleri kullanılır:

- **Accuracy, Precision, Recall, F1-Skoru:** Özellikle çok sınıflı problemlerde `classification_report` ile sınıf bazında incelenmelidir.
- **Karışıklık Matrisi:** Hangi sınıfların birbiriyle karıştırıldığını gösterir.
- **Cross-validation skoru:** Tek bir train/test bölünmesine değil, birden fazla katmana (fold) dayalı ortalama performansa bakmak, sonucun rastgele bir bölünmeye bağlı olmadığından emin olmayı sağlar.

## 7. Avantajlar ve Dezavantajlar

**Avantajları:**

- Yüksek boyutlu uzaylarda (çok sayıda öznitelik) bile etkili çalışabilir.
- Kernel trick sayesinde doğrusal olmayan sınırlar öğrenebilir.
- Marj maksimizasyonu sayesinde genelde iyi genelleme yapar (overfitting'e karşı nispeten dirençli, doğru hiperparametrelerle).
- Aykırı değerlere (destek vektörü olmadıkları sürece) nispeten dayanıklıdır.

**Dezavantajları:**

- Büyük veri setlerinde eğitim süresi ciddi şekilde uzayabilir (ölçeklenebilirlik sorunu).
- Hiperparametre seçimi (C, gamma, kernel) sonucu büyük ölçüde etkiler; doğru ayarlanmazsa kötü performans verebilir.
- Olasılık çıktısı doğrudan üretmez (gerekirse ekstra bir kalibrasyon adımı — `probability=True` — gerekir, bu da eğitim süresini uzatır).
- Ölçeklendirme yapılmadan kullanılamaz denecek kadar hassastır.
- Çok sınıflı problemlerde doğrudan değil, "bire-karşı-bir" (one-vs-one) ya da "bire-karşı-hepsi" (one-vs-rest) stratejileriyle genişletilir.

## 8. Sık Sorulan / Karıştırılan Noktalar

1. **"Destek vektörleri, sınıfların merkezindeki tipik örneklerdir" — Yanlış.** Tam tersine, destek vektörleri karar sınırına **en yakın**, genelde en "zor" veya sınıflar arası geçiş bölgesindeki örneklerdir.
2. **C parametresi ile marj genişliği ters orantılıdır:** Büyük C → dar marj (lojistik regresyondaki C mantığıyla benzer bir tuzak).
3. **RBF her zaman en iyisi değildir:** Eğer veri zaten doğrusal olarak iyi ayrılabiliyorsa, daha basit olan **linear kernel** hem daha hızlı çalışır hem de overfitting riski daha düşük olabilir.
4. **Kernel trick, veriyi fiziksel olarak yüksek boyuta taşımaz:** Sadece yüksek boyuttaki iç çarpımı doğrudan hesaplayan bir matematiksel kısayoldur — bu yüzden "hile" (trick) denir.

## 9. Özet Tablo

| Kavram | Açıklama |
|---|---|
| Hiper-düzlem | Sınıfları ayıran karar sınırı: $w \cdot x + b = 0$ |
| Destek Vektörü | Hiper-düzleme en yakın, sınırı belirleyen örnekler |
| Marj | Hiper-düzlem ile destek vektörleri arasındaki mesafe (maksimize edilir) |
| C | Hata toleransı; küçük C → geniş marj, büyük C → dar marj |
| Gamma | RBF/poly kernelde örnek etki alanı; küçük → geniş, büyük → dar |
| Kernel Trick | Veriyi yüksek boyuta taşıyıp doğrusal ayrım sağlayan matematiksel kısayol |
| GridSearchCV | En iyi hiperparametre kombinasyonunu çapraz doğrulamayla bulma yöntemi |
