# LightGBM

**Temel Fikir:** Microsoft'un geliştirdiği, **histogram tabanlı** ve çok büyük veri setlerinde **hızlı eğitim** için optimize edilmiş bir Gradient Boosting çerçevesi.

**XGBoost'a Göre Farkları**
- **Leaf-wise (best-first) ağaç büyütme:** XGBoost'un level-wise (katman katman) büyütmesi yerine, en çok kayıp azaltan yaprak önce bölünür → daha derin, dengesiz ama genelde daha doğru ağaçlar (aşırı öğrenme riskine karşı `max_depth`/`num_leaves` sınırlanmalı).
- **Histogram tabanlı bölünme arama:** Sürekli değişkenler ayrık kutulara (bin) indirgenerek bölünme arama hızlandırılır.
- **GOSS (Gradient-based One-Side Sampling):** Büyük gradyanlı örnekler korunur, küçük gradyanlılardan rastgele örneklenir → eğitim hızlanır.
- **EFB (Exclusive Feature Bundling):** Birbiriyle nadiren aynı anda sıfırdan farklı olan seyrek (sparse) özellikler paketlenerek boyut azaltılır.

**Önemli Hiperparametreler**
| Parametre | Anlamı |
|---|---|
| `num_leaves` | Bir ağaçtaki maksimum yaprak sayısı (leaf-wise büyümede `max_depth`'ten daha kritik) |
| `learning_rate`, `n_estimators` | Gradient Boosting ile ortak |
| `min_child_samples` | Bir yaprakta bulunması gereken min. örnek sayısı — overfitting kontrolü |
| `feature_fraction`, `bagging_fraction` | Sütun / satır örnekleme oranları |

**Zaman Serisi Notu:** Zaman serisi problemlerinde (örn. hisse senedi tahmini) **asla rastgele (shuffled) train/test bölmesi kullanılmaz** — kronolojik bölme ve `TimeSeriesSplit` / walk-forward doğrulama tercih edilir; aksi halde gelecek bilgisi geçmişe sızar (data leakage).

**Avantajlar:** Çok büyük veri setlerinde XGBoost'tan belirgin şekilde hızlı, düşük bellek kullanımı, yüksek doğruluk.
**Dezavantajlar:** Küçük veri setlerinde leaf-wise büyüme aşırı öğrenmeye yatkın olabilir, `num_leaves` dikkatli ayarlanmalı.

---

## Bu Klasördeki Uygulama
- **Notebook:** `05_lightgbm_santander.ipynb`
- **Veri seti:** Santander Customer Transaction Prediction (Kaggle)
  - `data/santander_train.csv` ❌ **depoda yok** — ~289 MB olduğu için GitHub'ın 100 MB
    dosya sınırını aştığından repoya eklenmedi. Notebook'u çalıştırmadan önce bu dosyayı
    [Kaggle — Santander Customer Transaction Prediction](https://www.kaggle.com/c/santander-customer-transaction-prediction/data)
    sayfasından indirip bu klasördeki `data/` içine koyman gerekiyor.
- **Detaylı PDF anlatım:** `konu_anlatimi_lightgbm.pdf`
- Karşılaştırmalı tablo ve diğer ensemble yöntemleriyle ilişkisi için bkz. [üst klasördeki README](../README.md).
