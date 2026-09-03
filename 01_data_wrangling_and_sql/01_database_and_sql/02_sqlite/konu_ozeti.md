# SQLite — Temelden İleri Seviyeye

## SQLite Nedir?
SQLite, sunucu gerektirmeyen, tek bir dosya üzerinde çalışan hafif bir ilişkisel
veritabanı motorudur. MySQL veya PostgreSQL'in aksine ayrı bir sunucu süreci çalıştırmaya
gerek yoktur; veritabanının tamamı diskteki tek bir `.db` dosyasındadır.

- **Sunucusuz:** Uygulama veritabanı dosyasını doğrudan okur/yazar.
- **Sıfır yapılandırma:** Kurulum, kullanıcı yönetimi veya port ayarı gerekmez.
- **Taşınabilir:** Tek dosyayı kopyalayarak tüm veritabanı taşınır.
- **Kullanım alanı:** Mobil uygulamalar, masaüstü yazılımlar, prototipler, küçük-orta
  ölçekli web uygulamaları, test ortamları.

## Kurulum ve bağlanma
Çoğu Linux/macOS sisteminde SQLite zaten kuruludur (`sqlite3 --version`). Bir veritabanı
dosyası oluşturmak için `sqlite3 dosya_adi.db` yeterlidir — dosya yoksa otomatik
oluşturulur. Faydalı nokta komutları: `.tables`, `.schema tablo_adi`, `.mode column`,
`.headers on`, `.quit`.

## Tablo oluşturma ve veri tipleri
Tablolar `CREATE TABLE` ile tanımlanır. SQLite'ta temel veri tipleri: `INTEGER`, `TEXT`,
`REAL`, `BLOB`, `NULL`. `PRIMARY KEY AUTOINCREMENT` ile otomatik artan kimlik alanı
tanımlanır.

## Temel işlemler
- **INSERT:** `INSERT INTO tablo (sütun1, sütun2) VALUES (...)`
- **SELECT / filtreleme / sıralama / limit:** `WHERE`, `ORDER BY`, `LIKE '%...%'`, `LIMIT`
- **UPDATE / DELETE:** koşullu güncelleme ve silme

## JOIN — tablolar arası ilişki
Gerçek uygulamalarda veri birden fazla tabloya yayılır. `JOIN ... ON` ile ilişkili
tablolar birleştirilir; bir kaydın karşı tarafta eşleşmesi olmasa bile listede
görünmesi isteniyorsa `LEFT JOIN` kullanılır.

## İndeksler
`CREATE INDEX` ile sık sorgulanan sütunlarda arama hızlandırılır. Küçük tablolarda fark
hissedilmez ama tablo büyüdükçe kritik hale gelir. Sorgu planlayıcısının indeksi
kullanıp kullanmadığı `EXPLAIN QUERY PLAN` ile görülebilir. Her sütuna indeks eklemek
yazma işlemlerini yavaşlatır — yalnızca gerçekten sık filtrelenen/JOIN edilen sütunlara
eklenmelidir.

## Transaction'lar
Birden fazla işlemi "hep birlikte başarılı ya da hep birlikte geri alınacak" şekilde
çalıştırmak için `BEGIN TRANSACTION ... COMMIT` kullanılır; bir sorun olursa
`ROLLBACK` ile geri alınır (örn. bir hesaptan para düşüp diğerine eklerken).

## Python ile SQLite
Python'ın standart kütüphanesi `sqlite3` modülünü hazır içerir, ekstra kurulum
gerekmez: `sqlite3.connect("dosya.db")` → `cursor()` → `execute()` → `commit()`.

## İpuçları
- **Yedekleme:** dosyayı kopyalamak yeterlidir (`cp magaza.db magaza_yedek.db`).
- **Dışa aktarma:** `sqlite3 magaza.db .dump > yedek.sql`
- **Kısıt:** çok yüksek eşzamanlı yazma yükünde darboğaz yaşanabilir; böyle
  senaryolarda PostgreSQL gibi istemci-sunucu bir veritabanı tercih edilir.
