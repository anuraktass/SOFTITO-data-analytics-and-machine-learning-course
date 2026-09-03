# PCA — Principal Component Analysis (Temel Bileşen Analizi)

## Temel Fikir
PCA, verideki **en fazla varyansın (yayılımın) olduğu yönleri** bulur. Bu yönlere **temel bileşenler (principal
components)** denir. İlk bileşen en fazla varyansı açıklayan yöndür, ikinci bileşen ona dik (orthogonal) olacak
şekilde kalan varyansın en fazlasını açıklayan yöndür, ve bu böyle devam eder.

## Nasıl Çalışır (Adım Adım)
1. **Standardizasyon:** Özellikler farklı ölçeklerde olabileceğinden veri genelde ortalaması 0, standart sapması 1
   olacak şekilde ölçeklenir (`StandardScaler`). Aksi halde büyük ölçekli özellikler yapay olarak baskın çıkar.
2. **Kovaryans matrisi hesaplanır** (özellikler arasındaki ilişkiyi gösterir).
3. **Özdeğer/özvektör (eigenvalue/eigenvector) ayrıştırması** yapılır — özvektörler yönleri (bileşenleri),
   özdeğerler ise o yöndeki varyans miktarını verir.
4. Özdeğerlere göre bileşenler büyükten küçüğe sıralanır, istenen sayıda (`n_components`) en büyük bileşen seçilir.
5. Veri bu yeni bileşen eksenlerine **projekte edilir** (dönüştürülür).

## Önemli Kavramlar
- **Açıklanan varyans oranı (explained variance ratio):** Her bileşenin toplam varyansın yüzde kaçını açıkladığını
  gösterir. Kümülatif toplamı (örn. %90'a ulaşan bileşen sayısı) kaç bileşen tutulacağına karar vermede kullanılır.
- **Gözetimsizdir:** Sınıf etiketlerini (y) hiç kullanmaz, sadece X'in yapısına bakar.
- **Doğrusaldır:** Sadece doğrusal (lineer) kombinasyonlar üretir, karmaşık doğrusal olmayan yapıları yakalayamaz.

## Ne Zaman Kullanılır?
- Genel amaçlı boyut indirgeme / gürültü azaltma
- Modelleme öncesi özellik sayısını azaltmak (overfitting riskini düşürmek)
- Hızlı, yeni veriye de uygulanabilir (`.transform()` ile)

## Uygulama
Bu klasördeki `pca_uygulama.ipynb` (çalıştırılmış hâli `pca_uygulama.md`), PCA'yı UCI HAR veri setine (561 özellik,
6 aktivite sınıfı) uygular: açıklanan varyans grafiği ve 2 boyutlu projeksiyon görselleştirmesi içerir.
