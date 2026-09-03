# Veritabanı Temelleri — Şemadan Sorguya

## Veritabanı nedir?
Veritabanı, verinin düzenli biçimde saklandığı, hızlıca aranabildiği ve güvenilir biçimde
güncellenebildiği bir sistemdir. **Veri** ile onu yöneten yazılım olan
**Veritabanı Yönetim Sistemi (DBMS)** — MySQL, PostgreSQL, SQLite, SQL Server gibi —
birbirinden ayrı kavramlardır. Düz bir metin dosyasından farkı: veritabanı verinin
tekrarını engeller, tutarlılığı garanti eder ve aynı anda birden çok kullanıcının
güvenle okuyup yazmasına izin verir.

## Tablolar: satır ve sütun
İlişkisel bir veritabanında veri **tablolarda** tutulur. Her tablo tek bir konuyu temsil
eder (müşteriler, ürünler, siparişler...).
- **Satır (kayıt):** tablodaki tek bir varlığın tüm bilgisi (örn. tek bir müşteri).
- **Sütun (alan):** her satırın ortak bir özelliği (ad, e‑posta, kayıt tarihi...).
- **Veri tipi:** sütunun ne tür değer taşıyacağını belirler (sayı, metin, tarih...).

## Anahtarlar: kaydı benzersiz kılmak
- **Primary Key (Birincil Anahtar):** her satırı benzersiz tanımlayan sütun; boş
  olamaz, tekrar edemez.
- **Foreign Key (Yabancı Anahtar):** başka bir tablonun primary key'ine işaret eden
  sütun; ilişkiyi kurar.
- **Unique/aday anahtar:** tekrar etmemesi gereken ama tabloyu tanımlamayan sütun
  (örn. e‑posta).

Örnek: `musteriler.id` birincil anahtar, `siparisler.musteri_id` ise ona işaret eden
yabancı anahtardır — ilişkiyi kuran bağ tam olarak budur.

## İlişkiler: tabloları birbirine bağlamak
Tablolar arasındaki ilişki üç biçimden birini alır:
1. **1—1:** bir kayıt karşı tarafta en fazla bir kayıtla eşleşir (kullanıcı ↔ kimlik bilgisi).
2. **1—N:** bir kayıt karşı tarafta birden çok kayıtla eşleşebilir (bir müşteri ↔ birden
   çok sipariş).
3. **N—N:** her iki taraf da birden çok kayıtla eşleşebilir; genelde araya bir
   **bağ (junction) tablosu** konur (öğrenciler ↔ dersler).

## SQL: veritabanıyla konuşma dili
SQL komutları dört ana gruba ayrılır: **DDL** (CREATE, ALTER, DROP — yapı), **DML**
(INSERT, UPDATE, DELETE — veri), **DQL** (SELECT — sorgulama), **DCL** (GRANT, REVOKE —
yetki). İki tabloyu birlikte sorgulamak (ilişkiyi kullanmak) `JOIN` ile yapılır.

## Normalizasyon: tekrarı azaltmak
Aynı bilgiyi birden çok yerde tekrar etmemek için veriyi mantıklı tablolara bölme
sürecidir. Örneğin müşteri adını her sipariş satırına yazmak yerine, siparişe sadece
`musteri_id` yazılır; ad bir kez `musteriler` tablosunda tutulur.
- **Fayda:** bir müşteri adını değiştirdiğinde tek bir yeri güncellemek yeterlidir,
  tutarsızlık riski ortadan kalkar.
- **Bedel:** veriyi geri okumak için tabloları `JOIN` ile birleştirmek gerekir.

## İşlemler ve ACID güvencesi
Bir **transaction (işlem)**, birden fazla adımı "ya hepsi ya hiçbiri" mantığıyla
çalıştırır (örn. bir hesaptan para düşüp diğerine eklemek). Bu güvence dört ilkeyle
tanımlanır: **A**tomicity, **C**onsistency, **I**solation, **D**urability (ACID).

## İndeksler: hızlı arama
Bir tabloda milyonlarca satır varsa `WHERE email = ...` gibi bir arama her satırı tek
tek kontrol etmek zorunda kalabilir. **İndeks**, sık aranan sütunlar için önceden
hazırlanmış bir "arama defteri" gibidir. Bedeli vardır: her INSERT/UPDATE işleminde
indeksin de güncellenmesi gerekir; bu yüzden yalnızca gerçekten sık filtrelenen veya
JOIN edilen sütunlara indeks eklenir.

## Öğrenme sırası — kısa özet
1. Tablo, satır, sütun kavramlarıyla veriyi düzenle.
2. Primary/Foreign key ile kayıtları benzersiz ve bağlı kıl.
3. İlişki türünü (1‑1, 1‑N, N‑N) doğru modelle.
4. `SELECT`, `JOIN`, `WHERE` ile veriyi sorgula.
5. Kritik işlemleri transaction içine al, ACID güvencesine güven.
6. Performans gerektiğinde doğru sütunlara indeks ekle.
