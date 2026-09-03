# Linear & Polynomial Regression — Sınav Çalışma Notu

> Bu not, veri setinden bağımsız olarak **kavram, formül ve yorumlama** üzerine kuruludur.
> Kaynak: `regresyon_analizi.ipynb`, `polynomial_regression_gelismis.ipynb`, `ispark_regresyon_analizi.ipynb`

---

## 1. Basit Doğrusal Regresyon (Simple Linear Regression)

### Model
$$\hat{y} = b_0 + b_1 x$$

- **b0 (intercept):** x = 0 iken tahmini y değeri
- **b1 (slope/eğim):** x bir birim arttığında y'nin ortalama değişimi

### En Küçük Kareler (Least Squares) — elle hesap
$$b_1 = \frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{\sum (x_i - \bar{x})^2} \qquad b_0 = \bar{y} - b_1 \bar{x}$$

Mantık: gerçek gözlemler ile tahminler arasındaki farkların **karelerinin toplamını** minimize eden doğruyu bulmak (neden kare? + ve - hataların birbirini götürmesini engellemek, büyük hataları daha çok cezalandırmak).

### Dummy (Gösterge) Değişken
Kategorik (metin) değişkenler regresyona doğrudan giremez → 0/1 kodlanır (dummy variable).
- x sadece 0/1 alıyorsa, basit regresyon aslında **iki grup ortalamasını karşılaştırma** işlemi haline gelir.
- Örnek: `IS_LOT` (otopark alanı mı / değil mi) → b0 = "değil" grubunun ortalaması, b1 = farkın büyüklüğü.

---

## 2. Çoklu Doğrusal Regresyon (Multiple Linear Regression)

$$\hat{y} = b_0 + b_1x_1 + b_2x_2 + \dots + b_nx_n$$

- Her katsayı, **diğer değişkenler sabit tutulduğunda** o değişkenin y üzerindeki etkisini gösterir.
- Değişken seçimi genelde **hedef ile korelasyona** göre yapılır (örn. korelasyon > 0.7 ya da top-N özellik).
- Basit ve çoklu regresyonu karşılaştırırken **train/test RMSE** kullanılır — sadece train'e bakmak yanıltıcıdır (overfitting riski).

---

## 3. Model Değerlendirme Metrikleri

| Metrik | Formül | Yorum |
|---|---|---|
| **RMSE** | $\sqrt{\frac{1}{n}\sum(y_i-\hat{y}_i)^2}$ | Hatanın y ile aynı birimde ortalama büyüklüğü |
| **MSE** | $\frac{1}{n}\sum(y_i-\hat{y}_i)^2$ | RMSE'nin karesi, büyük hataları daha çok cezalandırır |
| **R²** | $1 - \frac{SS_{res}}{SS_{tot}}$ | Varyansın ne kadarının açıklandığı (0-1 arası, 1 mükemmel) |
| **p-değeri** | (istatistiksel test) | İlişkinin tesadüf olup olmadığı |

**KRİTİK EZBER NOKTASI:** İstatistiksel anlamlılık (düşük p-değeri) ≠ güçlü tahmin gücü (yüksek R²).
Bir değişken anlamlı olabilir ama R² düşük olabilir → başka açıklayıcı değişkenler eksik demektir.

### Residual (Artık) Analizi
$$residual = y - \hat{y}$$
- Residual'ların 0 etrafında **rastgele dağılması** iyi bir modelin işareti.
- Residual'larda bir **desen/örüntü** varsa (ör. huni şekli, eğri) → model yanlış (doğrusal olmayan ilişki, varyans homojen değil vb.)

---

## 4. Polinom Regresyon (Polynomial Regression)

### Model
$$\hat{y} = b_0 + b_1x + b_2x^2 + \dots + b_dx^d$$

- Doğrusal olmayan ilişkileri, x'in yüksek dereceli terimlerini **yeni özellikler** gibi ekleyerek modeller.
- **Önemli:** Model katsayılara göre hâlâ doğrusaldır (linear in parameters) — bu yüzden hâlâ Linear Regression kütüphanesiyle çözülür, sadece girdi (X) dönüştürülür.
- Scikit-learn'de: `PolynomialFeatures` + `LinearRegression` → `make_pipeline` ile zincirlenir.

### Derece (Degree) Seçimi — Bias-Variance Tradeoff
| Derece | Durum | Belirti |
|---|---|---|
| Çok düşük (örn. 1) | **Underfitting** | Train ve test hatası ikisi de yüksek |
| Uygun | İyi genelleme | Train ve test hatası düşük ve birbirine yakın |
| Çok yüksek | **Overfitting** | Train hatası çok düşük, test hatası yüksek (veya artıyor) |

### K-Fold Cross-Validation ile Derece Seçimi
- Tek bir train-test bölmesi **o bölmeye özgü şansa** bağlı olabilir → yanıltıcı.
- K-Fold CV: veriyi K parçaya böl, her seferinde 1 parça test geri kalanı train, K kez tekrarla, ortalama al.
- En iyi derece = **CV skorunun en iyi (veya en dengeli) olduğu** derece — sadece train skoruna bakılmaz.

---

## 5. Veri Ön İşleme — Sınavda Sorulabilecek Detaylar

1. **Eksik veri (missing values):** `isnull().sum()` her zaman yeterli değildir — bazı eksik veriler **sentinel değer** (örn. -99, 9999) olarak gizlenmiş olabilir. Veri aralığını (`min`, `max`, mantıksal sınırlar) kontrol etmek şart.
2. **Sayısal tipe dönüştürme:** Bazı sütunlar görünüşte sayısal ama `object` tipinde gelebilir (örn. virgül/nokta karışıklığı, boşluk karakterleri `\xa0`) → temizlenmeden regresyona sokulamaz.
3. **Train/Test ayrımı:** Modelin görülmemiş veri üzerindeki performansını ölçmek için şart; sadece train üzerinde değerlendirme yanıltıcıdır.

---

## 6. Olası Sınav Soruları (Kendi Kendine Test)

1. b0 ve b1'in yorumu nedir? (formülleri yaz ve bir örnek üzerinden anlat)
2. Neden "kareler toplamı" minimize edilir, mutlak değer değil?
3. R² yüksek ama p-değeri yüksekse (anlamsızsa) ne anlama gelir? Tam tersi durum?
4. Polinom regresyon neden hâlâ "doğrusal" model sayılır?
5. Derece arttıkça train hatası neden hep azalır (ya da sabit kalır), fakat test hatası neden bir yerden sonra artar?
6. K-Fold CV'nin tek train-test split'e göre avantajı nedir?
7. Kategorik bir değişkeni regresyona sokmanın yolu nedir? Bunun basit regresyonda anlamı nedir?
8. Residual grafiğinde huni şekli görürsen bu neyin işaretidir?

---

## 7. Hızlı Kod İskeleti (Referans)

```python
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np

# Basit/Çoklu regresyon
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LinearRegression()
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
rmse = np.sqrt(mean_squared_error(y_test, y_pred))
r2 = r2_score(y_test, y_pred)

# Polinom regresyon + CV ile derece seçimi
for degree in range(1, 11):
    poly_model = make_pipeline(PolynomialFeatures(degree), LinearRegression())
    scores = cross_val_score(poly_model, X_train, y_train, cv=5, scoring='r2')
    print(degree, scores.mean())
```
