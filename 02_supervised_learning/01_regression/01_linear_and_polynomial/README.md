# 📈 Simple, Multiple & Polynomial Regression

## 📌 Modül Özeti
Sürekli hedef değişkenlerin ($y \in \mathbb{R}$) tahmininde kullanılan temel analitik ve parametrik regresyon yaklaşımlarını kapsar[cite: 1, 2].

---

## 🧠 Matematiksel Temeller & Formülasyon

* **Basit ve Çoklu Doğrusal Regresyon (OLS - Ordinary Least Squares):**
  $$y = \beta_0 + \beta_1 x_1 + \dots + \beta_p x_p + \epsilon = X\beta + \epsilon$$
  Katsayıların analitik (kapalı form) çözümü:
  $$\hat{\beta} = (X^T X)^{-1} X^T y$$

* **Polinom Regresyon:**
  Doğrusal olmayan ilişkileri modellemek için öznitelik uzayını derecelendirerek genişletir:
  $$y = \beta_0 + \beta_1 x + \beta_2 x^2 + \dots + \beta_d x^d + \epsilon$$

* **Varsayımlar (Gauss-Markov):** Doğrusallık, Hataların Normalliği, Eşvaryanslılık (Homoscedasticity), Otokorelasyonsuzluk ve Çoklu Doğrusal Bağlantı (Multicollinearity) olmaması ($VIF < 5$).

---

## 🎯 Temel Değerlendirme Metrikleri
* **$R^2$ Score:** Modelin bağımlı değişkendeki varyansın ne kadarını açıkladığını gösterir[cite: 1, 2].
* **RMSE / MAE:** Hata büyüklüğünü orijinal birim cinsinden ölçer (RMSE büyük hataları karesel cezalandırır)[cite: 1, 2].

---
