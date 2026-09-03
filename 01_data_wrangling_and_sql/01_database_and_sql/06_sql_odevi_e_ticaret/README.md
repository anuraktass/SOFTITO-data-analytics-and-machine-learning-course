# SQL Ödevi — ShopHub E-Ticaret Veritabanı Üzerinde 36 Pratik Sorgu

Bu klasördeki `shophub_odev_sorgulari.sql`, sıfırdan kurulan bir **e-ticaret (ShopHub)**
veritabanı şeması üzerinde hazırlanmış, çözümleriyle birlikte 36 soruluk bir SQL
pratik ödevidir. (Dosya adı yükleme sırasında "hastane_sorgulari" kalmış olsa da
içerik hastaneyle ilgili değildir — e-ticaret şemasıdır, isim düzeltilerek
`shophub_odev_sorgulari.sql` olarak kaydedildi.)

## Şema — 13 Tablo
`kategoriler`, `saticilar`, `musteriler`, `urunler`, `siparisler`,
`siparis_detaylari`, `odemeler`, `kargo_sirketleri`, `kargo_tracking`,
`yorumlar`, `promosyonlar`, `favoriler`, `indirimler`

Bu şema, `05_ornek_veritabanlari` klasöründeki finans/spor/hastane/medya
şemalarına ek olarak **e-ticaret** alanında ayrı bir pratik alanı sağlar:
kategori → ürün → sipariş → sipariş detayı → ödeme → kargo takibi zincirini,
ayrıca yorum/favori/promosyon gibi yardımcı tabloları içerir.

## Soru Kapsamı (36 Soru)
Sorular zorluk sırasına göre ilerler:
1. **1-10:** Temel `SELECT`, `WHERE`, `ORDER BY`, `IN`, karşılaştırma operatörleri
2. **11-20:** Tek `JOIN`, `COUNT`, `AVG`, `LIMIT`, çok tablolu basit filtreler
3. **21-30:** Çoklu `JOIN` (3-4 tablo), `GROUP BY`, alt sorgulara yakın karmaşıklık
4. **31-36:** Tarih fonksiyonları (`DATE()`, `INTERVAL`), çoklu `JOIN` + `GROUP BY`
   kombinasyonları, `information_schema` ile şema keşfi

## Örnek Sorular
- "Kategorisi 'Elektronik' olan ürünlerin adlarını ve stok sayılarını göster." (JOIN)
- "Hangi müşteri en çok para harcadı?" (`ORDER BY ... LIMIT 1`)
- "Her kargo şirketinin ortalama kaç günde teslim ettiğini hesapla." (tarih farkı + GROUP BY)
- "Müşteri 'Mehmet Kaya' hangi ürünleri aldı, kargo durumu nedir, kaç TL harcadı?" (4 tablolu JOIN)

## Bu Ödevin Diğer Konularla Bağlantısı
- **01_veritabani_temelleri** ve **04_er_diyagrami_ve_semalar**'da öğrenilen
  PK/FK ilişkilerinin (1:N — bir müşterinin birden çok siparişi; bir siparişin
  birden çok detay satırı) gerçek bir şemada uygulanmasıdır.
- **02_sqlite** / **03_postgresql**'de öğrenilen `JOIN`, `GROUP BY`, agregasyon
  fonksiyonlarını pekiştirmek için doğrudan çözülebilir bir alıştırma setidir.

## Nasıl Çalıştırılır
```bash
psql -U postgres -d odev_db -f shophub_odev_sorgulari.sql
```
Dosya hem şema oluşturma + örnek veri ekleme hem de 36 sorunun çözüm sorgularını
tek seferde içerir; PostgreSQL 13+ ile uyumludur.
