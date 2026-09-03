# Excel / CSV ile Veri Analizi Pratik Setleri

Bu klasördeki dosyalar, veritabanı ve BI derslerinde öğrenilen kavramları
(filtreleme, gruplama, KPI hesaplama, veri modelleme) tablo tabanlı araçlarla
(Excel, Power Query, pandas) pratik etmek için hazırlanmış çeşitli veri setleridir.

## Veri setleri ve içerikleri

### 1) satis_veriler.csv + urun_veriler.csv
İki ayrı tablo — **1:N ilişki** kurmak için birebir uygun: `satis_veriler.csv`
içindeki `UrunID`, `urun_veriler.csv` içindeki ürün bilgisine (kategori, stok,
tedarikçi) bağlanır. Sütunlar: SatışID, MüşteriID, UrunID, Satış Tarihi/Saati,
Miktar, Birim Fiyat, Toplam Tutar, Satış Temsilcisi, Ödeme Yöntemi.
**Pratik:** VLOOKUP/XLOOKUP veya Power Query Merge ile iki tabloyu birleştirme,
kategori bazında pivot tablo.

### 2) satislar.xlsx (Satislar + Urunler sayfaları)
Bölge bazlı satış verisi (Tarih, UrunID, Bölge, Adet, Tutar) + ürün kataloğu.
**Pratik:** bölge × zaman kırılımında pivot tablo, `TOPLA.ÇARPIM`/`SUMPRODUCT`
ile ciro hesaplama.

### 3) student_data.xlsx
Öğrenci performans verisi: Ad, Sınıf, ders notları (Matematik, Fizik, Kimya,
Türkçe, İngilizce, Bilgisayar), Katılım, Devamsızlık, Ortalama, Durum, Seviye.
**Pratik:** koşullu biçimlendirme ile başarısız öğrencileri işaretleme,
`ORTALAMAEĞER` ile sınıf bazında ders ortalaması, devamsızlık-başarı ilişkisini
scatter grafikle inceleme.

### 4) saas_ileri.xlsx (Abonelikler, Musteriler, SatisEkibi, Bolgeler)
Bir SaaS şirketinin aylık tekrarlayan gelir (**MRR**) verisi — çok tablolu, ileri
seviye bir model. `Abonelikler` (MusteriID, YılAy, MRR, Durum), `Musteriler`
(segment, bölge, satış temsilcisi), `SatisEkibi` (hiyerarşi: YoneticiID).
**Pratik:** aylık MRR trendi, müşteri kaybı (**churn**) oranı hesaplama, segment
bazında MRR dağılımı — Power BI/İş Zekası konusundaki "yıldız şema" mantığının
gerçek bir SaaS örneği.

### 5) urun_veriler.csv
Ürün ana verisi (UrunID, Ürün Adı, Kategori, Birim Fiyatı, Stok Miktarı,
Tedarikçi) — satış verileriyle birleştirilecek boyut (dimension) tablosu.

## Genel öğrenme akışı
1. Tek tabloda temel filtre/sıralama/pivot (satis_veriler.csv).
2. İki tabloyu ilişkilendirme — VLOOKUP/Merge (satis_veriler + urun_veriler).
3. Çok sayfalı/çok tablolu model kurma (saas_ileri.xlsx) — Power BI konusundaki
   yıldız şema mantığının Excel'deki karşılığı.
4. Sonuçları bir dashboard/rapora dönüştürme (bkz. 02_is_zekasi_ve_raporlama).
