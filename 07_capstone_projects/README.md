## Bireysel Proje

- [01_bitcoin_volatility/](01_bitcoin_volatility/) — Bitcoin Fiyat Volatilitesinin Analizi ve Modellenmesi

### 01_bitcoin_volatility/

Bu proje, Bitcoin'in geçmiş fiyat verileri kullanılarak volatilite (oynaklık) davranışının incelenmesini kapsamaktadır. Kripto para piyasalarının yüksek oynaklık göstermesi, hem yatırımcılar hem de risk yönetimi açısından bu tür analizleri önemli kılmaktadır.

**Amaç:**
- Bitcoin fiyat hareketlerindeki oynaklığı zaman içinde incelemek
- Getiri serisindeki volatilite kümelenmesini (volatility clustering) tespit etmek
- İstatistiksel/ekonometrik yöntemlerle (ör. hareketli standart sapma, GARCH modelleri) volatiliteyi modellemek ve yorumlamak

**Kullanılan Yöntem ve Araçlar:**
- Python (pandas, numpy, matplotlib/seaborn)
- Günlük/saatlik getiri hesaplamaları (log return)
- Hareketli pencere (rolling window) volatilite hesaplama
- (Varsa) ARCH/GARCH tipi volatilite modelleri

**İçerik:**
- `data/` — Analizde kullanılan Bitcoin fiyat verileri
- Veri ön işleme ve temizleme adımları
- Volatilite hesaplama ve görselleştirme
- Bulguların yorumlanması

**Sonuç:**
Analiz sonucunda Bitcoin fiyatlarının belirli dönemlerde yüksek oynaklık gösterdiği, bu dönemlerin genellikle piyasadaki önemli haber akışları veya makroekonomik gelişmelerle örtüştüğü gözlemlenmiştir.



# Grup Projeleri

Bu depo, veri analizi kursu kapsamında geliştirilen grup projelerini içerir.

- [`02_group_llm_carbon_footprint/`](./02_group_llm_carbon_footprint/) — AI Modellerinin Karbon Emisyonu Analizi, Tahmini ve Raporlanması

## `data/`

Grup projeleri arasında paylaşılan/ortak ham veri dosyaları için ayrılmıştır. Her grubun kendi projesine özgü veri seti, ilgili grup klasörünün kendi `data/` alt klasöründe tutulur.
