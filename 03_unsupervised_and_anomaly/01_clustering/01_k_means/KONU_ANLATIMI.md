# K-MEANS KÜMELEME ALGORİTMASI — KONU ANLATIMI

## Algoritma Açıklaması

**K-Means**, veri setini K adet kümeye ayıran, merkez tabanlı bir kümeleme algoritmasıdır.

## Çalışma Prensipleri
1. K adet başlangıç merkezi (centroid) rastgele seçilir.
2. Her veri noktası en yakın merkeze atanır.
3. Her kümenin yeni merkezi, o kümedeki noktaların ortalaması alınarak güncellenir.
4. 2. ve 3. adımlar merkezler değişmeyene kadar tekrarlanır.

## Hiperparametreler
- `n_clusters`: Küme sayısı (K)
- `init`: Başlangıç merkez seçim yöntemi ('k-means++', 'random')
- `n_init`: Farklı başlangıçlarla çalıştırma sayısı
- `max_iter`: Maksimum iterasyon sayısı

## Küme Sayısını Belirleme Yöntemleri
- **Elbow Metodu**: K değerine karşılık inertia (WCSS) grafiği çizilir, dirsek noktası seçilir.
- **Silhouette Skoru**: Kümeleme kalitesini -1 ile 1 arasında değerlendirir.
- **Davies-Bouldin İndeksi**: Kümeler arası benzerliği ölçer, düşük değer iyidir.
