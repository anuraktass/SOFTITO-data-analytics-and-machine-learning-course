-- =====================================================
-- ÖRNEK ÇALIŞMA: PostgreSQL
-- Konu: Tablo/Kısıtlar, JOIN, GROUP BY, VIEW, UPSERT, INDEX
-- Senaryo: Basit bir "Kargo Siparişleri" veritabanı
-- =====================================================

-- 1) İlişkili tablo oluşturma + kısıtlamalar
CREATE TABLE musteriler (
    musteri_id SERIAL PRIMARY KEY,
    ad VARCHAR(100) NOT NULL,
    eposta VARCHAR(100) UNIQUE NOT NULL,
    sehir VARCHAR(50) DEFAULT 'Bilinmiyor'
);

CREATE TABLE siparisler (
    siparis_id SERIAL PRIMARY KEY,
    musteri_id INTEGER NOT NULL REFERENCES musteriler(musteri_id),
    tutar NUMERIC(10, 2) CHECK (tutar > 0),
    durum VARCHAR(20) DEFAULT 'Beklemede'
);

-- 2) Veri ekleme
INSERT INTO musteriler (ad, eposta, sehir) VALUES
('Elif Kaya', 'elif@ornek.com', 'İstanbul'),
('Barış Demir', 'baris@ornek.com', 'Ankara');

INSERT INTO siparisler (musteri_id, tutar, durum) VALUES
(1, 850.00, 'Tamamlandı'),
(1, 250.00, 'Tamamlandı'),
(2, 4200.00, 'Beklemede');

-- 3) UPSERT örneği: e-posta zaten varsa şehri güncelle, yoksa yeni müşteri ekle
INSERT INTO musteriler (ad, eposta, sehir)
VALUES ('Elif Kaya', 'elif@ornek.com', 'İzmir')
ON CONFLICT (eposta) DO UPDATE SET sehir = EXCLUDED.sehir;

-- 4) JOIN + GROUP BY: her müşterinin toplam sipariş tutarı
SELECT m.ad, COUNT(s.siparis_id) AS siparis_sayisi, SUM(s.tutar) AS toplam_tutar
FROM musteriler m
LEFT JOIN siparisler s ON m.musteri_id = s.musteri_id
GROUP BY m.ad
ORDER BY toplam_tutar DESC NULLS LAST;

-- 5) VIEW oluşturma: sık kullanılan sorguyu kalıcı bir "sanal tablo" yapmak
CREATE VIEW musteri_ozet AS
SELECT m.ad, m.sehir, COUNT(s.siparis_id) AS siparis_sayisi
FROM musteriler m
LEFT JOIN siparisler s ON m.musteri_id = s.musteri_id
GROUP BY m.ad, m.sehir;

SELECT * FROM musteri_ozet;

-- 6) İndeks: musteri_id üzerinden sık JOIN yapılacaksa
CREATE INDEX idx_siparisler_musteri ON siparisler(musteri_id);

-- 7) EXPLAIN ile sorgu planını inceleme
EXPLAIN SELECT * FROM siparisler WHERE musteri_id = 1;

-- ALIŞTIRMA (kendin dene):
-- a) "Beklemede" durumundaki siparişleri "Tamamlandı" yapan bir UPDATE yaz.
-- b) Sipariş eklendiğinde musteriler tablosundaki "son_siparis_tarihi" alanını
--    otomatik güncelleyen basit bir TRIGGER kur.
