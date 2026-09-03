# 02 — LLM Carbon Footprint

AI modellerinin eğitim sürecinden kaynaklanan karbon emisyonlarını mevcut bilgilerden **doğrudan hesaplayan**, gerekli bilgiler eksik olduğunda **makine öğrenmesiyle tahmin eden** ve sonucu kullanıcıya **şeffaf, açıklanabilir ve sürdürülebilirlik odaklı** biçimde raporlayan bir sistem.

## Proje Bileşenleri

1. **Direct Carbon Calculation** — Elektrik tüketimi ve emisyon faktörü mevcut olduğunda karbonun fiziksel formülle doğrudan hesaplanması.
2. **Machine Learning Prediction** — Doğrudan hesaplama için gerekli bilgiler eksik olduğunda, XGBoost tabanlı bir modelle emisyonun tahmin edilmesi.
3. **Reporting / Sustainability Layer** — Sonucun kaynağı, güvenilirlik seviyesi (Confidence Score) ve sürdürülebilirlik bağlamıyla (Sustainability Score) birlikte sunulması.

## Klasör Yapısı

```
02_group_llm_carbon_footprint/
├── data/          # Ham veri seti (HF_models_imputed_realistic_v2.csv)
├── notebooks/      # Uçtan uca analiz + modelleme + model kaydı (carbon_emissions_FINAL.ipynb)
├── src/            # (Ayrı Python modülüne çıkarılacak yeniden kullanılabilir kod için ayrılmıştır)
├── reports/        # Proje raporu, Medium yazısı, sunum soru-cevap hazırlığı
└── README.md
```

## Notebook İçeriği (`notebooks/carbon_emissions_FINAL.ipynb`)

- Keşifsel Veri Analizi (EDA) ve veri kalitesi kontrolleri
- Feature Engineering (14 leakage-safe feature) ve otomatik leakage kontrolü
- DummyRegressor, Linear Regression, XGBoost (Original / Regularized / Tuned) karşılaştırması
- 5-Fold Cross Validation, overfitting analizi, RandomizedSearchCV ile hiperparametre optimizasyonu
- Feature importance, residual/outlier analizi
- Final model seçimi (Tuned XGBoost)
- Hybrid Carbon Estimation System, Confidence Score, Sustainability Score
- Final modelin tüm veri üzerinde yeniden eğitilmesi, kaydedilmesi (`joblib`) ve round-trip doğrulaması
- Yeniden kullanılabilir tahmin fonksiyonu ve demo

> Notebook Google Colab için hazırlanmıştır (`drive.mount` kullanır). Çalıştırmadan önce `data/HF_models_imputed_realistic_v2.csv` dosyasını kendi Drive'ınızdaki `grup_proje_veri/` klasörüne yükleyin veya notebook'taki veri okuma hücresini yerel yola göre güncelleyin.

## Raporlar (`reports/`)

| Dosya | İçerik |
|---|---|
| `Karbon_Emisyonu_Proje_Raporu_Siyah_Sik.docx` | Akademik/profesyonel format, uçtan uca proje raporu |
| `Karbon_Emisyonu_Projesi_Medium_Yazisi.md` | Blog/Medium formatında anlatı tarzı proje yazısı |
| `Sunum_Soru_Cevap_Hazirlik.md` | Sunum sonrası gelebilecek sorular ve hazır cevapları |

## Kaydedilen Model

Notebook çalıştırıldığında final model paketi (`carbon_emission_model_bundle.joblib`) — model, feature listeleri, seyrek kategori haritası, kategori seviyeleri ve hedef dönüşüm bilgisiyle birlikte — Drive'daki `grup_proje_veri/` klasörüne kaydedilir.
