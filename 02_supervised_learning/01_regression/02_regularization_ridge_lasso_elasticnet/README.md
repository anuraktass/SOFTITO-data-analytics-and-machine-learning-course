# Ridge, Lasso & Elastic Net — Sınav Çalışma Notu

> Veri setinden bağımsız, kavram + formül + yorumlama odaklı.
> Kaynak: `ridge_lasso_elasticnet.ipynb`, `ridge_lasso_elasticnet_elmas.ipynb`

---

## 1. Neden Regularizasyon (Regularization)?

Çoklu doğrusal regresyonda, özellik sayısı arttıkça veya özellikler arasında **çoklu doğrusal bağlantı
(multicollinearity)** olduğunda:
- Katsayılar aşırı büyük/dengesiz değerler alabilir.
- Model **train verisine aşırı uyum sağlar (overfit)** → test performansı düşer.
- Katsayıların yorumu güvenilmez hale gelir.

**Çözüm:** Katsayı büyüklüklerine bir **ceza (penalty)** eklemek → modeli "basit" tutmaya zorlamak.
Bu üç yöntem, standart doğrusal regresyonun **maliyet fonksiyonuna** bir ceza terimi ekler.

> **ÖN KOŞUL — ÖLÇEKLEME (Scaling):** Ridge/Lasso/ElasticNet katsayılara ceza uyguladığı için,
> değişkenlerin ölçeği (birimleri) farklıysa ceza adil dağılmaz. Bu yüzden regresyondan önce
> **StandardScaler** (veya benzeri) ile ölçekleme **şart**.

---

## 2. Ridge Regresyon (L2 Regularizasyon)

### Maliyet Fonksiyonu
$$J(b) = \sum(y_i - \hat{y}_i)^2 + \alpha \sum_{j=1}^{p} b_j^2$$

- Ceza terimi: katsayıların **karelerinin toplamı** (L2 normu).
- **Etki:** Katsayıları **sıfıra yaklaştırır** ama tam olarak sıfır yapmaz.
- **Ne zaman kullanılır:** Tüm özelliklerin bir şekilde etkili olduğu düşünülüyorsa; multicollinearity varsa.
- **Özellik seçimi yapmaz** — tüm değişkenleri modelde tutar, sadece etkilerini küçültür.

---

## 3. Lasso Regresyon (L1 Regularizasyon)

### Maliyet Fonksiyonu
$$J(b) = \sum(y_i - \hat{y}_i)^2 + \alpha \sum_{j=1}^{p} |b_j|$$

- Ceza terimi: katsayıların **mutlak değerlerinin toplamı** (L1 normu).
- **Etki:** Bazı katsayıları **tam olarak sıfıra** indirebilir → otomatik **özellik seçimi (feature selection)** yapar.
- **Ne zaman kullanılır:** Çok sayıda özellik arasından **önemli olanları** seçmek istendiğinde.
- Yorumlanabilirlik açısından avantajlı: gereksiz değişkenler modelden "atılmış" olur.

---

## 4. Elastic Net (L1 + L2 Kombinasyonu)

### Maliyet Fonksiyonu
$$J(b) = \sum(y_i - \hat{y}_i)^2 + \alpha \left[ l1\_ratio \cdot \sum|b_j| + (1-l1\_ratio) \cdot \sum b_j^2 \right]$$

- İki dünyanın da avantajını birleştirir: Lasso'nun özellik seçimi + Ridge'in kararlılığı (stability).
- `l1_ratio` parametresi L1 ile L2 arasındaki dengeyi ayarlar:
  - `l1_ratio = 1` → saf Lasso
  - `l1_ratio = 0` → saf Ridge
  - Arada bir değer → karışım
- **Ne zaman kullanılır:** Özellikler arasında yüksek korelasyon varken **hem seçim hem kararlılık** isteniyorsa (Lasso tek başına korele değişkenlerden rastgele birini seçer, bu dengesizliği giderir).

---

## 5. Karşılaştırma Tablosu (EZBER TABLOSU)

| Özellik | Ridge (L2) | Lasso (L1) | Elastic Net |
|---|---|---|---|
| Ceza terimi | $\sum b_j^2$ | $\sum \lvert b_j \rvert$ | İkisinin ağırlıklı toplamı |
| Katsayıyı sıfır yapar mı? | Hayır (küçültür) | Evet (özellik seçimi) | Evet (kısmen) |
| Multicollinearity'e karşı | Güçlü | Zayıf/dengesiz olabilir | Güçlü |
| Özellik sayısı > gözlem sayısı | Çalışır | Çalışır (en fazla n özellik seçer) | Çalışır |
| Yorumlanabilirlik | Düşük (hepsi kalır) | Yüksek (seyrek/sparse model) | Orta |

---

## 6. Alpha (α) Parametresi

- α = ceza şiddetini kontrol eden **hiperparametre**.
- **α = 0** → ceza yok, sıradan Linear Regression'a döner.
- **α → ∞** → tüm katsayılar sıfıra yaklaşır (aşırı basit model, underfitting).
- Doğru α, **çok büyük değil çok küçük de değil** — cross-validation ile seçilmeli (elle "makul" bir değer seçmek yerine).

### GridSearchCV / RidgeCV / LassoCV ile Alpha Seçimi
- `GridSearchCV`: verilen alpha listesini dener, CV skoruna göre en iyisini seçer (Ridge, Lasso, ElasticNet hepsine uygulanabilir, genel amaçlı).
- `RidgeCV`, `LassoCV`: sklearn'ün kendi optimize edilmiş CV sınıfları — genelde daha hızlı, doğrudan `alphas` listesi verilir.
- Genel pratik: `np.logspace(-4, 4, 100)` gibi **logaritmik aralıkta** çok sayıda alpha denemek (çünkü ceza etkisi logaritmik ölçekte değişir).

---

## 7. Pipeline Kullanımı (Kategorik + Sayısal Veri)

Gerçek veri setlerinde hem sayısal hem kategorik değişkenler olabilir → `ColumnTransformer` ile ayrı ayrı işlenir:

```python
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.pipeline import Pipeline

preprocessor = ColumnTransformer([
    ("num", StandardScaler(), num_columns),
    ("cat", OneHotEncoder(), cat_columns)
])

ridge_pipeline = Pipeline(steps=[
    ('Preprocessor', preprocessor),
    ('Ridge', Ridge(alpha=1))
])
```

**Neden Pipeline?** Veri sızıntısını (data leakage) önler — `fit` sadece train'e uygulanır,
`transform` train ve test'e tutarlı şekilde uygulanır.

---

## 8. Olası Sınav Soruları

1. Ridge ve Lasso'nun maliyet fonksiyonlarını yazıp farkını açıkla.
2. Neden Lasso bazı katsayıları tam sıfır yapabilirken Ridge yapamaz? (Geometrik sezgi: L1 normunun köşeli, L2 normunun yuvarlak olması)
3. Elastic Net hangi durumda Lasso'dan daha avantajlıdır?
4. α = 0 ve α → ∞ durumlarında model ne olur?
5. Neden regularizasyon öncesi ölçekleme (scaling) şart?
6. RidgeCV/LassoCV ile GridSearchCV arasındaki fark nedir?
7. Multicollinearity nedir, neden regularizasyon bu soruna çözüm olur?

---

## 9. Hızlı Kod İskeleti (Referans)

```python
from sklearn.linear_model import Ridge, Lasso, ElasticNet, RidgeCV, LassoCV
from sklearn.model_selection import GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Ridge
ridge = Ridge(alpha=1.0, random_state=42)
ridge.fit(X_train_scaled, y_train)

# Lasso
lasso = Lasso(alpha=0.1, random_state=42)
lasso.fit(X_train_scaled, y_train)

# Elastic Net
enet = ElasticNet(alpha=0.1, l1_ratio=0.5, random_state=42)
enet.fit(X_train_scaled, y_train)

# GridSearch ile alpha optimizasyonu
alpha_range = {"alpha": [0.001, 0.01, 0.1, 1.0, 10.0, 100.0]}
ridge_grid = GridSearchCV(Ridge(), alpha_range, cv=5, scoring='r2')
ridge_grid.fit(X_train_scaled, y_train)
best_ridge = ridge_grid.best_estimator_
```
