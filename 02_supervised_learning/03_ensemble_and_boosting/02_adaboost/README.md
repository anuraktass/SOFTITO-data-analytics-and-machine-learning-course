# AdaBoost (Adaptive Boosting)

**Temel Fikir:** Zayıf öğrenicileri (genelde **karar kütükleri** — max_depth=1 ağaçlar) **sıralı (sequential)** olarak eğitir; her yeni öğrenici, bir öncekinin yanlış sınıflandırdığı örneklere daha fazla ağırlık vererek odaklanır.

**Algoritma Adımları**
1. Tüm örneklere eşit ağırlık (`w_i = 1/n`) verilir.
2. Ağırlıklı hataya göre en iyi kütük bulunur (`find_best_stump`).
3. Kütüğün güven katsayısı hesaplanır: `α = 0.5 * ln((1-err)/err)`.
4. Örnek ağırlıkları güncellenir: yanlış sınıflandırılanların ağırlığı artar (`w_i *= exp(-α * y_i * pred_i)`), sonra normalize edilir.
5. Adımlar `n_estimators` kez tekrarlanır; final tahmin, her kütüğün `α` ile ağırlıklı oyudur.

**Önemli Hiperparametreler**
| Parametre | Anlamı |
|---|---|
| `n_estimators` | Kütük (zayıf öğrenici) sayısı |
| `learning_rate` | Her kütüğün katkısını ölçekleyen küçültme (shrinkage) katsayısı |
| `estimator` | Zayıf öğrenici tipi (varsayılan: derinliği 1 karar ağacı) |

**Random Forest ile Farkı:** RF **paralel + bağımsız** ağaçlarla varyansı azaltır; AdaBoost **sıralı + bağımlı** kütüklerle yanlılığı (bias) azaltır.

**Avantajlar:** Basit, az hiperparametre, gürültüsüz verilerde güçlü performans.
**Dezavantajlar:** Aykırı değerlere (outlier) ve gürültülü veriye duyarlıdır (yanlış etiketlenmiş örneklerin ağırlığı sürekli artar).

---

## Bu Klasördeki Uygulama
- **Notebook:** `02_adaboost_spambase.ipynb`
- **Veri seti:** `data/spambase.data` (+ `spambase.names`, `spambase.DOCUMENTATION`) — UCI Spambase, e-posta spam sınıflandırması
- **Detaylı PDF anlatım:** `konu_anlatimi_adaboost.pdf`
- Karşılaştırmalı tablo ve diğer ensemble yöntemleriyle ilişkisi için bkz. [üst klasördeki README](../README.md).
