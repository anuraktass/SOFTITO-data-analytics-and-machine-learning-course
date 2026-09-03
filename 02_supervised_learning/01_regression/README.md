# 01_regression

Regresyon algoritmaları — her klasör, o yöntemin **veri setinden bağımsız** konu
anlatımını (`README.md`) ve gerçek bir veri seti üzerinde uygulanmış, çalıştırılmış
notebook'u içerir.

```
01_regression/
├── 01_linear_and_polynomial/
│   ├── README.md                          (konu anlatımı — veri setinden bağımsız)
│   ├── linear_regression_power_plant.ipynb
│   └── Folds5x2_pp.csv                    (Combined Cycle Power Plant - UCI)
├── 02_regularization_ridge_lasso_elasticnet/
│   ├── README.md                          (konu anlatımı — veri setinden bağımsız)
│   ├── ridge_lasso_elasticnet_residential.ipynb
│   └── Residential-Building-Data-Set.xlsx (UCI, çok özellikli, regularizasyon için ideal)
├── 03_support_vector_regression/
│   ├── README.md                          (konu anlatımı — veri setinden bağımsız)
│   ├── svr_airfoil.ipynb
│   └── AirfoilSelfNoise.csv               (Airfoil Self-Noise - UCI)
└── 04_use_case_ispark_analysis/
    └── (henüz eklenmedi)
```

## Konu Anlatımları
- [01 — Doğrusal ve Polinom Regresyon](01_linear_and_polynomial/README.md)
- [02 — Ridge, Lasso & Elastic Net](02_regularization_ridge_lasso_elasticnet/README.md)
- [03 — Support Vector Regression (SVR)](03_support_vector_regression/README.md)
- 04 — İSPARK Kullanım Senaryosu Analizi *(henüz eklenmedi)*

## İçerik

| Klasör | Veri Seti | Hedef | Notlar |
|---|---|---|---|
| 01_linear_and_polynomial | Combined Cycle Power Plant (Folds5x2_pp.csv) | Elektrik çıkışı (PE) | Basit/çoklu/polinom regresyon, K-Fold CV ile derece seçimi |
| 02_regularization_ridge_lasso_elasticnet | Residential Building Data Set | İnşaat maliyeti/satış fiyatı | Çok özellikli veri, multicollinearity, α seçimi (GridSearchCV) |
| 03_support_vector_regression | Airfoil Self-Noise | Ses basıncı seviyesi | Kernel trick, epsilon-tüpü, C/gamma optimizasyonu |

Not: `03_support_vector_regression/README.md` şu an genel SVR teorisini kapsıyor;
ders notebook'una özgü detaylarla (kullanılan kernel, hiperparametre aralığı vb.)
daha da zenginleştirilebilir.
