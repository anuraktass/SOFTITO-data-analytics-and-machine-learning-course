"""
ÖRNEK ÇALIŞMA: Python + SQLite
Konu: Bağlanma, tablo oluşturma, veri ekleme, sorgulama, JOIN, transaction
Bu dosyayı doğrudan çalıştırabilirsin: python3 ornek_calisma.py
"""
import sqlite3

# 1) Bağlantı (dosya yoksa otomatik oluşturulur)
baglanti = sqlite3.connect("magaza.db")
imlec = baglanti.cursor()

# 2) Tablo oluşturma
imlec.execute("""
CREATE TABLE IF NOT EXISTS musteriler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL,
    eposta TEXT UNIQUE NOT NULL
)
""")

imlec.execute("""
CREATE TABLE IF NOT EXISTS siparisler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    musteri_id INTEGER NOT NULL,
    urun TEXT NOT NULL,
    tutar REAL NOT NULL,
    FOREIGN KEY (musteri_id) REFERENCES musteriler(id)
)
""")

# 3) Veri ekleme (aynı veriyi tekrar eklememek için önce temizleyelim)
imlec.execute("DELETE FROM siparisler")
imlec.execute("DELETE FROM musteriler")

imlec.executemany(
    "INSERT INTO musteriler (ad, eposta) VALUES (?, ?)",
    [("Elif Kaya", "elif@ornek.com"), ("Barış Demir", "baris@ornek.com")],
)

imlec.executemany(
    "INSERT INTO siparisler (musteri_id, urun, tutar) VALUES (?, ?, ?)",
    [(1, "Klavye", 850.0), (1, "Mouse", 250.0), (2, "Monitör", 4200.0)],
)
baglanti.commit()

# 4) Sorgulama — JOIN ile müşteri + sipariş bilgisini birlikte okuma
print("--- Tüm siparişler ---")
for satir in imlec.execute("""
    SELECT m.ad, s.urun, s.tutar
    FROM siparisler s
    JOIN musteriler m ON s.musteri_id = m.id
    ORDER BY m.ad
"""):
    print(satir)

# 5) Filtreleme: 500 TL üzeri siparişler
print("\n--- 500 TL üzeri siparişler ---")
for satir in imlec.execute("SELECT urun, tutar FROM siparisler WHERE tutar > 500"):
    print(satir)

# 6) Transaction örneği: para transferi benzeri "ya hepsi ya hiçbiri" mantığı
try:
    imlec.execute("BEGIN")
    imlec.execute("UPDATE siparisler SET tutar = tutar - 50 WHERE id = 1")
    imlec.execute("UPDATE siparisler SET tutar = tutar + 50 WHERE id = 2")
    baglanti.commit()
    print("\nTransaction başarılı: iki sipariş de güncellendi.")
except Exception as e:
    baglanti.rollback()
    print("Hata oluştu, değişiklikler geri alındı:", e)

baglanti.close()

# ALIŞTIRMA (kendin dene):
# a) "iade_edildi" adında bir sütun ekle (ALTER TABLE) ve iade edilen siparişleri say.
# b) Her müşterinin toplam harcamasını GROUP BY ile hesapla.
