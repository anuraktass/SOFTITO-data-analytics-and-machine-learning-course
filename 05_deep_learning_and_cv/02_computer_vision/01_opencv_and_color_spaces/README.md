# OpenCV ve Renk Uzayları

> **Durum:** Notebook henüz eklenmedi — bu README, konu anlatımı ve pratik önerisi olarak hazır.

## 1.1 Dijital Görüntünün Temel Yapısı
Bir dijital görüntü, satır ve sütunlardan oluşan bir **piksel** matrisidir. Renkli bir görüntüde her piksel, genellikle 3 **kanal** (Kırmızı, Yeşil, Mavi) için 0-255 arası birer değer içerir. OpenCV, görüntüleri varsayılan olarak **BGR** (Mavi-Yeşil-Kırmızı) sırasıyla okur; bu, diğer birçok kütüphanenin (matplotlib, PIL) kullandığı RGB sırasından farklıdır ve dönüştürme yapılmazsa renklerin "tersine dönmüş" görünmesine yol açar.

## 1.2 Renk Uzayları
Renk uzayı, renklerin matematiksel olarak nasıl temsil edildiğini tanımlayan bir sistemdir.

| Renk Uzayı | Bileşenler | Kullanım Alanı |
|---|---|---|
| **RGB/BGR** | Kırmızı, Yeşil, Mavi | Görüntüleme ve depolama için standart |
| **HSV** | Hue (Ton), Saturation (Doygunluk), Value (Parlaklık) | Renk tabanlı nesne tespiti için idealdir; çünkü aydınlatma değişimlerinden (Value) renk bilgisini (Hue) ayırır |
| **LAB** | L (Aydınlık), A (Yeşil-Kırmızı ekseni), B (Mavi-Sarı ekseni) | İnsan gözünün algısına daha yakın; renk farkı ölçümlerinde kullanılır |
| **YCrCb** | Y (Parlaklık), Cr/Cb (Renk farkı bileşenleri) | Video sıkıştırma (JPEG, MPEG) ve cilt tonu tespitinde yaygın |

**Neden HSV renk tabanlı tespit için tercih edilir?** RGB'de bir rengin farklı aydınlatma koşullarındaki (gölge, parlak ışık) değerleri büyük ölçüde değişir. HSV'de ise ton (Hue) bileşeni aydınlatmadan bağımsız kaldığı için, `cv2.inRange()` ile belirli bir renk aralığı tanımlayarak (örn. kırmızı için Hue: 0-10 ve 170-180) daha kararlı bir tespit yapılabilir.

## 1.3 Temel Görüntü İşleme Operasyonları

- **Yeniden boyutlandırma (Resize) / Döndürme (Rotation):** Görüntü boyutunu veya açısını değiştirme; genelde bir sonraki işlem adımı (örn. sabit boyutlu bir CNN girdisi) için ön hazırlık.
- **Gri tonlama (Grayscale):** 3 kanallı renkli görüntüyü tek kanala indirger; birçok klasik işlem (kenar algılama, eşikleme) gri görüntü üzerinde çalışır.
- **Filtreleme (Blur/Sharpen):** Gauss, medyan gibi filtrelerle gürültü azaltma veya kenarları belirginleştirme.
- **Kenar Algılama (Edge Detection):** Canny algoritması gibi yöntemlerle görüntüdeki ani parlaklık değişimlerinin (nesne sınırlarının) tespiti.
- **Histogram:** Görüntüdeki piksel yoğunluk dağılımının analizi; kontrast sorunlarını teşhis etmede kullanılır.
- **Eşikleme (Thresholding):** Bir piksel değerini eşik değerine göre siyah/beyaza (ya da 0/1'e) dönüştürerek görüntüyü ikili (binary) hale getirme.
- **Morfolojik İşlemler (Erosion/Dilation):** İkili görüntülerdeki küçük gürültüleri temizleme (erosion) veya nesne bölgelerini genişletme (dilation); genellikle eşikleme sonrası uygulanır.
- **Kontur Algılama (Contour Detection):** İkili bir görüntüdeki bağlantılı nesne sınırlarının tespiti; nesne sayma, şekil analizi ve basit nesne tespitinin temelini oluşturur.

## 1.4 Renk Tabanlı Nesne Tespiti İş Akışı
Klasik, derin öğrenme gerektirmeyen bir nesne tespiti yaklaşımı şu adımları izler:

```
1. BGR Görüntü
   ↓
2. HSV'ye Dönüştür (cv2.cvtColor)
   ↓
3. Renk Aralığı Tanımla ve Maskele (cv2.inRange)
   ↓
4. Morfolojik İşlemlerle Maskeyi Temizle
   ↓
5. Kontur Tespiti (cv2.findContours)
   ↓
6. Kontur Özelliklerinden (alan, çevre, fit ellipse, min enclosing circle) Nesneyi Sınırla/Sınıflandır
```

Bu yaklaşımın avantajı hızlı ve hesaplama açısından hafif olmasıdır; dezavantajı ise yalnızca belirgin renk farkına sahip, kontrollü ortamlardaki (sabit aydınlatma, arka plan) nesnelerde iyi çalışmasıdır.

---

## Planlanan Notebook İçeriği
- **`goruntu_isleme_temeller.ipynb`:** Sıfırdan görüntü oluşturma, piksel/kanal manipülasyonu, temel şekil çizme, resize/rotation, grayscale, filtreler, kenar algılama (Canny), histogram, eşikleme, morfolojik işlemler, kontur algılama.
- **`renk_uzaylari_nesne_tespiti.ipynb`:** RGB/BGR/HSV/LAB/YCrCb dönüşümleri, HSV ile renkli nesne maskeleme, kontur tespiti, elips/daire uydurma, kural tabanlı nesne sınıflandırması.

## Pratik İçin Önerilen Veri Setleri
- Kendi çektiğiniz fotoğraflar veya **Kaggle — "Color Classification"** gibi renkli nesne fotoğrafları içeren küçük setler; HSV tabanlı renk tespiti pratiği için idealdir.
- **Fruits-360** veri seti — kontur ve şekil analizi pratiği için uygundur.
- Trafik işareti rengine göre tespit denemek isterseniz: **GTSRB (German Traffic Sign Recognition Benchmark)**.
