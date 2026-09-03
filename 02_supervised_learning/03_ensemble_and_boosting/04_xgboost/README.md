# XGBoost (Extreme Gradient Boosting)

**Temel Fikir:** Gradient Boosting'in **regularize edilmiş, optimize edilmiş ve ölçeklenebilir** bir versiyonu (Tianqi Chen, 2016).

**Klasik Gradient Boosting'e Göre Farkları**
- **Regularizasyon:** Kayıp fonksiyonuna L1/L2 ceza terimleri eklenir (`reg_alpha`, `reg_lambda`) → overfitting azalır.
- **İkinci Derece Optimizasyon:** Sadece gradyan değil, Hessian (ikinci türev) de kullanılır → daha hızlı/doğru yakınsama.
- **Ağaç Budama:** `max_depth`'e ulaşana kadar büyüyüp sonradan budanır (`gamma` eşiğine göre) — geleneksel "greedy" durdurmadan farklı.
- **Paralelleştirme:** Ağaç kurma sırasında bölünme aramaları paralelleştirilir (ağaçların kendisi hâlâ sıralı kurulur).
- **Eksik Veri Yönetimi:** Eksik değerler için otomatik yön öğrenimi (sparsity-aware split finding).
- **Erken Durdurma (Early Stopping):** Doğrulama setinde performans iyileşmeyince eğitim otomatik durur.

**Önemli Hiperparametreler**
| Parametre | Anlamı |
|---|---|
| `n_estimators`, `learning_rate`, `max_depth` | Gradient Boosting ile ortak |
| `gamma` | Bir bölünmenin gerçekleşmesi için gereken min. kayıp azalması |
| `reg_alpha`, `reg_lambda` | L1 / L2 regularizasyon |
| `subsample`, `colsample_bytree` | Satır / sütun örnekleme oranları |
| `scale_pos_weight` | Dengesiz sınıflandırmada pozitif sınıf ağırlığı |

**Kullanım Alanı:** Büyük ölçekli, tablo (tabular) verilerde — özellikle dolandırıcılık tespiti, kredi skorlama gibi yapılandırılmış veri problemlerinde Kaggle yarışmalarının klasik tercihi.

**Avantajlar:** Hız, ölçeklenebilirlik, yerleşik regularizasyon, eksik veriyle başa çıkabilme.
**Dezavantajlar:** Çok sayıda hiperparametre → ayar karmaşıklığı, büyük derinliklerde hâlâ overfitting riski.

---

## Bu Klasördeki Uygulama
- **Notebook:** `04_xgboost_fraud_detection.ipynb`
- **Veri seti:** IEEE-CIS Fraud Detection (Kaggle)
  - `data/train_identity.csv` ✅ depoda mevcut (~26 MB)
  - `data/train_transaction.csv` ❌ **depoda yok** — ~652 MB olduğu için GitHub'ın 100 MB
    dosya sınırını aştığından repoya eklenmedi. Notebook'u çalıştırmadan önce bu dosyayı
    [Kaggle — IEEE-CIS Fraud Detection](https://www.kaggle.com/c/ieee-fraud-detection/data)
    sayfasından indirip bu klasördeki `data/` içine koyman gerekiyor.
- **Detaylı PDF anlatım:** `konu_anlatimi_xgboost.pdf`
- Karşılaştırmalı tablo ve diğer ensemble yöntemleriyle ilişkisi için bkz. [üst klasördeki README](../README.md).
