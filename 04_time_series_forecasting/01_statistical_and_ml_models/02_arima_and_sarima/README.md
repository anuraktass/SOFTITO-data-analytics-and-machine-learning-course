# ARIMA ve SARIMA — Konu Anlatımı (Özet)

## 1. Zaman Serisi Nedir?

Zaman serisi, bir değişkenin zaman içinde belirli aralıklarla (günlük, aylık, yıllık vb.) ölçülen değerler dizisidir. Bir zaman serisi genelde 3 bileşenden oluşur:

| Bileşen | Açıklama |
|---|---|
| **Trend (Tₜ)** | Serinin uzun vadeli artış/azalış eğilimi |
| **Mevsimsellik (Sₜ)** | Belirli periyotlarda (hafta, ay, yıl) tekrar eden örüntüler |
| **Kalıntı / Gürültü (Rₜ)** | Trend ve mevsimsellikle açıklanamayan rastgele kısım |

Bir seri şu şekilde ayrıştırılabilir:
- Toplamsal (additive): `Yₜ = Tₜ + Sₜ + Rₜ`
- Çarpımsal (multiplicative): `Yₜ = Tₜ × Sₜ × Rₜ`

## 2. Durağanlık (Stationarity) Kavramı

ARIMA ailesi modellerin çalışabilmesi için serinin **durağan** olması gerekir. Durağan bir seri şu 3 özelliği taşır:
1. Sabit ortalama (zamanla değişmez)
2. Sabit varyans
3. Otokovaryans yalnızca gecikmeye (lag) bağlıdır, zamana bağlı değildir

### Durağanlık Testleri
- **ADF (Augmented Dickey-Fuller) Testi**
  - H0: Seri durağan değil (birim kök var)
  - p-değeri ≤ 0.05 → H0 reddedilir → **seri durağan**
  - p-değeri > 0.05 → **seri durağan değil**, fark alma (differencing) gerekir
- **KPSS Testi**: ADF'nin tersi bir hipotez yapısına sahiptir, genelde ADF ile birlikte doğrulama amaçlı kullanılır.

### Durağan Hale Getirme
- **Fark alma (differencing):** `Yₜ' = Yₜ − Yₜ₋₁` (birinci dereceden fark, "d=1")
- Gerekirse ikinci kez fark alınabilir ("d=2")
- Mevsimsel seriler için **mevsimsel fark**: `Yₜ' = Yₜ − Yₜ₋ₘ` (m = periyot, örn. aylık veri için 12)

## 3. ACF ve PACF Grafikleri

Model derecelerini (p, q) belirlemek için kullanılır:

| Grafik | Ne Gösterir | Kullanımı |
|---|---|---|
| **ACF** (Autocorrelation Function) | Serinin kendi gecikmeli değerleriyle korelasyonu | MA (q) derecesini tahmin etmede yardımcı |
| **PACF** (Partial Autocorrelation Function) | Ara gecikmelerin etkisi çıkarılmış doğrudan korelasyon | AR (p) derecesini tahmin etmede yardımcı |

Kural (genel sezgi):
- PACF grafiği lag p'de aniden kesiliyorsa → AR(p) uygun
- ACF grafiği lag q'da aniden kesiliyorsa → MA(q) uygun

## 4. ARIMA(p, d, q) Modeli

**AR + I + MA** bileşenlerinin birleşimidir:

- **AR(p) — AutoRegressive:** Serinin geçmiş p değerine bağlı olarak modellenmesi
  `Yₜ = c + φ₁Yₜ₋₁ + φ₂Yₜ₋₂ + ... + φₚYₜ₋ₚ + εₜ`
- **I(d) — Integrated:** Seriyi durağan hale getirmek için gereken fark alma sayısı
- **MA(q) — Moving Average:** Geçmiş q hata teriminin ağırlıklı ortalaması
  `Yₜ = c + εₜ + θ₁εₜ₋₁ + θ₂εₜ₋₂ + ... + θ_qεₜ₋q`

**Parametreler:**
| Parametre | Anlamı |
|---|---|
| p | AR derecesi (kaç geçmiş değer kullanılıyor) |
| d | Fark alma sayısı (durağanlaştırma) |
| q | MA derecesi (kaç geçmiş hata terimi kullanılıyor) |

ARIMA, **mevsimsellik içermeyen** ya da mevsimselliği zayıf olan serilerde iyi çalışır.

## 5. SARIMA(p,d,q)(P,D,Q,m) Modeli

Mevsimsel örüntü içeren seriler için ARIMA'nın genişletilmiş halidir. İki katmanlı yapıya sahiptir:

- **Mevsimsel olmayan kısım:** (p, d, q) — kısa vadeli ilişkiler
- **Mevsimsel kısım:** (P, D, Q, m) — m periyotluk tekrar eden örüntüler

| Parametre | Anlamı |
|---|---|
| P | Mevsimsel AR derecesi |
| D | Mevsimsel fark alma sayısı |
| Q | Mevsimsel MA derecesi |
| m | Mevsimsel periyot (örn. aylık veri → 12, haftalık günlük veri → 7) |

Örnek: `SARIMA(1,1,1)(1,1,1,12)` → aylık veri, hem normal hem mevsimsel bileşenler dahil.

## 6. Model Kurma Süreci (Box-Jenkins Yaklaşımı)

1. **Veriyi görselleştir** — trend/mevsimsellik var mı gözle incele
2. **Durağanlık testi** yap (ADF/KPSS)
3. Gerekirse **fark al** (d ve/veya D)
4. **ACF/PACF** grafiklerine bak ya da `auto_arima` ile otomatik p,d,q (ve P,D,Q,m) seç
5. **Modeli eğit** (train seti üzerinde)
6. **Tahmin yap** (test seti / gelecek için)
7. **Hata metrikleriyle değerlendir**: RMSE, MAE, MAPE
8. **Artıkları (residuals) kontrol et** — beyaz gürültüye benziyor mu (Ljung-Box testi)

## 7. Model Seçim Kriterleri

- **AIC (Akaike Information Criterion)** ve **BIC (Bayesian Information Criterion):** Düşük olan model tercih edilir. Modelin karmaşıklığı ile veriye uyumu arasında denge kurar.
- **RMSE / MAE:** Test verisi üzerindeki tahmin hatasını ölçer, model karşılaştırmada kullanılır.

## 8. ARIMA vs SARIMA — Ne Zaman Hangisi?

| Durum | Önerilen Model |
|---|---|
| Mevsimsellik yok / zayıf | ARIMA |
| Belirgin, tekrar eden mevsimsel örüntü var (haftalık, aylık, yıllık) | SARIMA |
| Dışsal değişkenler (örn. tatil, promosyon) de modele katılacaksa | ARIMAX / SARIMAX |

## 9. Pratikte Kullanılan Araçlar

- `statsmodels.tsa.arima.model.ARIMA` — ARIMA modeli
- `statsmodels.tsa.statespace.sarimax.SARIMAX` — SARIMA / SARIMAX modeli
- `pmdarima.auto_arima` — p,d,q (ve P,D,Q,m) parametrelerini otomatik arayarak en iyi AIC'yi bulur
- `statsmodels.tsa.stattools.adfuller` — ADF durağanlık testi
- `statsmodels.graphics.tsaplots.plot_acf / plot_pacf` — ACF/PACF grafikleri

## 10. Özet Akış Şeması

```
Veri → Görselleştir → Durağan mı? (ADF testi)
                          │
                 Hayır ───┴─── Evet
                  │              │
             Fark al (d/D)       │
                  │              │
                  └──────┬───────┘
                         ▼
              ACF/PACF veya auto_arima
                  ile p,d,q seç
                         │
              Mevsimsellik var mı?
                  │            │
                 Evet          Hayır
                  │              │
              SARIMA          ARIMA
                  │              │
                  └──────┬───────┘
                         ▼
                Modeli eğit → Tahmin yap
                         │
              RMSE/MAE ile değerlendir
```
