# t-SNE — t-distributed Stochastic Neighbor Embedding

## Temel Fikir
t-SNE, **görselleştirme amaçlı** geliştirilmiş, doğrusal olmayan bir boyut indirgeme yöntemidir. Amacı; yüksek
boyutlu uzayda birbirine **yakın olan noktaların**, düşük boyutlu (genelde 2D) uzayda da **yakın kalmasını**
sağlamaktır — yani **yerel (local) komşuluk yapısını** korur.

## Nasıl Çalışır (Sezgisel)
1. Yüksek boyutlu uzayda her nokta çifti için "bu iki nokta ne kadar yakın komşu" sorusuna olasılıksal bir cevap
   üretilir (Gauss dağılımı temelli benzerlik).
2. Düşük boyutlu uzayda da benzer bir olasılık dağılımı tanımlanır (bu kez daha "kalın kuyruklu" — t-dağılımı
   kullanılır, bu da uzak noktaların birbirinden ayrışmasına yardımcı olur, "crowding problem" çözülür).
3. İki dağılım arasındaki farkı (KL diverjansı) minimize edecek şekilde düşük boyutlu noktaların konumu
   **gradyan inişi (gradient descent)** ile iteratif olarak güncellenir.

## Önemli Kavramlar / Dikkat Edilmesi Gerekenler
- **Perplexity:** Her noktanın kaç "efektif komşusu" olduğunu kontrol eden bir hiperparametredir (genelde 5-50
  arası). Farklı perplexity değerleri farklı görünümler üretebilir.
- **Eksenlerin kendi başına anlamı yoktur:** PCA'daki gibi "PC1 varyansın %X'ini açıklıyor" gibi bir yorum
  yapılamaz; sadece kümelenme yapısı yorumlanır.
- **Küme boyutları ve aralarındaki mesafeler güvenilir değildir** — sadece "hangi noktalar birbirine yakın/hangi
  gruplar ayrı" bilgisi anlamlıdır.
- **Yeni veriye uygulanamaz:** PCA/LDA'nın aksine `.transform()` yoktur; her yeni veri seti için yeniden eğitim
  (fit) gerekir.
- **Hesaplama maliyeti yüksektir**, büyük veri setlerinde genelde önce PCA ile ön-indirgeme yapılır, sonra t-SNE
  uygulanır; ya da veri setinden örneklem alınır.

## Ne Zaman Kullanılır?
- Yüksek boyutlu verinin **görsel olarak** kümelenme/ayrışma yapısını incelemek
- Sınıflandırma öncesi keşifsel veri analizi (EDA)
- **Model eğitmek için özellik olarak KULLANILMAZ** (sadece görselleştirme amaçlıdır)

## Uygulama
Bu klasördeki `tsne_uygulama.ipynb` (çalıştırılmış hâli `tsne_uygulama.md`), t-SNE'yi UCI HAR veri setinden alınan
2000 örneklik alt kümeye uygular ve 2 boyutlu görselleştirme üretir.
