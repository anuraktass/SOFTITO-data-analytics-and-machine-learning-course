
CREATE TABLE kategoriler (
    kategori_id SERIAL PRIMARY KEY,
    kategori_adi VARCHAR(100) NOT NULL,
    aciklama TEXT,
    aktif BOOLEAN DEFAULT TRUE
);

INSERT INTO kategoriler (kategori_id, kategori_adi, aciklama, aktif) VALUES
(1, 'Elektronik', 'Telefon, Laptop, Tablet, Aksesuar', TRUE),
(2, 'Moda', 'Kıyafet, Ayakkabı, Çanta, Aksesuar', TRUE),
(3, 'Ev ve Bahçe', 'Mobilya, Dekorasyon, Mutfak', TRUE),
(4, 'Spor ve Outdoor', 'Spor Malzemeleri, Fitness, Bisiklet', TRUE),
(5, 'Kitap ve Medya', 'Kitap, E-book, DVD, Müzik', TRUE),
(6, 'Oyuncak', 'Çocuk Oyuncakları, Board Games', TRUE),
(7, 'Kozmetik', 'Cilt Bakımı, Makyaj, Saç Bakımı', TRUE),
(8, 'Otomotiv', 'Araba Aksesuarı, Oto Parçaları', TRUE),
(9, 'Gıda ve İçecek', 'Organik Ürünler, Kahve, Çay', TRUE),
(10, 'Sağlık', 'Vitamin, Supplement, Tıbbi Cihazlar', TRUE);

-- =====================================================
-- 2. SATICILAR TABLOSU

CREATE TABLE saticilar (
    satici_id SERIAL PRIMARY KEY,
    satici_adi VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    telefon VARCHAR(20),
    sehir VARCHAR(50),
    katilim_tarihi DATE NOT NULL,
    durum VARCHAR(20) CHECK(durum IN ('Aktif', 'Pasif', 'Beklemede')),
    toplam_satis INTEGER DEFAULT 0,
    ortalama_puan DECIMAL(3,1) DEFAULT 0
);

INSERT INTO saticilar (satici_id, satici_adi, email, telefon, sehir, katilim_tarihi, durum, toplam_satis, ortalama_puan) VALUES
(1, 'Teknoloji Plus', 'tekno@shophub.com', '0212-1234567', 'Istanbul', '2020-01-15', 'Aktif', 15420, 4.8),
(2, 'Fashion World', 'fashion@shophub.com', '0212-2345678', 'Istanbul', '2020-03-20', 'Aktif', 8950, 4.5),
(3, 'Home Comfort', 'home@shophub.com', '0312-3456789', 'Ankara', '2020-06-10', 'Aktif', 6780, 4.6),
(4, 'Sports Zone', 'sports@shophub.com', '0232-4567890', 'Izmir', '2021-01-05', 'Aktif', 4320, 4.3),
(5, 'Book World', 'books@shophub.com', '0312-5678901', 'Ankara', '2021-02-14', 'Aktif', 3240, 4.7),
(6, 'Toy Paradise', 'toys@shophub.com', '0216-6789012', 'Istanbul', '2021-04-22', 'Aktif', 2890, 4.4),
(7, 'Beauty Experts', 'beauty@shophub.com', '0242-7890123', 'Antalya', '2021-05-30', 'Aktif', 5670, 4.9),
(8, 'Auto Parts Plus', 'auto@shophub.com', '0262-8901234', 'Bursa', '2021-07-12', 'Aktif', 3450, 4.2),
(9, 'Gourmet Foods', 'food@shophub.com', '0342-9012345', 'Gaziantep', '2021-08-18', 'Aktif', 2100, 4.6),
(10, 'Health Plus', 'health@shophub.com', '0216-0123456', 'Istanbul', '2021-09-25', 'Aktif', 4560, 4.5),
(11, 'Premium Electronics', 'premium@shophub.com', '0212-1111111', 'Istanbul', '2020-02-01', 'Aktif', 22340, 4.9),
(12, 'Mega Store', 'mega@shophub.com', '0312-2222222', 'Ankara', '2022-01-10', 'Beklemede', 0, 0.0);

-- =====================================================
-- 3. MUSTERILER TABLOSU

CREATE TABLE musteriler (
    musteri_id SERIAL PRIMARY KEY,
    ad_soyad VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefon VARCHAR(20),
    sehir VARCHAR(50),
    adres TEXT,
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uyelik_tipi VARCHAR(30) CHECK(uyelik_tipi IN ('Standart', 'Gold', 'Premium', 'Platinum')),
    toplam_harcama DECIMAL(15,2) DEFAULT 0,
    siparis_sayisi INTEGER DEFAULT 0
);

INSERT INTO musteriler (musteri_id, ad_soyad, email, telefon, sehir, adres, kayit_tarihi, uyelik_tipi, toplam_harcama, siparis_sayisi) VALUES
(1, 'Ayşe Yilmaz', 'ayse.yilmaz@mail.com', '0535-1111111', 'Istanbul', 'Kadikoy, ABC Sokak 5', '2023-01-15 10:30:00', 'Gold', 45320.50, 12),
(2, 'Mehmet Kaya', 'mehmet.kaya@mail.com', '0535-2222222', 'Ankara', 'Cankiri, XYZ Caddesi 10', '2023-02-20 14:45:00', 'Premium', 78900.75, 18),
(3, 'Zeynep Demir', 'zeynep.demir@mail.com', '0535-3333333', 'Izmir', 'Alsancak, 123 Sokak', '2023-03-10 09:15:00', 'Standart', 12450.00, 5),
(4, 'Ali Ozturk', 'ali.ozturk@mail.com', '0535-4444444', 'Bursa', 'Nilüfer, 456 Cadde', '2023-04-05 11:20:00', 'Gold', 56780.25, 14),
(5, 'Fatma Sahin', 'fatma.sahin@mail.com', '0535-5555555', 'Gaziantep', 'Sehitkamil, 789 Sokak', '2023-05-12 15:40:00', 'Platinum', 125670.90, 28),
(6, 'Ibrahim Yilmaz', 'ibrahim.yilmaz@mail.com', '0535-6666666', 'Antalya', 'Muratpasa, 111 Cadde', '2023-06-18 08:50:00', 'Standart', 8900.00, 3),
(7, 'Gulsum Kaya', 'gulsum.kaya@mail.com', '0535-7777777', 'Mersin', 'Toroslar, 222 Sokak', '2023-07-25 13:25:00', 'Gold', 34560.00, 9),
(8, 'Hakan Cetin', 'hakan.cetin@mail.com', '0535-8888888', 'Istanbul', 'Besiktash, 333 Cadde', '2023-08-30 16:10:00', 'Premium', 92340.50, 22),
(9, 'Selin Ozdemir', 'selin.ozdemir@mail.com', '0535-9999999', 'Ankara', 'Kecioren, 444 Sokak', '2023-09-14 10:35:00', 'Standart', 5670.00, 2),
(10, 'Deniz Aksoy', 'deniz.aksoy@mail.com', '0535-1010101', 'Izmir', 'Bornova, 555 Cadde', '2023-10-22 14:55:00', 'Gold', 67890.00, 16),
(11, 'Cansu Yildirim', 'cansu.yildirim@mail.com', '0535-1111112', 'Istanbul', 'Ümraniye, 666 Sokak', '2023-11-05 12:15:00', 'Platinum', 145600.75, 35),
(12, 'Ercan Topcu', 'ercan.topcu@mail.com', '0535-1212121', 'Ankara', 'Çankaya, 777 Cadde', '2023-12-11 09:40:00', 'Premium', 89340.25, 21),
(13, 'Nilüfer Aydın', 'nilfer.aydin@mail.com', '0535-1313131', 'Istanbul', 'Maltepe, 888 Sokak', '2024-01-08 15:20:00', 'Standart', 15600.00, 6),
(14, 'Murat Baran', 'murat.baran@mail.com', '0535-1414141', 'Bursa', 'Osmangazi, 999 Cadde', '2024-01-18 11:30:00', 'Gold', 52340.50, 13),
(15, 'Pinar Demirel', 'pinar.demirel@mail.com', '0535-1515151', 'Gaziantep', 'Sahinbey, 101 Sokak', '2024-02-02 14:45:00', 'Premium', 98760.00, 25),
(16, 'Sinan Gokce', 'sinan.gokce@mail.com', '0535-1616161', 'Antalya', 'Kepez, 202 Cadde', '2024-02-14 10:15:00', 'Standart', 9870.00, 4),
(17, 'Leyla Kara', 'leyla.kara@mail.com', '0535-1717171', 'Mersin', 'Yenisehir, 303 Sokak', '2024-03-01 13:50:00', 'Gold', 45670.00, 11),
(18, 'Kadir Polat', 'kadir.polat@mail.com', '0535-1818181', 'Istanbul', 'Sariyer, 404 Cadde', '2024-03-15 16:30:00', 'Platinum', 156780.90, 40),
(19, 'Esra Koc', 'esra.koc@mail.com', '0535-1919191', 'Ankara', 'Mamak, 505 Sokak', '2024-04-05 09:20:00', 'Standart', 7890.00, 3),
(20, 'Volkan Sener', 'volkan.sener@mail.com', '0535-2020202', 'Izmir', 'Konak, 606 Cadde', '2024-04-20 14:10:00', 'Gold', 38900.25, 10);

-- =====================================================
-- 4. URUNLER TABLOSU

CREATE TABLE urunler (
    urun_id SERIAL PRIMARY KEY,
    urun_adi VARCHAR(150) NOT NULL,
    kategori_id INTEGER REFERENCES kategoriler(kategori_id) NOT NULL,
    satici_id INTEGER REFERENCES saticilar(satici_id) NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL,
    indirimli_fiyat DECIMAL(10,2),
    stok_sayisi INTEGER NOT NULL,
    aciklama TEXT,
    ortalama_puan DECIMAL(3,1) DEFAULT 0,
    yorum_sayisi INTEGER DEFAULT 0,
    satilan_adet INTEGER DEFAULT 0
);

INSERT INTO urunler (urun_id, urun_adi, kategori_id, satici_id, fiyat, indirimli_fiyat, stok_sayisi, aciklama, ortalama_puan, yorum_sayisi, satilan_adet) VALUES
(1, 'iPhone 15 Pro Max', 1, 11, 45000.00, 42000.00, 50, 'Son model Apple telefon, 256GB', 4.8, 245, 380),
(2, 'Samsung Galaxy S24 Ultra', 1, 11, 42000.00, 39500.00, 45, 'En yeni Samsung flagship', 4.7, 189, 320),
(3, 'MacBook Pro 14 inch M3', 1, 1, 85000.00, 80000.00, 15, 'Profesyonel laptop', 4.9, 156, 87),
(4, 'iPad Air 6', 1, 1, 25000.00, 23500.00, 30, 'Tablet ekran S1P', 4.6, 98, 145),
(5, 'Sony WH-1000XM5 Headphones', 1, 1, 4500.00, 4200.00, 80, 'Profesyonel kulaklık', 4.8, 567, 890),
(6, 'Nike Air Max 270', 2, 2, 2500.00, 2100.00, 120, 'Spor ayakkabı', 4.5, 456, 780),
(7, 'Adidas Ultraboost 23', 2, 2, 2800.00, 2400.00, 100, 'Yüksek performans ayakkabı', 4.6, 398, 620),
(8, 'Levis 501 Jeans', 2, 2, 1200.00, 950.00, 200, 'Klasik denim pantolon', 4.4, 234, 450),
(9, 'Zara Crop Top', 2, 2, 500.00, 350.00, 300, 'Günlük giyim', 4.2, 123, 890),
(10, 'Gucci Sunglasses', 2, 2, 3500.00, 3200.00, 25, 'Tasarımcı güneş gözlüğü', 4.9, 189, 98),
(11, 'IKEA Malm Yatak Odası Seti', 3, 3, 8900.00, 8000.00, 20, 'Tam yatak odası mobilyası', 4.5, 178, 45),
(12, 'Herman Miller Aeron Sandalye', 3, 3, 12000.00, 11000.00, 10, 'Ergonomik ofis sandalyesi', 4.8, 267, 38),
(13, 'LG 65 inch OLED TV', 3, 3, 25000.00, 23000.00, 8, 'Ultra HD akıllı televizyon', 4.7, 345, 52),
(14, 'Dyson V15 Detect Vacuum', 3, 3, 35000.00, 32000.00, 12, 'Kablosuz elektrikli süpürge', 4.9, 289, 67),
(15, 'Canon EOS R6 Kamera', 1, 1, 95000.00, 88000.00, 5, 'Profesyonel DSLR kamera', 4.9, 234, 28),
(16, 'Fitbit Sense 2 Smartwatch', 4, 4, 2200.00, 1900.00, 60, 'Akıllı saat', 4.5, 156, 245),
(17, 'Yonex Badminton Racket', 4, 4, 4500.00, 4000.00, 40, 'Profesyonel badminton raketi', 4.7, 89, 134),
(18, 'Decathlon Yoga Mat', 4, 4, 350.00, 280.00, 200, 'Yoga paspası', 4.4, 267, 890),
(19, 'Stationary Bike Trainer', 4, 4, 8000.00, 7200.00, 18, 'Ev fitness cihazı', 4.6, 145, 98),
(20, 'The Hobbit - Turkish Edition', 5, 5, 150.00, 120.00, 500, 'Fantezi klasiği', 4.8, 456, 1200),
(21, 'Atomic Habits (Kitap)', 5, 5, 180.00, 150.00, 400, 'Self-help bestseller', 4.9, 678, 1450),
(22, 'Inception (DVD)', 5, 5, 89.99, 69.99, 100, '4K Ultra HD', 4.7, 234, 567),
(23, 'LEGO Harry Potter Set', 6, 6, 2500.00, 2200.00, 30, '1000+ parça LEGO seti', 4.8, 345, 289),
(24, 'Hot Wheels Track Set', 6, 6, 800.00, 650.00, 80, 'Çocuk oyuncak aracı seti', 4.3, 156, 450),
(25, 'Barbie Dream House', 6, 6, 1500.00, 1200.00, 25, 'Büyük Barbie evi', 4.5, 267, 178),
(26, 'La Roche Posay Sunscreen', 7, 7, 450.00, 380.00, 150, 'Yüz güneş kremi SPF 50', 4.9, 789, 2340),
(27, 'MAC Lipstick Matte', 7, 7, 280.00, 240.00, 200, 'Profesyonel dudak rouzu', 4.7, 456, 1890),
(28, 'Dyson Supersonic Hair Dryer', 7, 7, 12000.00, 10800.00, 15, 'Profesyonel saç kurutma makinesi', 4.8, 567, 234),
(29, 'Bosch Car Wax', 8, 8, 350.00, 300.00, 120, 'Araba mumlaması', 4.5, 123, 456),
(30, 'Michelin Pilot Sport 4S Tires', 8, 8, 2800.00, 2500.00, 40, 'Yüksek performans lastik', 4.7, 234, 178);

-- =====================================================
-- 5. SIPARISLER TABLOSU

CREATE TABLE siparisler (
    siparis_id SERIAL PRIMARY KEY,
    musteri_id INTEGER REFERENCES musteriler(musteri_id) NOT NULL,
    siparis_tarihi TIMESTAMP NOT NULL,
    toplam_tutar DECIMAL(15,2) NOT NULL,
    indirim_tutari DECIMAL(10,2) DEFAULT 0,
    son_tutar DECIMAL(15,2) NOT NULL,
    durum VARCHAR(30) CHECK(durum IN ('Onay Bekliyor', 'Hazırlanıyor', 'Yolda', 'Teslim Edildi', 'İptal'))
);

INSERT INTO siparisler (siparis_id, musteri_id, siparis_tarihi, toplam_tutar, indirim_tutari, son_tutar, durum) VALUES
(1, 1, '2024-01-15 10:30:00', 45000.00, 3000.00, 42000.00, 'Teslim Edildi'),
(2, 2, '2024-01-16 14:45:00', 40000.00, 2500.00, 37500.00, 'Teslim Edildi'),
(3, 1, '2024-01-17 09:15:00', 2500.00, 400.00, 2100.00, 'Teslim Edildi'),
(4, 3, '2024-01-18 11:20:00', 8900.00, 900.00, 8000.00, 'Teslim Edildi'),
(5, 4, '2024-01-19 15:40:00', 25000.00, 2000.00, 23000.00, 'Teslim Edildi'),
(6, 5, '2024-01-20 08:50:00', 12000.00, 1200.00, 10800.00, 'Teslim Edildi'),
(7, 2, '2024-01-21 13:25:00', 4500.00, 300.00, 4200.00, 'Teslim Edildi'),
(8, 6, '2024-01-22 16:10:00', 350.00, 70.00, 280.00, 'Teslim Edildi'),
(9, 7, '2024-01-23 10:35:00', 2800.00, 400.00, 2400.00, 'Yolda'),
(10, 8, '2024-01-24 14:55:00', 35000.00, 3000.00, 32000.00, 'Teslim Edildi'),
(11, 9, '2024-01-25 12:15:00', 500.00, 150.00, 350.00, 'Teslim Edildi'),
(12, 10, '2024-01-26 09:40:00', 4500.00, 500.00, 4000.00, 'Yolda'),
(13, 11, '2024-01-27 15:20:00', 150.00, 30.00, 120.00, 'Hazırlanıyor'),
(14, 12, '2024-01-28 11:30:00', 180.00, 30.00, 150.00, 'Hazırlanıyor'),
(15, 13, '2024-01-29 14:45:00', 89.99, 20.00, 69.99, 'Teslim Edildi'),
(16, 14, '2024-01-30 10:15:00', 2500.00, 300.00, 2200.00, 'Teslim Edildi'),
(17, 15, '2024-02-01 13:50:00', 4500.00, 500.00, 4000.00, 'Yolda'),
(18, 16, '2024-02-02 16:30:00', 350.00, 70.00, 280.00, 'Hazırlanıyor'),
(19, 17, '2024-02-03 09:20:00', 8000.00, 800.00, 7200.00, 'Yolda'),
(20, 18, '2024-02-04 14:10:00', 2200.00, 300.00, 1900.00, 'Teslim Edildi'),
(21, 1, '2024-02-05 10:45:00', 3500.00, 300.00, 3200.00, 'Teslim Edildi'),
(22, 2, '2024-02-06 15:20:00', 12000.00, 1000.00, 11000.00, 'Hazırlanıyor'),
(23, 3, '2024-02-07 11:10:00', 25000.00, 2000.00, 23000.00, 'Yolda'),
(24, 4, '2024-02-08 14:35:00', 4500.00, 500.00, 4000.00, 'Teslim Edildi'),
(25, 5, '2024-02-09 09:50:00', 1200.00, 250.00, 950.00, 'Teslim Edildi'),
(26, 6, '2024-02-10 13:25:00', 2500.00, 400.00, 2100.00, 'Hazırlanıyor'),
(27, 7, '2024-02-11 16:40:00', 35000.00, 3000.00, 32000.00, 'Teslim Edildi'),
(28, 8, '2024-02-12 10:15:00', 2200.00, 300.00, 1900.00, 'Yolda'),
(29, 9, '2024-02-13 14:50:00', 4500.00, 500.00, 4000.00, 'Teslim Edildi'),
(30, 10, '2024-02-14 12:30:00', 500.00, 150.00, 350.00, 'Hazırlanıyor'),
(31, 11, '2024-02-15 15:45:00', 8900.00, 900.00, 8000.00, 'Yolda'),
(32, 12, '2024-02-16 09:20:00', 3500.00, 300.00, 3200.00, 'Teslim Edildi'),
(33, 13, '2024-02-17 13:55:00', 12000.00, 1000.00, 11000.00, 'Teslim Edildi'),
(34, 14, '2024-02-18 11:15:00', 2500.00, 300.00, 2200.00, 'Hazırlanıyor'),
(35, 15, '2024-02-19 14:40:00', 4500.00, 500.00, 4000.00, 'Yolda'),
(36, 16, '2024-02-20 10:25:00', 25000.00, 2000.00, 23000.00, 'Teslim Edildi'),
(37, 17, '2024-02-21 15:50:00', 2200.00, 300.00, 1900.00, 'Teslim Edildi'),
(38, 18, '2024-02-22 12:10:00', 8000.00, 800.00, 7200.00, 'Hazırlanıyor'),
(39, 19, '2024-02-23 16:35:00', 350.00, 70.00, 280.00, 'Yolda'),
(40, 20, '2024-02-24 09:45:00', 4500.00, 500.00, 4000.00, 'Teslim Edildi'),
(41, 1, '2024-02-25 14:20:00', 3500.00, 300.00, 3200.00, 'Teslim Edildi'),
(42, 2, '2024-02-26 10:55:00', 12000.00, 1000.00, 11000.00, 'Yolda'),
(43, 3, '2024-02-27 15:30:00', 2500.00, 300.00, 2200.00, 'Hazırlanıyor'),
(44, 4, '2024-02-28 11:05:00', 8900.00, 900.00, 8000.00, 'Teslim Edildi'),
(45, 5, '2024-03-01 14:25:00', 4500.00, 500.00, 4000.00, 'Yolda'),
(46, 6, '2024-03-02 09:40:00', 25000.00, 2000.00, 23000.00, 'Teslim Edildi'),
(47, 7, '2024-03-03 13:15:00', 3500.00, 300.00, 3200.00, 'Teslim Edildi'),
(48, 8, '2024-03-04 16:50:00', 2200.00, 300.00, 1900.00, 'Hazırlanıyor'),
(49, 9, '2024-03-05 10:20:00', 12000.00, 1000.00, 11000.00, 'Yolda'),
(50, 10, '2024-03-06 14:45:00', 4500.00, 500.00, 4000.00, 'Teslim Edildi');

-- =====================================================
-- 6. SIPARIS_DETAYLARI TABLOSU (Tekrar)

CREATE TABLE siparis_detaylari (
    detay_id SERIAL PRIMARY KEY,
    siparis_id INTEGER REFERENCES siparisler(siparis_id) NOT NULL,
    urun_id INTEGER REFERENCES urunler(urun_id) NOT NULL,
    miktar INTEGER NOT NULL,
    birim_fiyati DECIMAL(10,2) NOT NULL,
    alt_toplam DECIMAL(15,2) NOT NULL
);


INSERT INTO siparis_detaylari (detay_id, siparis_id, urun_id, miktar, birim_fiyati, alt_toplam) VALUES
(1, 1, 1, 1, 45000.00, 45000.00),
(2, 2, 2, 1, 40000.00, 40000.00),
(3, 3, 6, 1, 2500.00, 2500.00),
(4, 4, 11, 1, 8900.00, 8900.00),
(5, 5, 14, 2, 12500.00, 25000.00),
(6, 6, 28, 1, 12000.00, 12000.00),
(7, 7, 5, 1, 4500.00, 4500.00),
(8, 8, 18, 1, 350.00, 350.00),
(9, 9, 2, 1, 2800.00, 2800.00),
(10, 10, 14, 2, 17500.00, 35000.00),
(11, 11, 9, 1, 500.00, 500.00),
(12, 12, 5, 1, 4500.00, 4500.00),
(13, 13, 20, 1, 150.00, 150.00),
(14, 14, 21, 1, 180.00, 180.00),
(15, 15, 22, 1, 89.99, 89.99),
(16, 16, 23, 1, 2500.00, 2500.00),
(17, 17, 5, 1, 4500.00, 4500.00),
(18, 18, 18, 1, 350.00, 350.00),
(19, 19, 19, 1, 8000.00, 8000.00),
(20, 20, 16, 1, 2200.00, 2200.00),
(21, 21, 10, 1, 3500.00, 3500.00),
(22, 22, 12, 1, 12000.00, 12000.00),
(23, 23, 14, 2, 12500.00, 25000.00),
(24, 24, 5, 1, 4500.00, 4500.00),
(25, 25, 7, 1, 1200.00, 1200.00),
(26, 26, 6, 1, 2500.00, 2500.00),
(27, 27, 14, 2, 17500.00, 35000.00),
(28, 28, 16, 1, 2200.00, 2200.00),
(29, 29, 5, 1, 4500.00, 4500.00),
(30, 30, 9, 1, 500.00, 500.00),
(31, 31, 11, 1, 8900.00, 8900.00),
(32, 32, 10, 1, 3500.00, 3500.00),
(33, 33, 12, 1, 12000.00, 12000.00),
(34, 34, 6, 1, 2500.00, 2500.00),
(35, 35, 5, 1, 4500.00, 4500.00),
(36, 36, 14, 2, 12500.00, 25000.00),
(37, 37, 16, 1, 2200.00, 2200.00),
(38, 38, 19, 1, 8000.00, 8000.00),
(39, 39, 18, 1, 350.00, 350.00),
(40, 40, 5, 1, 4500.00, 4500.00),
(41, 41, 10, 1, 3500.00, 3500.00),
(42, 42, 12, 1, 12000.00, 12000.00),
(43, 43, 6, 1, 2500.00, 2500.00),
(44, 44, 11, 1, 8900.00, 8900.00),
(45, 45, 5, 1, 4500.00, 4500.00),
(46, 46, 14, 2, 12500.00, 25000.00),
(47, 47, 10, 1, 3500.00, 3500.00),
(48, 48, 16, 1, 2200.00, 2200.00),
(49, 49, 12, 1, 12000.00, 12000.00),
(50, 50, 5, 1, 4500.00, 4500.00),
(51, 1, 3, 1, 42000.00, 42000.00),
(52, 2, 4, 1, 25000.00, 25000.00),
(53, 3, 7, 2, 1400.00, 2800.00),
(54, 4, 13, 1, 8900.00, 8900.00),
(55, 5, 15, 3, 8000.00, 24000.00),
(56, 6, 27, 1, 280.00, 280.00),
(57, 7, 8, 1, 1200.00, 1200.00),
(58, 8, 24, 2, 800.00, 1600.00),
(59, 9, 30, 1, 2800.00, 2800.00),
(60, 10, 13, 1, 25000.00, 25000.00),
(61, 11, 25, 1, 1500.00, 1500.00),
(62, 12, 5, 1, 4500.00, 4500.00),
(63, 13, 20, 2, 150.00, 300.00),
(64, 14, 21, 1, 180.00, 180.00),
(65, 15, 22, 1, 89.99, 89.99),
(66, 16, 23, 1, 2500.00, 2500.00),
(67, 17, 5, 1, 4500.00, 4500.00),
(68, 18, 18, 1, 350.00, 350.00),
(69, 19, 19, 1, 8000.00, 8000.00),
(70, 20, 16, 1, 2200.00, 2200.00);

-- =====================================================
-- 7. ODEMELER TABLOSU

CREATE TABLE odemeler (
    odeme_id SERIAL PRIMARY KEY,
    siparis_id INTEGER REFERENCES siparisler(siparis_id) NOT NULL,
    odeme_tipi VARCHAR(30) CHECK(odeme_tipi IN ('Kredi Karti', 'Debit Karti', 'Banka Transferi', 'E-Cuzdan', 'Kapida Odeme')),
    tutar DECIMAL(15,2) NOT NULL,
    odeme_tarihi TIMESTAMP NOT NULL,
    durum VARCHAR(20) CHECK(durum IN ('Basarili', 'Basarisiz', 'Bekleniyor'))
);

INSERT INTO odemeler (odeme_id, siparis_id, odeme_tipi, tutar, odeme_tarihi, durum) VALUES
(1, 1, 'Kredi Karti', 42000.00, '2024-01-15 10:45:00', 'Basarili'),
(2, 2, 'Banka Transferi', 37500.00, '2024-01-16 15:00:00', 'Basarili'),
(3, 3, 'E-Cuzdan', 2100.00, '2024-01-17 09:30:00', 'Basarili'),
(4, 4, 'Kredi Karti', 8000.00, '2024-01-18 11:45:00', 'Basarili'),
(5, 5, 'Debit Karti', 23000.00, '2024-01-19 16:00:00', 'Basarili'),
(6, 6, 'Kredi Karti', 10800.00, '2024-01-20 09:15:00', 'Basarili'),
(7, 7, 'E-Cuzdan', 4200.00, '2024-01-21 13:40:00', 'Basarili'),
(8, 8, 'Kapida Odeme', 280.00, '2024-01-22 16:30:00', 'Bekleniyor'),
(9, 9, 'Kredi Karti', 2400.00, '2024-01-23 10:50:00', 'Basarili'),
(10, 10, 'Banka Transferi', 32000.00, '2024-01-24 15:10:00', 'Basarili'),
(11, 11, 'E-Cuzdan', 350.00, '2024-01-25 12:25:00', 'Basarili'),
(12, 12, 'Kredi Karti', 4000.00, '2024-01-26 09:55:00', 'Basarili'),
(13, 13, 'Debit Karti', 120.00, '2024-01-27 15:35:00', 'Basarili'),
(14, 14, 'Kredi Karti', 150.00, '2024-01-28 11:45:00', 'Basarili'),
(15, 15, 'E-Cuzdan', 69.99, '2024-01-29 14:20:00', 'Basarili'),
(16, 16, 'Kapida Odeme', 2200.00, '2024-01-30 10:30:00', 'Bekleniyor'),
(17, 17, 'Kredi Karti', 4000.00, '2024-02-01 14:05:00', 'Basarili'),
(18, 18, 'Banka Transferi', 280.00, '2024-02-02 16:50:00', 'Basarili'),
(19, 19, 'Kredi Karti', 7200.00, '2024-02-03 09:35:00', 'Basarili'),
(20, 20, 'E-Cuzdan', 1900.00, '2024-02-04 14:25:00', 'Basarili'),
(21, 21, 'Kredi Karti', 3200.00, '2024-02-05 11:00:00', 'Basarili'),
(22, 22, 'Debit Karti', 11000.00, '2024-02-06 15:40:00', 'Basarili'),
(23, 23, 'Kredi Karti', 23000.00, '2024-02-07 11:25:00', 'Basarili'),
(24, 24, 'E-Cuzdan', 4000.00, '2024-02-08 14:50:00', 'Basarili'),
(25, 25, 'Kapida Odeme', 950.00, '2024-02-09 10:05:00', 'Bekleniyor'),
(26, 26, 'Kredi Karti', 2100.00, '2024-02-10 13:40:00', 'Basarili'),
(27, 27, 'Banka Transferi', 32000.00, '2024-02-11 16:55:00', 'Basarili'),
(28, 28, 'Kredi Karti', 1900.00, '2024-02-12 10:30:00', 'Basarili'),
(29, 29, 'E-Cuzdan', 4000.00, '2024-02-13 15:10:00', 'Basarili'),
(30, 30, 'Debit Karti', 350.00, '2024-02-14 12:45:00', 'Basarili'),
(31, 31, 'Kredi Karti', 8000.00, '2024-02-15 16:20:00', 'Basarili'),
(32, 32, 'E-Cuzdan', 3200.00, '2024-02-16 09:35:00', 'Basarili'),
(33, 33, 'Kredi Karti', 11000.00, '2024-02-17 14:10:00', 'Basarili'),
(34, 34, 'Banka Transferi', 2200.00, '2024-02-18 11:30:00', 'Basarili'),
(35, 35, 'Kredi Karti', 4000.00, '2024-02-19 15:00:00', 'Basarili'),
(36, 36, 'E-Cuzdan', 23000.00, '2024-02-20 10:40:00', 'Basarili'),
(37, 37, 'Kapida Odeme', 1900.00, '2024-02-21 16:15:00', 'Bekleniyor'),
(38, 38, 'Kredi Karti', 7200.00, '2024-02-22 12:25:00', 'Basarili'),
(39, 39, 'Debit Karti', 280.00, '2024-02-23 16:50:00', 'Basarili'),
(40, 40, 'E-Cuzdan', 4000.00, '2024-02-24 10:00:00', 'Basarili'),
(41, 41, 'Kredi Karti', 3200.00, '2024-02-25 14:35:00', 'Basarili'),
(42, 42, 'Banka Transferi', 11000.00, '2024-02-26 11:10:00', 'Basarili'),
(43, 43, 'Kredi Karti', 2200.00, '2024-02-27 15:45:00', 'Basarili'),
(44, 44, 'E-Cuzdan', 8000.00, '2024-02-28 11:20:00', 'Basarili'),
(45, 45, 'Kredi Karti', 4000.00, '2024-03-01 14:40:00', 'Basarili'),
(46, 46, 'Debit Karti', 23000.00, '2024-03-02 10:05:00', 'Basarili'),
(47, 47, 'E-Cuzdan', 3200.00, '2024-03-03 13:30:00', 'Basarili'),
(48, 48, 'Kapida Odeme', 1900.00, '2024-03-04 17:10:00', 'Bekleniyor'),
(49, 49, 'Kredi Karti', 11000.00, '2024-03-05 10:35:00', 'Basarili'),
(50, 50, 'E-Cuzdan', 4000.00, '2024-03-06 15:20:00', 'Basarili');

-- =====================================================
-- 8. KARGO_SIRKETLERI TABLOSU

CREATE TABLE kargo_sirketleri (
    kargo_id SERIAL PRIMARY KEY,
    sirket_adi VARCHAR(100) NOT NULL UNIQUE,
    telefon VARCHAR(20),
    web_sitesi VARCHAR(100),
    ortalama_teslimat_gunu INTEGER
);

INSERT INTO kargo_sirketleri (kargo_id, sirket_adi, telefon, web_sitesi, ortalama_teslimat_gunu) VALUES
(1, 'Yurtici Kargo', '0212-1234567', 'www.yurticikargo.com', 3),
(2, 'Aras Kargo', '0212-2345678', 'www.araskargo.com', 2),
(3, 'PTT Kargo', '0312-3456789', 'www.pttkargo.com', 4),
(4, 'Ups Kargo', '0232-4567890', 'www.ups.com.tr', 2),
(5, 'DHL Express', '0216-5678901', 'www.dhl.com.tr', 1),
(6, 'Ticimax Lojistik', '0312-6789012', 'www.ticimax.com', 3),
(7, 'Surat Kargo', '0312-7890123', 'www.suratkargo.com', 3),
(8, 'Karsan Lojistik', '0216-8901234', 'www.karsanlojistik.com', 2);

-- =====================================================


CREATE TABLE kargo_tracking (
    tracking_id SERIAL PRIMARY KEY,
    siparis_id INTEGER REFERENCES siparisler(siparis_id) NOT NULL,
    kargo_id INTEGER REFERENCES kargo_sirketleri(kargo_id) NOT NULL,
    takip_numarasi VARCHAR(50) UNIQUE NOT NULL,
    kargo_tarihi DATE NOT NULL,
    teslimat_tarihi DATE,
    durum VARCHAR(30) CHECK(durum IN ('Depolarda', 'Yolda', 'Teslim Edildi', 'Gecikme', 'İade'))
);

INSERT INTO kargo_tracking (tracking_id, siparis_id, kargo_id, takip_numarasi, kargo_tarihi, teslimat_tarihi, durum) VALUES
(1, 1, 1, 'YURT123456789', '2024-01-15', '2024-01-18', 'Teslim Edildi'),
(2, 2, 2, 'ARAS987654321', '2024-01-16', '2024-01-18', 'Teslim Edildi'),
(3, 3, 1, 'YURT111222333', '2024-01-17', '2024-01-20', 'Teslim Edildi'),
(4, 4, 3, 'PTT444555666', '2024-01-18', '2024-01-22', 'Teslim Edildi'),
(5, 5, 4, 'UPS777888999', '2024-01-19', '2024-01-21', 'Teslim Edildi'),
(6, 6, 5, 'DHL101112131', '2024-01-20', '2024-01-21', 'Teslim Edildi'),
(7, 7, 1, 'YURT141516171', '2024-01-21', '2024-01-24', 'Teslim Edildi'),
(8, 8, 6, 'TICIMAX181920', '2024-01-22', NULL, 'Yolda'),
(9, 9, 2, 'ARAS212223242', '2024-01-23', NULL, 'Yolda'),
(10, 10, 3, 'PTT252627282', '2024-01-24', '2024-01-27', 'Teslim Edildi'),
(11, 11, 1, 'YURT293031323', '2024-01-25', '2024-01-28', 'Teslim Edildi'),
(12, 12, 4, 'UPS333435363', '2024-01-26', NULL, 'Yolda'),
(13, 13, 5, 'DHL373839404', '2024-01-27', NULL, 'Depolarda'),
(14, 14, 2, 'ARAS414243444', '2024-01-28', NULL, 'Depolarda'),
(15, 15, 1, 'YURT454647484', '2024-01-29', '2024-02-01', 'Teslim Edildi'),
(16, 16, 6, 'TICIMAX495051', '2024-01-30', NULL, 'Yolda'),
(17, 17, 3, 'PTT525354555', '2024-02-01', NULL, 'Yolda'),
(18, 18, 4, 'UPS565758596', '2024-02-02', '2024-02-04', 'Teslim Edildi'),
(19, 19, 5, 'DHL606162636', '2024-02-03', NULL, 'Yolda'),
(20, 20, 1, 'YURT646566676', '2024-02-04', '2024-02-07', 'Teslim Edildi'),
(21, 21, 2, 'ARAS686970717', '2024-02-05', '2024-02-07', 'Teslim Edildi'),
(22, 22, 3, 'PTT727374757', '2024-02-06', NULL, 'Yolda'),
(23, 23, 4, 'UPS767778798', '2024-02-07', NULL, 'Yolda'),
(24, 24, 5, 'DHL808182838', '2024-02-08', '2024-02-10', 'Teslim Edildi'),
(25, 25, 6, 'TICIMAX848586', '2024-02-09', NULL, 'Depolarda'),
(26, 26, 1, 'YURT878889909', '2024-02-10', '2024-02-12', 'Teslim Edildi'),
(27, 27, 2, 'ARAS919293949', '2024-02-11', NULL, 'Yolda'),
(28, 28, 3, 'PTT95969798', '2024-02-12', '2024-02-14', 'Teslim Edildi'),
(29, 29, 4, 'UPS991001011', '2024-02-13', NULL, 'Yolda'),
(30, 30, 5, 'DHL1021031041', '2024-02-14', NULL, 'Depolarda'),
(31, 31, 1, 'YURT1051061071', '2024-02-15', NULL, 'Yolda'),
(32, 32, 6, 'TICIMAX1081091', '2024-02-16', '2024-02-18', 'Teslim Edildi'),
(33, 33, 2, 'ARAS1101111121', '2024-02-17', NULL, 'Yolda'),
(34, 34, 3, 'PTT1131141151', '2024-02-18', '2024-02-20', 'Teslim Edildi'),
(35, 35, 4, 'UPS1161171181', '2024-02-19', NULL, 'Yolda'),
(36, 36, 5, 'DHL1191201211', '2024-02-20', '2024-02-22', 'Teslim Edildi'),
(37, 37, 1, 'YURT1221231241', '2024-02-21', NULL, 'Yolda'),
(38, 38, 6, 'TICIMAX1251261', '2024-02-22', NULL, 'Depolarda'),
(39, 39, 2, 'ARAS1271281291', '2024-02-23', '2024-02-25', 'Teslim Edildi'),
(40, 40, 3, 'PTT1301311321', '2024-02-24', NULL, 'Yolda'),
(41, 41, 4, 'UPS1331341351', '2024-02-25', '2024-02-27', 'Teslim Edildi'),
(42, 42, 5, 'DHL1361371381', '2024-02-26', NULL, 'Yolda'),
(43, 43, 1, 'YURT1391401411', '2024-02-27', NULL, 'Depolarda'),
(44, 44, 6, 'TICIMAX1421431', '2024-02-28', '2024-03-01', 'Teslim Edildi'),
(45, 45, 2, 'ARAS1441451461', '2024-03-01', NULL, 'Yolda'),
(46, 46, 3, 'PTT1471481491', '2024-03-02', '2024-03-04', 'Teslim Edildi'),
(47, 47, 4, 'UPS1501511521', '2024-03-03', NULL, 'Yolda'),
(48, 48, 5, 'DHL1531541551', '2024-03-04', NULL, 'Depolarda'),
(49, 49, 1, 'YURT1561571581', '2024-03-05', NULL, 'Yolda'),
(50, 50, 6, 'TICIMAX1591601', '2024-03-06', '2024-03-08', 'Teslim Edildi');

-- =====================================================
-- 10. YORUMLAR TABLOSU

CREATE TABLE yorumlar (
    yorum_id SERIAL PRIMARY KEY,
    urun_id INTEGER REFERENCES urunler(urun_id) NOT NULL,
    musteri_id INTEGER REFERENCES musteriler(musteri_id) NOT NULL,
    puan INTEGER CHECK(puan BETWEEN 1 AND 5),
    yorum_metni TEXT,
    yorum_tarihi TIMESTAMP NOT NULL,
    yardimci_sayisi INTEGER DEFAULT 0
);

INSERT INTO yorumlar (yorum_id, urun_id, musteri_id, puan, yorum_metni, yorum_tarihi, yardimci_sayisi) VALUES
(1, 1, 1, 5, 'Çok hızlı teslim, ürün kusursuz! Kesinlikle tavsiye ederim.', '2024-01-19 08:00:00', 145),
(2, 2, 2, 4, 'İyi ürün ama ambalaj hasarlı geldi. Yine de kulllanılıyor.', '2024-01-20 10:30:00', 32),
(3, 3, 1, 5, 'Tıkla tıkla ayakkabı geldi! Beden mükemmel.', '2024-01-18 14:00:00', 78),
(4, 11, 3, 4, 'Mobilya kaliteli ama teslimat biraz geç oldu.', '2024-02-05 11:20:00', 45),
(5, 14, 4, 5, 'Harikalar, ev şimdi çok güzel görünüyor!', '2024-02-15 09:45:00', 89),
(6, 6, 5, 5, 'En iyi ayakkabı, çok rahat. 10 gündür taşıyorum hata yok.', '2024-02-08 15:30:00', 112),
(7, 7, 2, 4, 'Kaliteli spor ayakkabı ama biraz dar geldi.', '2024-02-10 13:15:00', 23),
(8, 8, 3, 5, 'Çok rahat jeans. Beden kusursuz seçilmiş.', '2024-01-25 16:40:00', 156),
(9, 9, 4, 3, 'Ürün gayet ama fiyat biraz yüksek gibi geldi.', '2024-02-12 10:50:00', 12),
(10, 10, 5, 5, 'Harika güneş gözlüğü. Kalitesi gerçekten iyi.', '2024-02-18 14:25:00', 203),
(11, 12, 1, 5, 'Sandalye çok ergonomik. Sırt ağrılarım iyileşti!', '2024-02-22 08:30:00', 267),
(12, 13, 2, 4, 'TV çok iyi ama kurulum zor.', '2024-02-25 11:10:00', 89),
(13, 15, 3, 5, 'Kamera profesyonel. Tüm fotoğraflarım harika çıkıyor.', '2024-03-02 16:45:00', 178),
(14, 16, 4, 4, 'Smartwatch güzel ama bataryası kısa kalıyor.', '2024-02-28 12:30:00', 56),
(15, 17, 5, 5, 'Badminton raketi harikulade. İyi oynuyorum artık!', '2024-03-05 10:15:00', 134),
(16, 18, 1, 4, 'Yoga matı iyi ama çok kalın geldi.', '2024-03-08 14:20:00', 45),
(17, 19, 2, 5, 'Fitness makinası mükemmel. Evde spor yapıyorum!', '2024-03-10 09:30:00', 267),
(18, 20, 3, 5, 'Hobbit kitabı müthiş. Adını koymak istemiyorum.', '2024-03-12 13:45:00', 456),
(19, 21, 4, 5, 'Atomic Habits harika kitap. Hayatım değişti!', '2024-03-14 11:20:00', 678),
(20, 22, 5, 4, 'Film DVD güzel ama ses sorunu var.', '2024-03-16 15:50:00', 123),
(21, 23, 1, 5, 'LEGO seti harika. Bütün aile yaptı beraber.', '2024-03-18 10:30:00', 345),
(22, 24, 2, 4, 'Hot Wheels güzel ama bazı arabalar gelmedi.', '2024-03-20 14:15:00', 67),
(23, 25, 3, 5, 'Barbie Evi çok güzel. Kızım bayılıyor!', '2024-03-22 12:00:00', 289),
(24, 26, 4, 5, 'Güneş kremi harika. Cildi koruyor mükemmelen.', '2024-03-24 16:30:00', 789),
(25, 27, 5, 5, 'Dudak rouzu rengi çok güzel. Uzun kalıyor.', '2024-03-26 09:45:00', 456),
(26, 28, 1, 4, 'Saç kurutma makinesi güzel ama gürültülü.', '2024-03-28 13:20:00', 234),
(27, 29, 2, 5, 'Araba mumlaması mükemmel. Araç çok parlıyor!', '2024-03-30 11:30:00', 567),
(28, 30, 3, 5, 'Lastikler çok güzel. Araç kontrol daha iyi!', '2024-04-01 15:15:00', 345),
(29, 1, 4, 4, 'iPhone çok iyi ama bataryası hızlı bitti.', '2024-04-03 10:40:00', 178),
(30, 2, 5, 5, 'Samsung telefon harika. Kamera çok iyi!', '2024-04-05 14:25:00', 267),
(31, 3, 1, 5, 'Macbook harika. Çalışmak çok güzel.', '2024-04-07 12:50:00', 234),
(32, 4, 2, 4, 'iPad iyi ama ekranı kırılgan.', '2024-04-09 16:10:00', 89),
(33, 5, 3, 5, 'Kulaklık çok iyi. Ses kalitesi mühteşem!', '2024-04-11 09:35:00', 456),
(34, 6, 4, 5, 'Nike ayakkabı çok rahat. Her gün taşıyorum.', '2024-04-13 13:45:00', 567),
(35, 7, 5, 4, 'Adidas ayakkabı güzel ama terliyorum çok.', '2024-04-15 11:20:00', 123),
(36, 8, 1, 5, 'Levi''s jeans müthiş. 10 yıl taşırım.', '2024-04-17 15:30:00', 234),
(37, 9, 2, 4, 'Zara tişört güzel ama tereyağı kaliteli değil.', '2024-04-19 10:15:00', 67),
(38, 10, 3, 5, 'Gucci gözlük harika. Stil atıyorum!', '2024-04-21 14:40:00', 345),
(39, 11, 4, 5, 'IKEA mobilya harika. Ev hazır 5 saatde.', '2024-04-23 12:25:00', 456),
(40, 14, 5, 4, 'Dyson süpürge iyi ama müşteri hizmetleri kötü.', '2024-04-25 16:50:00', 89);

-- =====================================================
-- 11. PROMOSYONLAR TABLOSU

CREATE TABLE promosyonlar (
    promo_id SERIAL PRIMARY KEY,
    promo_kodu VARCHAR(30) UNIQUE NOT NULL,
    aciklama TEXT,
    indirim_orani DECIMAL(5,2) NOT NULL,
    baslama_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    kullanim_sayisi INTEGER DEFAULT 0,
    maksimum_kullani INTEGER
);

INSERT INTO promosyonlar (promo_id, promo_kodu, aciklama, indirim_orani, baslama_tarihi, bitis_tarihi, kullanim_sayisi, maksimum_kullani) VALUES
(1, 'WELCOME10', 'İlk alışverişte %10 indirim', 10.00, '2024-01-01', '2024-12-31', 4520, 5000),
(2, 'SPRING20', 'Bahar kampanyası %20 indirim', 20.00, '2024-03-21', '2024-04-20', 3240, 3000),
(3, 'GOLD15', 'Gold üyeler %15 indirim', 15.00, '2024-01-01', '2024-12-31', 2890, 10000),
(4, 'WEEKEND25', 'Hafta sonu %25 indirim', 25.00, '2024-01-06', '2024-12-31', 5670, 2000),
(5, 'TECH30', 'Teknoloji ürünlerinde %30 indirim', 30.00, '2024-02-01', '2024-02-28', 1234, 500),
(6, 'FASHION18', 'Moda ürünlerinde %18 indirim', 18.00, '2024-02-14', '2024-03-14', 2345, 1000),
(7, 'SUMMER15', 'Yaz dönemi %15 indirim', 15.00, '2024-06-21', '2024-09-22', 0, 2000),
(8, 'BLACKFRIDAY50', 'Kara Cuma %50 indirim', 50.00, '2024-11-29', '2024-12-01', 0, 1000),
(9, 'STUDENT12', 'Öğrenciler %12 indirim', 12.00, '2024-01-01', '2024-12-31', 1567, 5000),
(10, 'BIRTHDAY5', 'Doğum günü ayınızda %5 indirim', 5.00, '2024-01-01', '2024-12-31', 3456, 10000),
(11, 'LOYALTY25', 'Sadık müşteriler %25 indirim', 25.00, '2024-03-01', '2024-12-31', 890, 3000),
(12, 'NEWYEAR30', 'Yeni yıl %30 indirim', 30.00, '2024-01-01', '2024-01-31', 4567, 2000);

-- =====================================================
-- 12. FAVORILER TABLOSU

CREATE TABLE favoriler (
    favori_id SERIAL PRIMARY KEY,
    musteri_id INTEGER REFERENCES musteriler(musteri_id) NOT NULL,
    urun_id INTEGER REFERENCES urunler(urun_id) NOT NULL,
    eklenme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO favoriler (favori_id, musteri_id, urun_id, eklenme_tarihi) VALUES
(1, 1, 1, '2024-01-10 14:30:00'),
(2, 1, 5, '2024-01-12 10:15:00'),
(3, 1, 10, '2024-01-14 16:40:00'),
(4, 2, 2, '2024-01-11 09:25:00'),
(5, 2, 12, '2024-01-15 13:50:00'),
(6, 3, 6, '2024-01-13 11:30:00'),
(7, 3, 8, '2024-01-18 14:15:00'),
(8, 4, 3, '2024-01-12 15:45:00'),
(9, 4, 14, '2024-01-20 10:20:00'),
(10, 5, 27, '2024-01-16 12:40:00'),
(11, 5, 26, '2024-01-19 14:30:00'),
(12, 6, 9, '2024-01-14 16:15:00'),
(13, 6, 4, '2024-01-21 09:50:00'),
(14, 7, 30, '2024-01-17 13:25:00'),
(15, 7, 28, '2024-01-22 11:10:00'),
(16, 8, 1, '2024-01-13 10:30:00'),
(17, 8, 23, '2024-01-20 14:45:00'),
(18, 9, 20, '2024-01-15 09:20:00'),
(19, 9, 21, '2024-01-23 15:35:00'),
(20, 10, 5, '2024-01-18 11:50:00'),
(21, 10, 7, '2024-01-21 13:15:00'),
(22, 11, 11, '2024-01-16 10:40:00'),
(23, 11, 13, '2024-01-24 14:25:00'),
(24, 12, 17, '2024-01-19 12:30:00'),
(25, 12, 24, '2024-01-25 16:10:00');

-- =====================================================
-- 13. INDIRIMLER TABLOSU

CREATE TABLE indirimler (
    indirim_id SERIAL PRIMARY KEY,
    urun_id INTEGER REFERENCES urunler(urun_id) NOT NULL,
    orijinal_fiyat DECIMAL(10,2) NOT NULL,
    indirimli_fiyat DECIMAL(10,2) NOT NULL,
    indirim_yuzde DECIMAL(5,2) NOT NULL,
    baslama_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL
);


INSERT INTO indirimler (indirim_id, urun_id, orijinal_fiyat, indirimli_fiyat, indirim_yuzde, baslama_tarihi, bitis_tarihi) VALUES
(1, 1, 45000.00, 42000.00, 6.67, '2024-01-15', '2024-02-15'),
(2, 2, 42000.00, 39500.00, 5.95, '2024-01-16', '2024-02-16'),
(3, 3, 2500.00, 2100.00, 16.00, '2024-01-17', '2024-02-17'),
(4, 4, 25000.00, 23500.00, 6.00, '2024-01-18', '2024-02-18'),
(5, 5, 4500.00, 4200.00, 6.67, '2024-01-19', '2024-02-19'),
(6, 6, 2500.00, 2100.00, 16.00, '2024-01-20', '2024-02-20'),
(7, 7, 2800.00, 2400.00, 14.29, '2024-01-21', '2024-02-21'),
(8, 8, 1200.00, 950.00, 20.83, '2024-01-22', '2024-02-22'),
(9, 9, 500.00, 350.00, 30.00, '2024-01-23', '2024-02-23'),
(10, 10, 3500.00, 3200.00, 8.57, '2024-01-24', '2024-02-24'),
(11, 11, 8900.00, 8000.00, 10.11, '2024-01-25', '2024-02-25'),
(12, 12, 12000.00, 11000.00, 8.33, '2024-01-26', '2024-02-26'),
(13, 13, 25000.00, 23000.00, 8.00, '2024-01-27', '2024-02-27'),
(14, 14, 35000.00, 32000.00, 8.57, '2024-01-28', '2024-02-28'),
(15, 15, 95000.00, 88000.00, 7.37, '2024-01-29', '2024-02-29'),
(16, 16, 2200.00, 1900.00, 13.64, '2024-02-01', '2024-03-01'),
(17, 17, 4500.00, 4000.00, 11.11, '2024-02-02', '2024-03-02'),
(18, 18, 350.00, 280.00, 20.00, '2024-02-03', '2024-03-03'),
(19, 19, 8000.00, 7200.00, 10.00, '2024-02-04', '2024-03-04'),
(20, 20, 150.00, 120.00, 20.00, '2024-02-05', '2024-03-05');



-- SORU 1: Tüm ürünlerin adlarını ve fiyatlarını göster.

SELECT urun_adi, fiyat FROM urunler;

-- SORU 2: Kategorisi 'Elektronik' olan ürünlerin adlarını ve stok sayılarını göster.

SELECT u.urun_adi, u.stok_sayisi 
FROM urunler u
JOIN kategoriler k ON u.kategori_id = k.kategori_id
WHERE k.kategori_adi = 'Elektronik';



-- SORU 3: Müşterilerin adlarını ve email adreslerini göster, ada göre A'dan Z'ye sırala.

SELECT ad_soyad, email FROM musteriler ORDER BY ad_soyad;



-- SORU 4: Durum değeri 'Teslim Edildi' olan tüm siparişleri göster.

SELECT * FROM siparisler WHERE durum = 'Teslim Edildi';



-- SORU 5: Satıcılar tablosundan şu andaki 'Aktif' satıcıları listele.

SELECT * FROM saticilar WHERE durum = 'Aktif';

-- SORU 6: Ürün id 1, 2, 3, 4, 5 olan ürünlerin adları ve fiyatlarını göster.
SELECT urun_adi, fiyat FROM urunler WHERE urun_id IN (1,2,3,4,5);



-- SORU 7: 50.000 TL'den fazla fiyata sahip ürünleri göster.
SELECT * FROM urunler WHERE fiyat > 50000;



-- SORU 8: 2024-01-20'den sonra yapılan siparişleri göster.
SELECT * FROM siparisler WHERE siparis_tarihi > '2024-01-20';



-- SORU 9: Başarılı ödemeler ('Basarili') tablosunu göster.
SELECT * FROM odemeler WHERE durum = 'Basarili';



-- SORU 10: Ortalama puanı 4.5 ve üzeri olan ürünleri göster.
SELECT * FROM urunler WHERE ortalama_puan >= 4.5;


-- SORU 11: Müşteri adı 'Ayşe Yilmaz' olan kişinin tüm siparişlerini göster.
SELECT s.siparis_id, s.toplam_tutar, s.durum
FROM siparisler s
JOIN musteriler m ON s.musteri_id = m.musteri_id
WHERE m.ad_soyad = 'Ayşe Yilmaz';



-- SORU 12: Hangi müşteri en çok para harcadı?
SELECT ad_soyad, toplam_harcama 
FROM musteriler 
ORDER BY toplam_harcama DESC 
LIMIT 1;


-- SORU 13: En çok satılan 5 ürünü göster.
SELECT urun_adi, satilan_adet 
FROM urunler 
ORDER BY satilan_adet DESC 
LIMIT 5;


-- SORU 14: Her kategorideki ürün sayısını göster.
SELECT k.kategori_adi, COUNT(u.urun_id) as urun_sayisi
FROM kategoriler k
LEFT JOIN urunler u ON k.kategori_id = u.kategori_id
GROUP BY k.kategori_adi;


-- SORU 15: Sipariş 1'in detaylarını göster.
SELECT u.urun_adi, sd.miktar, sd.birim_fiyati, sd.alt_toplam
FROM siparis_detaylari sd
JOIN urunler u ON sd.urun_id = u.urun_id
WHERE sd.siparis_id = 1;


-- SORU 16: Toplam siparişi 5'ten fazla olan müşterileri göster.
SELECT ad_soyad, siparis_sayisi 
FROM musteriler 
WHERE siparis_sayisi > 5;


-- SORU 17: 'Gold' üyelik türü olan müşterilerin adlarını ve toplam harcamalarını göster.
SELECT ad_soyad, toplam_harcama 
FROM musteriler 
WHERE uyelik_tipi = 'Gold';


-- SORU 18: Her satıcıdan kaç tane ürün satılmış?
SELECT s.satici_adi, SUM(u.satilan_adet) as toplam_satilan
FROM saticilar s
JOIN urunler u ON s.satici_id = u.satici_id
GROUP BY s.satici_adi;


-- SORU 19: 4 ve üzeri puanı olan ürünlerin ortalamasını hesapla.
SELECT AVG(ortalama_puan) as ortalama
FROM urunler 
WHERE ortalama_puan >= 4;


-- SORU 20: Kargo durumu 'Teslim Edildi' olan kaç sipariş var?
SELECT COUNT(*) as teslim_edilen_siparis
FROM kargo_tracking 
WHERE durum = 'Teslim Edildi';


-- SORU 21: Müşteri 'Fatma Sahin'in favorilerine eklediği ürünleri göster.
SELECT u.urun_adi
FROM favoriler f
JOIN urunler u ON f.urun_id = u.urun_id
JOIN musteriler m ON f.musteri_id = m.musteri_id
WHERE m.ad_soyad = 'Fatma Sahin';


-- SORU 22: Promosyon kodu 'WELCOME10'un kaç kez kullanıldığını göster.
SELECT kullanim_sayisi 
FROM promosyonlar 
WHERE promo_kodu = 'WELCOME10';


-- SORU 23: Yorum puanı 5 olan ürünlerin adlarını ve kaç tane 5 yorum aldığını göster.
SELECT u.urun_adi, COUNT(y.yorum_id) as bes_yorum_sayisi
FROM yorumlar y
JOIN urunler u ON y.urun_id = u.urun_id
WHERE y.puan = 5
GROUP BY u.urun_adi;


-- SORU 24: İndirim yüzdesi en yüksek 3 ürünü göster.
SELECT u.urun_adi, i.indirim_yuzde
FROM indirimler i
JOIN urunler u ON i.urun_id = u.urun_id
ORDER BY i.indirim_yuzde DESC
LIMIT 3;


-- SORU 25: 'Yolda' durumundaki kargo takiplerine ait siparişleri göster.
SELECT s.*
FROM siparisler s
JOIN kargo_tracking kt ON s.siparis_id = kt.siparis_id
WHERE kt.durum = 'Yolda';



-- SORU 26: Müşteri 'Mehmet Kaya' hangi ürünleri aldı, kargo durumu nedir, kaç TL harcadı?
SELECT u.urun_adi, sd.miktar, sd.birim_fiyati, sd.alt_toplam, kt.durum as kargo_durumu
FROM musteriler m
JOIN siparisler s ON m.musteri_id = s.musteri_id
JOIN siparis_detaylari sd ON s.siparis_id = sd.siparis_id
JOIN urunler u ON sd.urun_id = u.urun_id
LEFT JOIN kargo_tracking kt ON s.siparis_id = kt.siparis_id
WHERE m.ad_soyad = 'Mehmet Kaya';


-- SORU 27: En iyi puanlanmış satıcının adını ve satıcı puanını göster.
SELECT satici_adi, ortalama_puan 
FROM saticilar 
ORDER BY ortalama_puan DESC 
LIMIT 1;


-- SORU 28: Toplam satış değeri en yüksek 5 satıcıyı göster.
SELECT s.satici_adi, SUM(sd.alt_toplam) as toplam_satis
FROM saticilar s
JOIN urunler u ON s.satici_id = u.satici_id
JOIN siparis_detaylari sd ON u.urun_id = sd.urun_id
GROUP BY s.satici_adi
ORDER BY toplam_satis DESC
LIMIT 5;


-- SORU 29: Her müşteri kaç sipariş yapmış, toplam ne harcamış göster.
SELECT m.ad_soyad, m.siparis_sayisi, m.toplam_harcama
FROM musteriler m
ORDER BY m.toplam_harcama DESC;


-- SORU 30: Elektronik kategorisindeki ürünlerin ortalama fiyatı nedir? Stok sayısı kaçtır?
SELECT 
    AVG(u.fiyat) as ortalama_fiyat,
    SUM(u.stok_sayisi) as toplam_stok
FROM urunler u
JOIN kategoriler k ON u.kategori_id = k.kategori_id
WHERE k.kategori_adi = 'Elektronik';


-- SORU 31: Her gün kaç sipariş alındığını göster.
SELECT DATE(siparis_tarihi) as gun, COUNT(*) as siparis_sayisi
FROM siparisler
GROUP BY DATE(siparis_tarihi)
ORDER BY gun;


-- SORU 32: En çok yorum alan 5 ürünü göster.
SELECT urun_adi, yorum_sayisi, ortalama_puan
FROM urunler
ORDER BY yorum_sayisi DESC
LIMIT 5;


-- SORU 33: Her kargo şirketinin ortalama kaç günde teslim ettiğini hesapla.
SELECT 
    ks.sirket_adi,
    AVG(kt.teslimat_tarihi - kt.kargo_tarihi) as ortalama_teslim_gunu
FROM kargo_sirketleri ks
JOIN kargo_tracking kt ON ks.kargo_id = kt.kargo_id
WHERE kt.teslimat_tarihi IS NOT NULL
GROUP BY ks.sirket_adi;


-- SORU 34: Başlama tarihi 2024-01-01'den sonra olan ve indirim yüzdesi 15% üzeri olan promosyonları göster.
SELECT * 
FROM promosyonlar 
WHERE baslama_tarihi > '2024-01-01' 
AND indirim_orani > 15;


-- SORU 35: Müşteri 1'in tüm satın aldığı ürünleri göster.
SELECT u.urun_adi, k.kategori_adi, u.fiyat, sd.alt_toplam as toplam
FROM musteriler m
JOIN siparisler s ON m.musteri_id = s.musteri_id
JOIN siparis_detaylari sd ON s.siparis_id = sd.siparis_id
JOIN urunler u ON sd.urun_id = u.urun_id
JOIN kategoriler k ON u.kategori_id = k.kategori_id
WHERE m.musteri_id = 1;



-- SORU 36: Her müşterinin son 3 ayda yaptığı siparişlerin ortalamasını hesapla.
SELECT 
    m.ad_soyad,
    AVG(s.son_tutar) as siparis_ortalamasi
FROM musteriler m
JOIN siparisler s ON m.musteri_id = s.musteri_id
WHERE s.siparis_tarihi >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY m.ad_soyad;





-- Tüm tabloları listele
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Her tablodaki kayıt sayısını göster
SELECT 'kategoriler' as tablo, COUNT(*) as kayit_sayisi FROM kategoriler
UNION ALL
SELECT 'saticilar', COUNT(*) FROM saticilar
UNION ALL
SELECT 'musteriler', COUNT(*) FROM musteriler
UNION ALL
SELECT 'urunler', COUNT(*) FROM urunler
UNION ALL
SELECT 'siparisler', COUNT(*) FROM siparisler
UNION ALL
SELECT 'siparis_detaylari', COUNT(*) FROM siparis_detaylari
UNION ALL
SELECT 'odemeler', COUNT(*) FROM odemeler
UNION ALL
SELECT 'kargo_sirketleri', COUNT(*) FROM kargo_sirketleri
UNION ALL
SELECT 'kargo_tracking', COUNT(*) FROM kargo_tracking
UNION ALL
SELECT 'yorumlar', COUNT(*) FROM yorumlar
UNION ALL
SELECT 'promosyonlar', COUNT(*) FROM promosyonlar
UNION ALL
SELECT 'favoriler', COUNT(*) FROM favoriler
UNION ALL
SELECT 'indirimler', COUNT(*) FROM indirimler;