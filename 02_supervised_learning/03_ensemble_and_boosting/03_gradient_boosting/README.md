# Gradient Boosting

**Temel Fikir:** Modeli "hatayı adım adım kapatan bir dizi ağaç" olarak kurar. Her yeni ağaç, önceki modelin **artıklarını (residuals)** ya da daha genel olarak **kayıp fonksiyonunun negatif gradyanını (pseudo-residual)** tahmin etmeye çalışır.

**Algoritma Adımları (Regresyon)**
1. Başlangıç tahmini: `F0(x) = ortalama(y)`.
2. Her iterasyonda: artıklar `r_i = y_i - F_{m-1}(x_i)` hesaplanır.
3. Artıkları tahmin eden yeni bir ağaç `h_m(x)` kurulur.
4. Model güncellenir: `F_m(x) = F_{m-1}(x) + learning_rate * h_m(x)`.

**İkili Sınıflandırmada:** Kayıp fonksiyonu log-loss olur, `sigmoid` ile olasılığa dönüştürülür; pseudo-residual = `y - sigmoid(F(x))`.

**Önemli Hiperparametreler**
| Parametre | Anlamı |
|---|---|
| `n_estimators` | Ağaç sayısı |
| `learning_rate` | Küçültme katsayısı — düşükse daha fazla ağaç gerekir ama genelleme genelde daha iyi olur |
| `max_depth` | Her ağacın derinliği (genelde sığ, 2-5) |
| `subsample` | Stochastic Gradient Boosting için örnekleme oranı |

**`learning_rate` ve `n_estimators` İlişkisi:** Düşük learning_rate + yüksek n_estimators genelde daha iyi genelleme sağlar ama eğitim süresi artar (bias-variance-computation dengesi).

**Avantajlar:** Yüksek tahmin doğruluğu, esnek kayıp fonksiyonları (regresyon, sınıflandırma, sıralama).
**Dezavantajlar:** AdaBoost gibi sıralı eğitim → paralelleştirilemez, aşırı öğrenmeye (overfitting) eğilimli, hiperparametre ayarı hassas.

---

## Bu Klasördeki Uygulama
- **Notebook:** `03_gradient_boosting_house_prices.ipynb`
- **Veri seti:** `data/house_price_regression_dataset.csv`
- **Detaylı PDF anlatım:** `konu_anlatimi_gradient_boosting.pdf`
- Karşılaştırmalı tablo ve diğer ensemble yöntemleriyle ilişkisi için bkz. [üst klasördeki README](../README.md).
