# LDA — Linear Discriminant Analysis (Doğrusal Ayırt Edici Analiz)

## Temel Fikir
LDA, PCA'nın aksine **gözetimli (supervised)** bir yöntemdir — sınıf etiketlerini (y) kullanır. Amacı; verideki
**sınıflar arası varyansı maksimize ederken, sınıf içi varyansı minimize eden** doğrusal yönleri (ayırt edici
eksenler / discriminant axes) bulmaktır. Böylece farklı sınıflara ait noktalar birbirinden mümkün olduğunca
uzaklaşırken, aynı sınıfa ait noktalar birbirine mümkün olduğunca yakın kalır.

## Nasıl Çalışır (Sezgisel)
1. Her sınıfın kendi içindeki dağılımı (**sınıf içi saçılım matrisi**, within-class scatter, S_W) hesaplanır.
2. Sınıf ortalamalarının birbirinden ne kadar uzak olduğu (**sınıflar arası saçılım matrisi**, between-class
   scatter, S_B) hesaplanır.
3. S_W⁻¹·S_B matrisinin özdeğer/özvektörleri bulunur; bu özvektörler S_B/S_W oranını (Fisher kriteri) maksimize
   eden yönlerdir.
4. Veri bu yeni eksenlere (LD1, LD2, ...) projekte edilir.

## Önemli Kavramlar
- **Maksimum bileşen sayısı sınırlıdır:** LDA en fazla `min(özellik sayısı, sınıf sayısı - 1)` kadar bileşen
  çıkarabilir. Örneğin 6 sınıflı bir problemde en fazla 5 bileşen elde edilebilir.
- **Gözetimlidir:** Etiket bilgisini kullandığı için, aynı sayıda bileşende genellikle PCA'dan **daha net sınıf
  ayrımı** sağlar.
- **Doğrusaldır** ve PCA gibi yeni veriye de uygulanabilir (`.transform()`).
- LDA aynı zamanda başlı başına bir **sınıflandırma algoritması** olarak da kullanılabilir (projeksiyon + karar
  sınırı), ama burada boyut indirgeme aracı olarak ele alınmaktadır.

## Ne Zaman Kullanılır?
- Sınıflandırma problemlerinde, sınıflandırmadan önce boyut indirgeme yapmak istendiğinde
- Sınıflar arası ayrımı en iyi şekilde görselleştirmek istendiğinde
- Etiketli veri mevcut olduğunda (supervised senaryo)

## Uygulama
Bu klasördeki `lda_uygulama.ipynb` (çalıştırılmış hâli `lda_uygulama.md`), LDA'yı UCI HAR veri setine uygular ve
sınıf etiketlerini kullanarak 2 boyutlu, sınıfları net şekilde ayıran bir projeksiyon üretir.
