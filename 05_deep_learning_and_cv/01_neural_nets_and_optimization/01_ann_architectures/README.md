# Yapay Sinir Ağları (ANN) ile Şarap Kalitesi Sınıflandırma

Bu proje, temel bir ANN mimarisinin gerçek dünyadan gelen, dengesiz bir tablo verisi üzerinde nasıl uygulandığını gösterir.

## Veri Seti
- **Kaynak:** [Wine Quality Dataset (Kaggle)](https://www.kaggle.com/datasets/yasserh/wine-quality-dataset)
- **Boyut:** 1143 örnek, 11 fizikokimyasal özellik (asitlik, şeker, alkol vb.)
- **Hedef:** Şarap kalitesi (orijinalde 3-8 arası puan; bu projede Düşük/Orta/Yüksek olarak 3 gruba indirgendi)

## Kullanım
1. `WineQT.csv` dosyasını Kaggle'dan indirip bu klasöre koyun.
2. Gerekli kütüphaneleri kurun: `pip install numpy pandas matplotlib seaborn scikit-learn tensorflow`
3. `ann_wine_quality_classification.ipynb` dosyasını çalıştırın.

## Öne Çıkanlar
- Gerçek verideki sınıf dengesizliğiyle başa çıkmak için `class_weight` kullanımı
- Korelasyon analizi ve özellik önemi görselleştirmesi
- Confusion matrix ve detaylı sınıflandırma raporu

## Kullanılan Teknolojiler
`Python`, `TensorFlow/Keras`, `scikit-learn`, `pandas`, `seaborn`
