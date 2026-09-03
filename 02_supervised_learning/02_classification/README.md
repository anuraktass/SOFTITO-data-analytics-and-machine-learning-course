# 02_classification

Sınıflandırma algoritmaları — her klasör bir algoritmaya ait, hocanın derste işlediği notebook'larla aynı yöntem/adım sırasını takip eden, farklı bir veri seti üzerinde uygulanmış birer çalışma içerir.

```
02_classification/
├── 01_logistic_regression/
│   ├── README.md                    (konu anlatımı — veri setinden bağımsız)
│   ├── logistic_regression.ipynb
│   └── bank.csv                     (Bank Marketing - UCI, bank-full.csv, dengesiz sınıf)
├── 02_support_vector_machines/
│   ├── README.md                    (konu anlatımı — veri setinden bağımsız)
│   ├── support_vector_machines.ipynb
│   └── data.csv                     (Breast Cancer Wisconsin Diagnostic - Kaggle format)
├── 03_decision_trees/
│   ├── README.md                    (konu anlatımı — veri setinden bağımsız)
│   ├── decision_trees.ipynb
│   └── car.csv                      (Car Evaluation - UCI, tamamen kategorik)
└── 04_k_nearest_neighbors/
    ├── README.md                    (konu anlatımı — veri setinden bağımsız)
    ├── k_nearest_neighbors.ipynb
    └── glass.data                   (Glass Identification - UCI, orijinal format)
```

## Konu Anlatımları

Her klasördeki `README.md`, o algoritmanın **veri setinden bağımsız**, detaylı teorik anlatımını içerir (matematiksel temel, algoritma adımları, hiperparametreler, avantaj/dezavantaj, sık karıştırılan noktalar, özet tablo):

- [01 — Lojistik Regresyon](01_logistic_regression/README.md)
- [02 — Support Vector Machine (SVM)](02_support_vector_machines/README.md)
- [03 — Karar Ağacı (Decision Tree)](03_decision_trees/README.md)
- [04 — K-En Yakın Komşu (KNN)](04_k_nearest_neighbors/README.md)

## İçerik

| Klasör | Veri Seti | Örnek/Öznitelik | Hedef | Notlar |
|---|---|---|---|---|
| 01_logistic_regression | Bank Marketing (bank-full.csv) | 45.211 / 16 | `y` (evet/hayır) | Dengesiz sınıf, one-hot encoding, class_weight='balanced' |
| 02_support_vector_machines | Breast Cancer Wisconsin (data.csv) | 569 / 30 | `diagnosis` | Düşük gürültü, 3 kernel + GridSearchCV |
| 03_decision_trees | Car Evaluation (car.csv) | 1728 / 6 | `class` | Tamamen kategorik, sıfırdan (from-scratch) + sklearn karşılaştırması |
| 04_k_nearest_neighbors | Glass Identification (glass.data) | 214 / 9 | `Type` | Küçük, çok sınıflı, k seçimi ve mesafe ölçütü karşılaştırması |

Veri setleri kullanıcının yüklediği orijinal UCI/Kaggle dosyalarıdır (bank_marketing.zip, archive__4_.zip, archive__5_.zip, glass_identification.zip).

Her notebook aynı iskeleti takip eder: teori anlatımı → kütüphaneler → veri keşfi → ön işleme → eğitim/test ayrımı → ölçeklendirme → model eğitimi → değerlendirme (metrikler + confusion matrix) → örnek tahmin → sonuç.

Tüm notebook'lar çalıştırılıp doğrulanmıştır (hatasız çalışır, hücre çıktıları dolu haldedir).
