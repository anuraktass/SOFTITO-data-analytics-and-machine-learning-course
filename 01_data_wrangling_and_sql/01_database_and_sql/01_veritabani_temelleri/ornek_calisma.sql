-- =====================================================
-- ÖRNEK ÇALIŞMA: Veritabanı Temelleri
-- Konu: Tablo, Primary/Foreign Key, 1-N İlişki, Normalizasyon
-- Basit bir "Kütüphane" senaryosu üzerinden pekiştirme
-- =====================================================

-- 1) Tablo oluşturma + Primary Key
CREATE TABLE uyeler (
    uye_id SERIAL PRIMARY KEY,      -- birincil anahtar: her üyeyi benzersiz tanımlar
    ad_soyad VARCHAR(100) NOT NULL,
    eposta VARCHAR(100) UNIQUE      -- aday anahtar: tekrar edemez ama PK değil
);

-- 2) 1-N ilişki: bir üye birden çok kitap ödünç alabilir
CREATE TABLE odunc_kayitlari (
    odunc_id SERIAL PRIMARY KEY,
    uye_id INTEGER NOT NULL,
    kitap_adi VARCHAR(150) NOT NULL,
    alis_tarihi DATE NOT NULL,
    iade_tarihi DATE,
    FOREIGN KEY (uye_id) REFERENCES uyeler(uye_id)   -- yabancı anahtar: ilişkiyi kurar
);

-- 3) Veri ekleme
INSERT INTO uyeler (ad_soyad, eposta) VALUES
('Elif Kaya', 'elif@ornek.com'),
('Barış Demir', 'baris@ornek.com');

INSERT INTO odunc_kayitlari (uye_id, kitap_adi, alis_tarihi, iade_tarihi) VALUES
(1, 'Suç ve Ceza', '2024-01-05', '2024-01-20'),
(1, 'Simyacı', '2024-02-01', NULL),
(2, 'Küçük Prens', '2024-01-10', '2024-01-25');

-- 4) Normalizasyon neden önemli? "Elif Kaya" adı her satırda tekrar etmiyor,
--    sadece uye_id ile bağlanıyor. Adı değiştirmek istersek tek satır güncelleriz:
UPDATE uyeler SET ad_soyad = 'Elif Kaya Yıldız' WHERE uye_id = 1;

-- 5) JOIN ile ilişkiyi kullanarak veriyi geri okuma
SELECT u.ad_soyad, o.kitap_adi, o.alis_tarihi, o.iade_tarihi
FROM odunc_kayitlari o
JOIN uyeler u ON o.uye_id = u.uye_id
ORDER BY u.ad_soyad;

-- 6) Henüz iade edilmemiş kitaplar (iade_tarihi NULL olanlar)
SELECT u.ad_soyad, o.kitap_adi
FROM odunc_kayitlari o
JOIN uyeler u ON o.uye_id = u.uye_id
WHERE o.iade_tarihi IS NULL;

-- 7) İndeks örneği: uye_id üzerinden sık arama yapılacaksa
CREATE INDEX idx_odunc_uye ON odunc_kayitlari(uye_id);

-- ALIŞTIRMA (kendin dene):
-- a) "kitaplar" adında ayrı bir tablo aç (kitap_id, ad, yazar) ve odunc_kayitlari
--    tablosunu kitap_adi yerine kitap_id ile ilişkilendir (normalizasyonu bir adım ileri götür).
-- b) Bir üyenin toplam kaç kitap ödünç aldığını COUNT() ve GROUP BY ile bul.
