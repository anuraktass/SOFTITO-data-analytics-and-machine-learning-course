# DBSCAN (DENSITY-BASED SPATIAL CLUSTERING OF APPLICATIONS WITH NOISE) — KONU ANLATIMI

## Algoritma Açıklaması

**DBSCAN**, yoğunluk tabanlı bir kümeleme algoritmasıdır. Kümeleri, yüksek yoğunluklu bölgeler olarak tanımlar.

## Çalışma Prensipleri
1. Her nokta için epsilon (eps) yarıçapındaki komşu sayısı hesaplanır.
2. **Çekirdek Nokta**: min_samples'den fazla komşusu olan nokta.
3. **Sınır Noktası**: Çekirdek noktaya yakın ama yeterli komşusu olmayan nokta.
4. **Gürültü Noktası**: Hiçbir kümeye ait olmayan nokta (etiket = -1).
5. Yoğunlukla bağlantılı noktalar aynı kümeyi oluşturur.

## Hiperparametreler
- `eps`: Komşuluk yarıçapı
- `min_samples`: Çekirdek nokta için minimum komşu sayısı

## Avantajları
- Küme sayısını önceden belirtmeye gerek yoktur
- Aykırı değerleri (gürültü) tespit edebilir
- Karmaşık şekilli kümeleri bulabilir

## Dezavantajları
- Farklı yoğunluktaki kümeleri bulmakta zorlanır
- eps parametresine duyarlıdır
