# 01 — Yapay Sinir Ağları ve Optimizasyon

## Kapsam
```
01_neural_nets_and_optimization/
├── 01_ann_architectures/
└── 02_optimizers_and_loss_functions/
```

---

## 01_ann_architectures — `yapay_sinir_aglari_egitimi.ipynb`

**Ne yapılmış:**
- ANN'nin teorik temelleri: nöron, katman, aktivasyon fonksiyonu, ileri/geri yayılım kavramları anlatılmış.
- **Iris veri seti** (scikit-learn `datasets` modülünden, 150 örnek, 4 özellik, 3 sınıf) yüklenmiş.
- Veri ön işleme: `StandardScaler` ile ölçekleme, `train_test_split` ile eğitim/test ayrımı, hedef değişken **one-hot encoding**'e çevrilmiş (categorical_crossentropy için gerekli).
- Keras/TensorFlow ile katmanlı bir ANN kurulmuş: 4 nöronluk giriş → 64 nöronluk gizli katman (ReLU) → %30 Dropout → 32 nöronluk ikinci gizli katman → çıkış katmanı (3 sınıf, softmax).
- Model `Adam(learning_rate=0.001)` optimizatörü ve `categorical_crossentropy` kayıp fonksiyonu ile derlenmiş, eğitilmiş.
- Eğitim eğrileri (loss/accuracy), test seti değerlendirmesi, confusion matrix, sınıflandırma raporu ve özellik ağırlıklarının görselleştirilmesi yapılmış.
- Yeni veri üzerinde tahmin yapılarak sonuçlar yorumlanmış.

**Öğrenilen ana kavramlar:** ANN mimarisi kurma, Dropout ile overfitting azaltma, one-hot encoding, model derleme/eğitme/değerlendirme döngüsü.

### 💡 Pratik için önerilen veri seti
- **Wine Dataset** (scikit-learn `load_wine`) — Iris'e çok benzer yapıda (küçük, sayısal, çok sınıflı) ama farklı bir problem; aynı ANN mimarisini birebir uygulayabilirsiniz.
- Alternatif: **Breast Cancer Wisconsin** (`load_breast_cancer`, sklearn) — ikili sınıflandırma ile pekiştirmek isterseniz (sigmoid + binary_crossentropy denemesi için ideal).
- Daha büyük ölçek istenirse: **Kaggle – "Pima Indians Diabetes Database"** (küçük tablo verisi, ikili sınıflandırma, gerçek dünya gürültüsü içerir).

---

## 02_optimizers_and_loss_functions

**Not:** Yüklenen notebook'larda bu konuya özel ayrı bir dosya bulunmuyor; `yapay_sinir_aglari_egitimi.ipynb` içinde Adam optimizatörü ve categorical_crossentropy kayıp fonksiyonu kullanılmış ancak SGD, RMSprop gibi diğer optimizatörlerin veya farklı kayıp fonksiyonlarının (MSE, binary_crossentropy, hinge loss vb.) karşılaştırmalı bir incelemesi yok. Bu alt başlık için ayrı bir çalışma/notebook hazırlanması önerilir.

### 💡 Pratik için önerilen veri seti
- **Iris** veya **Wine** veri setini yeniden kullanarak, aynı model mimarisi üzerinde **SGD, RMSprop, Adam, Adagrad** gibi farklı optimizatörleri ve **learning rate** değerlerini karşılaştırıp eğitim eğrilerini yan yana çizmek çok öğretici olur.
- **MNIST** (Keras `datasets.mnist`) — farklı loss fonksiyonlarının (categorical_crossentropy vs sparse_categorical_crossentropy) ve optimizatörlerin etkisini gözlemlemek için standart ve hafif bir veri seti.
