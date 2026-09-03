# 02_supervised_learning

## Durum
- ✅ **01_regression** — 3/4 konu dolduruldu (linear/polynomial, ridge/lasso/elasticnet, SVR).
  `04_use_case_ispark_analysis` henüz eklenmedi.
- ✅ **02_classification** — 4/4 konu tam (logistic regression, SVM, decision trees, KNN)
  — README + notebook + gerçek veri seti.
- ✅ **03_ensemble_and_boosting** — 5/5 konu tam (random forest, adaboost, gradient
  boosting, xgboost, lightgbm) — README + notebook + PDF + veri seti (2 büyük veri
  seti boyut sınırı nedeniyle hariç tutuldu, ilgili README'lerde indirme notu var).

```
02_supervised_learning/
├── 01_regression/
│   ├── 01_linear_and_polynomial/
│   ├── 02_regularization_ridge_lasso_elasticnet/
│   ├── 03_support_vector_regression/
│   └── 04_use_case_ispark_analysis/        (henüz eklenmedi)
├── 02_classification/
│   ├── 01_logistic_regression/
│   ├── 02_support_vector_machines/
│   ├── 03_decision_trees/
│   └── 04_k_nearest_neighbors/
└── 03_ensemble_and_boosting/
    ├── 01_random_forest/
    ├── 02_adaboost/
    ├── 03_gradient_boosting/
    ├── 04_xgboost/
    └── 05_lightgbm/
```

Her dolu klasörde aynı düzen var: `README.md` (veri setinden bağımsız, sınav
çalışma notu formatında konu anlatımı) + gerçek bir veri seti üzerinde
çalıştırılmış `.ipynb` notebook + o veri seti.
