# Bitcoin Saatlik Volatilite Tahmini — GARCH Ailesi Modelleri

**Bitirme Projesi** — Bitcoin'in saatlik getiri volatilitesini GARCH ailesi modelleriyle
tahmin etmeye çalışan uçtan uca bir zaman serisi analizi projesi.

- **Veri:** BTC-USD saatlik, `yfinance`, 2024-08-20 – 2026-08-19
- **Örneklem:** 17.324 temiz gözlem (v4 veri hazırlama)
- **Nihai Model:** EGARCH(1,1) × Skewed-t (AIC = 175.063,06)

## Klasör Yapısı

```
01_individual_crypto_volatility/
├── 01_Raporlar/
│   ├── nihai_rapor.txt              # Proje raporu
│   └── proje_tam_paket.txt          # Tam paket açıklaması
├── 02_Scriptler/
│   ├── veri_hazirlama_v4.py         # Veri indirme + temizleme
│   ├── asama_a_c.py                 # İstatistikler + model ızgarası
│   ├── asama_d_f.py                 # Model seçimi + tanısal testler
│   ├── asama_g_j.py                 # OOS + VaR + alt dönem
│   ├── duyarlilik_analizi.py        # 8 teknik soru analizi
│   ├── kalani_coz.py                # vol_oran + eşik analizi
│   └── bosluk_piyasa_analiz.py      # 5 boşluk fiyat analizi
├── 03_Veri/
│   └── bitcoin_saatlik_temiz.csv    # Temiz veri (17.324 gözlem)
├── 04_Sonuclar/
│   ├── CSV/                         # Model karşılaştırma, tanısal test, OOS, VaR sonuçları
│   └── Grafikler/                   # ACF/PACF, dağılım, volatilite kümelenmesi, VaR backtest grafikleri
├── 05_Notebook/
│   └── bitcoin_garch_analiz.ipynb   # Tüm analiz tek dosyada
├── 06_Medium_Makalesi/
│   ├── BTC_Volatilite_Makale.md
│   ├── BTC_Volatilite_Makale_Medium.md
│   └── gorseller/                   # Makale görselleri
├── Bitcoin_Volatilite_Bitirme_Projesi_Raporu.docx
├── Bitcoin_Volatilite_Sunum.pptx
└── README.md                        # Bu dosya
```

## Scriptlerin Çalıştırılması

Sırayla çalıştırın:

```bash
# 1. Veri hazırlama
python 02_Scriptler/veri_hazirlama_v4.py

# 2. Aşama A-C (İstatistikler + Model Izgarası)
python 02_Scriptler/asama_a_c.py

# 3. Aşama D-F (Model Seçimi + Tanısal Testler)
python 02_Scriptler/asama_d_f.py

# 4. Aşama G-J (OOS + VaR)
python 02_Scriptler/asama_g_j.py
```

## Gerekli Kütüphaneler

```
pandas
numpy
scipy
arch
statsmodels
matplotlib
seaborn
yfinance
```

## Nihai Sonuçlar

| Metrik | Değer |
|---|---|
| Nihai Model | EGARCH(1,1) × Skewed-t |
| AIC | 175.063,06 |
| BIC | 175.132,90 |
| Ortalama Denklemi | AR(2) |
| Kalıcılık (beta) | 0.9480 (durağan) |
| Asimetri (gamma) | -0.027 (kaldıraç etkisi) |
| Nu (eta) | 3.29 |

## Bu Proje ve Bootcamp Müfredatı Arasındaki Bağlantı
Bu proje, `04_time_series_forecasting` bölümündeki ARIMA/SARIMA konu anlatımının
doğal bir devamı niteliğindedir: durağanlık testleri (ADF), ACF/PACF analizi ve
model seçim kriterleri (AIC/BIC) burada da temel alınmış, ek olarak finansal
zaman serilerine özgü **volatilite kümelenmesi** ve **GARCH ailesi modeller**
(GARCH, EGARCH, koşullu dağılım seçimi) ile genişletilmiştir.
