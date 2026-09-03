# 📂 data/

Bu klasör, `01_isolation_forest` ve `02_one_class_svm` notebook'larının kullandığı ortak veri setini barındırır.

## Veri Seti: Credit Card Fraud Detection

- **Kaynak:** [Kaggle — Credit Card Fraud Detection](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)
- **Dosya adı:** `creditcard.csv`
- **Boyut:** ~150 MB (284.807 satır, 31 sütun)
- **İçerik:** Avrupalı kart sahiplerinin 2013 yılındaki kredi kartı işlemleri
  - `V1..V28`: gizlilik nedeniyle PCA ile dönüştürülmüş özellikler
  - `Time`, `Amount`: işlem zamanı ve tutarı
  - `Class`: 0 = normal işlem, 1 = dolandırıcılık (yalnızca 492 kayıt, %0.17)


```
02_anomaly_detection/
└── data/
    └── creditcard.csv  
