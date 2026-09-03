# PostgreSQL Cheatsheet — Konu Özeti

PostgreSQL, SQLite'tan farklı olarak istemci-sunucu mimarisiyle çalışan, gelişmiş veri
tipleri, eşzamanlılık kontrolü ve genişletilebilirlik sunan güçlü bir açık kaynak
ilişkisel veritabanı sistemidir. Rehber, aşağıdaki kategorilerde çalışan komut
örnekleri içeriyor:

## 1) Bağlantı ve Veritabanı Yönetimi
- Node.js için bağlantı string'i, bağlantıyı sonlandırma
- Veritabanı oluşturma / silme / listeleme
- Aktif veritabanını gösterme, veritabanı seçme (`\c dbname`)

## 2) Tablo Yönetimi (DDL)
- Basit tablo oluşturma, ilişkili (FOREIGN KEY'li) tablo oluşturma
- Tablo silme, tablo yapısını gösterme (`\d tablo_adi`), tüm tabloları listeleme
- Sütun ekleme / silme / tipi değiştirme (`ALTER TABLE`)
- Şema (schema) oluşturma

## 3) Sorgulama (SELECT ailesi)
- Temel `SELECT`, `WHERE` koşulu, `ORDER BY` sıralama, `LIMIT`/`OFFSET`
- Toplama fonksiyonları: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` ve `HAVING`
- `DISTINCT` ile benzersiz değerler
- `INNER JOIN` ve `LEFT JOIN` (ilişkili `orders` verisiyle örneklenmiş)

## 4) Veri Değiştirme (DML)
- `INSERT` — tek satır, çok satır, `SELECT` ile ekleme
- `UPDATE` — tek veri, birden fazla sütun, işlem (transaction) ile güncelleme
- `DELETE` — satır silme, birden fazla satır silme
- `TRUNCATE` ile tabloyu tamamen boşaltma
- `UPSERT` (`INSERT ... ON CONFLICT DO UPDATE`) — ekle ya da güncelle

## 5) Kısıtlamalar ve Performans
- `INDEX` oluşturma ve silme — hızlı arama
- `UNIQUE` ve `CHECK` kısıtlamaları
- `DEFAULT` değer tanımlama
- `EXPLAIN` ile sorgu planı analizi

## 6) İleri Seviye Nesneler
- `VIEW` (sanal tablo) oluşturma ve silme
- Fonksiyon oluşturma (`CREATE FUNCTION`)
- `TRIGGER` — bir olay gerçekleştiğinde otomatik çalışan işlem
- `Transaction` — güvenli, geri alınabilir işlem blokları
- Terminalden `pg_dump` ile backup alma

**Not:** SQLite ile karşılaştırıldığında PostgreSQL; çoklu kullanıcı erişimi,
gelişmiş veri tipleri (JSON, array, vb.), view/trigger/function gibi sunucu tarafı
nesneler ve büyük ölçekli/yüksek eşzamanlı uygulamalar için tercih edilir.
