# Random Forest

**Temel Fikir:** Birçok karar ağacını **bagging (bootstrap aggregating)** ile paralel eğitip, tahminleri oylama (sınıflandırma) veya ortalama (regresyon) ile birleştirir.

**Nasıl Çalışır?**
1. Orijinal veriden yerine koyarak (with replacement) N adet **bootstrap örneklem** oluşturulur.
2. Her örneklem için bir karar ağacı kurulur; her bölünmede tüm özellikler yerine rastgele seçilmiş bir alt küme (`max_features`, genelde `sqrt(p)`) değerlendirilir.
3. Tahminler: sınıflandırmada çoğunluk oyu, regresyonda ortalama.

**Neden İşe Yarar?** Tek karar ağacı düşük yanlılık (bias) ama yüksek varyansa sahiptir. Bagging + rastgele özellik seçimi, ağaçlar arası korelasyonu azaltarak varyansı düşürür, yanlılığı fazla artırmadan.

**Önemli Hiperparametreler**
| Parametre | Anlamı |
|---|---|
| `n_estimators` | Ağaç sayısı — arttıkça varyans azalır, hesaplama maliyeti artar |
| `max_depth` | Her ağacın maksimum derinliği |
| `max_features` | Her bölünmede değerlendirilen özellik sayısı (`sqrt`, `log2`) |
| `min_samples_leaf` | Bir yaprakta bulunması gereken min. örnek sayısı |
| `class_weight` | Dengesiz veri için sınıf ağırlıklandırma |

**Out-of-Bag (OOB) Skoru:** Her ağaç, kendi bootstrap örnekleminde yer almayan (~%37) verilerle test edilebilir — ayrı bir doğrulama setine gerek kalmadan performans tahmini sağlar.

**Avantajlar:** Aşırı öğrenmeye (overfitting) dirençli, paralelleştirilebilir, özellik önemi (feature importance) sunar, az hiperparametre ayarı gerektirir.
**Dezavantajlar:** Yorumlanabilirlik düşük (kara kutu), çok büyük veri/ağaç sayısında yavaş ve bellek yoğun, gürültülü/dengesiz verilerde ek ayar gerekebilir.

---

## Bu Klasördeki Uygulama
- **Notebook:** `01_random_forest_credit_card_default.ipynb`
- **Veri seti:** `data/default of credit card clients.xls` (UCI — Taiwan kredi kartı temerrüt verisi)
- **Detaylı PDF anlatım:** `konu_anlatimi_random_forest.pdf`
- Karşılaştırmalı tablo ve diğer ensemble yöntemleriyle ilişkisi için bkz. [üst klasördeki README](../README.md).
