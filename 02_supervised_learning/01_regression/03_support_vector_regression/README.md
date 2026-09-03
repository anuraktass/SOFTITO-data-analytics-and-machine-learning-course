# Support Vector Regression (SVR) — Sınav Çalışma Notu

> Veri setinden bağımsız, kavram + formül + yorumlama odaklı.
> Not: Bu konu için henüz bir ders notebook'u paylaşmadın; bu doküman genel SVR teorisini
> kapsar. Kendi notebook'unu paylaştığında, bu notu onun içeriğiyle karşılaştırıp güncelleyebiliriz.

---

## 1. SVR'nin Temel Fikri

Support Vector Machine'in (SVM) sınıflandırmadaki mantığının regresyona uyarlanmış hali.

Klasik regresyon (OLS) **tüm hataları** minimize etmeye çalışırken, SVR farklı bir yaklaşım kullanır:

> **"Bir ε (epsilon) toleransı içinde kalan hatalar önemsizdir — sadece bu tolerans dışına
> çıkan noktalar cezalandırılır."**

Bu, veri etrafında bir **"tüp" (epsilon-tube)** oluşturmak gibi düşünülebilir: tüpün içindeki
noktalar için ceza yok, dışındaki noktalar için mesafeyle orantılı ceza var.

---

## 2. Epsilon-Insensitive Loss Fonksiyonu

$$L_\epsilon(y, \hat{y}) = \begin{cases} 0 & \text{eğer } |y - \hat{y}| \le \epsilon \\ |y-\hat{y}| - \epsilon & \text{aksi halde} \end{cases}$$

- **ε (epsilon):** Tolerans genişliği — bu aralık içindeki hatalar "hata" sayılmaz.
- ε büyüdükçe → model daha "toleranslı", daha az destek vektörü (support vector), daha basit model.
- ε küçüldükçe → model daha "hassas", daha fazla destek vektörü, overfitting riski artar.

---

## 3. Optimizasyon Problemi ve C Parametresi

$$\min \frac{1}{2}\|w\|^2 + C\sum_{i}(\xi_i + \xi_i^*)$$

kısıtlar: $y_i - \hat{y}_i \le \epsilon + \xi_i$, $\hat{y}_i - y_i \le \epsilon + \xi_i^*$, $\xi_i, \xi_i^* \ge 0$

- **$\|w\|^2$:** Modelin "düzlüğünü" (flatness) korumak — basit model tercih etme.
- **$\xi_i$ (slack variable):** Tüpün dışına taşan noktalar için hata payı.
- **C:** Model karmaşıklığı ile hata toleransı arasındaki denge (regularization parametresi gibi düşünülebilir, ama Ridge'in tam tersi yönde çalışır):
  - **C büyük** → hatalara az tolerans, modeli veriye sıkı oturtmaya çalışır (overfitting riski ↑)
  - **C küçük** → hatalara daha çok tolerans, daha basit/düz model (underfitting riski ↑)

---

## 4. Kernel Trick

Doğrusal olmayan ilişkileri modellemek için veriler, **kernel fonksiyonu** aracılığıyla daha
yüksek boyutlu bir uzaya taşınır — bu uzayda doğrusal bir sınır/regresyon aranır, ama gerçek
hesaplama orijinal boyutta (verimli şekilde) yapılır.

| Kernel | Formül (özet) | Ne zaman kullanılır |
|---|---|---|
| **Linear** | $x_i \cdot x_j$ | İlişki zaten doğrusala yakınsa, çok özellikli/seyrek veri |
| **Polynomial** | $(\gamma \, x_i \cdot x_j + r)^d$ | Belirli dereceli doğrusal olmayan ilişkiler |
| **RBF (Gaussian)** | $\exp(-\gamma \|x_i - x_j\|^2)$ | Genel amaçlı, en sık kullanılan — karmaşık/bilinmeyen ilişkiler |
| **Sigmoid** | $\tanh(\gamma \, x_i \cdot x_j + r)$ | Sinir ağlarına benzer davranış, daha nadir kullanılır |

### Gamma (γ) Parametresi (RBF/Poly/Sigmoid için)
- Bir eğitim noktasının **etki alanının** ne kadar geniş/dar olduğunu belirler.
- **γ büyük** → her nokta sadece yakın komşularını etkiler → model karmaşıklaşır (overfitting riski ↑)
- **γ küçük** → her nokta geniş bir alanı etkiler → model daha düz/basit (underfitting riski ↑)

---

## 5. Destek Vektörleri (Support Vectors)

- Sadece **epsilon-tüpünün dışında kalan** (veya sınırında olan) noktalar modelin şeklini belirler.
- Tüpün içindeki noktalar modelden **hiç etkilemez** — bu SVR'yi bazı aykırı değerlere karşı
  dayanıklı (robust) yapar.
- Az sayıda destek vektörü → basit/genelleştirilebilir model. Çok fazla destek vektörü → karmaşık model, overfitting riski.

---

## 6. Ölçekleme (Scaling) Zorunluluğu

SVR, mesafe/nokta-çarpımı tabanlı çalıştığı için (kernel hesaplamaları), özelliklerin ölçeği
**büyük fark yaratır**:
- Ölçeklenmemiş veri → büyük değerli özellikler mesafeyi domine eder → yanlış model.
- Bu yüzden **StandardScaler** (veya MinMaxScaler) ile ölçekleme, SVR öncesi neredeyse zorunludur (Ridge/Lasso'da olduğu gibi).

---

## 7. SVR vs. Diğer Regresyon Yöntemleri — Karşılaştırma

| Özellik | Linear/Polynomial Reg. | Ridge/Lasso/ElasticNet | SVR |
|---|---|---|---|
| Aykırı değerlere duyarlılık | Yüksek (kareler toplamı) | Yüksek | Düşük (epsilon-tüpü sayesinde) |
| Doğrusal olmayan ilişki | Sadece derece eklenirse (polynomial) | Hayır (doğrusal kalır) | Evet (kernel trick ile doğal olarak) |
| Yorumlanabilirlik | Yüksek | Orta-Yüksek | Düşük (özellikle non-linear kernel'de) |
| Ölçekleme gereksinimi | Genelde gerekmez | Zorunlu | Zorunlu |
| Büyük veri setinde performans | Hızlı | Hızlı | Yavaş olabilir (kernel hesaplama maliyeti) |
| Ana hiperparametreler | (derece — polynomial için) | α (ve l1_ratio) | C, ε, kernel, γ |

---

## 8. Olası Sınav Soruları

1. Epsilon-insensitive loss fonksiyonunu yaz ve mantığını açıkla.
2. C parametresinin büyük/küçük olması modelin davranışını nasıl etkiler?
3. Kernel trick nedir, neden kullanılır? RBF kernel ne zaman tercih edilir?
4. Destek vektörü (support vector) nedir? Neden SVR aykırı değerlere karşı Linear Regression'dan daha dayanıklıdır?
5. Gamma parametresi neyi kontrol eder, aşırı büyük/küçük gamma ne gibi sorunlara yol açar?
6. SVR ile Ridge regresyonun regularizasyon mantığı arasındaki fark/benzerlik nedir?
7. Neden SVR öncesi özellik ölçekleme şart?

---

## 9. Hızlı Kod İskeleti (Referans)

```python
from sklearn.svm import SVR
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np

scaler_X = StandardScaler()
scaler_y = StandardScaler()
X_scaled = scaler_X.fit_transform(X_train)
y_scaled = scaler_y.fit_transform(y_train.reshape(-1, 1)).ravel()

svr = SVR(kernel='rbf', C=1.0, epsilon=0.1, gamma='scale')
svr.fit(X_scaled, y_scaled)

# Hiperparametre optimizasyonu
param_grid = {
    'C': [0.1, 1, 10, 100],
    'epsilon': [0.01, 0.1, 0.5],
    'gamma': ['scale', 'auto', 0.01, 0.1, 1]
}
grid = GridSearchCV(SVR(kernel='rbf'), param_grid, cv=5, scoring='r2')
grid.fit(X_scaled, y_scaled)
best_svr = grid.best_estimator_
```

> **NOT:** Kendi SVR notebook'unu (CV dahil) paylaştığında, bu dosyayı derste işlenen
> spesifik örneklerle (kullanılan veri seti, kod stiliyle) güncelleyip zenginleştirebilirim.
