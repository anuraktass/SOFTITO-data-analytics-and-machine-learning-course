# CNN (Evrişimli Sinir Ağı) Mimarileri

> **Durum:** Notebook henüz eklenmedi — bu README, konu anlatımı ve pratik önerisi olarak hazır.

## 2.1 Neden CNN?
Standart bir ANN, bir görüntüyü düz bir vektöre çevirerek işler; bu, piksellerin **uzamsal (spatial)** ilişkisini (komşuluk bilgisini) kaybeder ve büyük görüntülerde parametre sayısını patlatır. CNN, bu sorunu **evrişim (convolution)** operasyonuyla çözer: küçük bir filtre (kernel), görüntü üzerinde kaydırılarak yerel desenleri (kenar, doku, şekil) öğrenir.

## 2.2 Temel CNN Katmanları
- **Convolution (Evrişim) Katmanı:** Öğrenilebilir filtrelerle görüntüden özellik haritaları (feature map) çıkarır. Katman derinleştikçe filtreler basit kenarlardan karmaşık nesne parçalarına (göz, tekerlek vb.) doğru daha soyut desenler öğrenir.
- **Pooling (Havuzlama) Katmanı:** Özellik haritalarının boyutunu küçültür (genelde Max Pooling), hem hesaplama yükünü azaltır hem de modele küçük konum kaymalarına karşı dayanıklılık kazandırır.
- **Flatten + Dense Katmanlar:** Evrişim/pooling katmanlarından çıkan özellik haritaları düzleştirilip, sınıflandırma için tam bağlantılı katmanlara verilir.

## 2.3 Veri Augmentasyonu (Data Augmentation)
Sınırlı miktardaki eğitim verisini yapay olarak çoğaltmak için görüntülere rastgele dönüşümler (döndürme, kaydırma, yatay çevirme, yakınlaştırma, parlaklık değişimi) uygulanır. Bu, modelin ezber yapmasını (overfitting) engeller ve gerçek dünyadaki varyasyonlara karşı daha dayanıklı hale gelmesini sağlar.

## 2.4 Bilinen CNN Mimarileri (Tarihsel Gelişim)
| Mimari | Öne Çıkan Özellik |
|---|---|
| **LeNet-5** (1998) | CNN'in ilk pratik uygulamalarından; el yazısı rakam tanıma |
| **AlexNet** (2012) | ImageNet yarışmasında derin öğrenmenin çığır açtığı mimari; ReLU ve Dropout'un yaygınlaşması |
| **VGG** (2014) | Küçük (3x3) filtrelerin art arda kullanılmasıyla derinliğin artırılması |
| **ResNet** (2015) | "Residual/Skip connections" ile çok derin ağlarda (100+ katman) gradyan kaybolma sorununu çözer |
| **MobileNet** | Derinlik ayrılabilir evrişimler (depthwise separable convolution) ile mobil/gömülü cihazlar için hafifletilmiş mimari |

## 2.5 Transfer Learning
Sıfırdan büyük bir CNN eğitmek, büyük miktarda veri ve hesaplama gücü gerektirir. **Transfer learning**, ImageNet gibi büyük bir veri setinde önceden eğitilmiş bir modelin (MobileNet, ResNet, VGG vb.) öğrendiği genel görsel özellikleri (kenar, doku, şekil algılama) alıp, yeni ve daha küçük bir probleme uyarlamayı sağlar. Genellikle iki yaklaşım izlenir:
- **Feature extraction:** Önceden eğitilmiş modelin ağırlıkları dondurulur, sadece yeni eklenen son katmanlar eğitilir.
- **Fine-tuning:** Önceden eğitilmiş modelin bazı üst katmanları da düşük bir öğrenme oranıyla yeniden eğitilerek probleme daha fazla uyarlanır.

---

## Planlanan Notebook İçeriği
`CNN_YOLO_Tutorial.ipynb` (Bölüm 1-3): **CIFAR-10** veri seti üzerinde sıfırdan CNN kurulumu (konvolüsyon +
pooling + fully-connected), veri augmentasyonu, eğitim/değerlendirme (confusion matrix, sınıflandırma
raporu), ve **MobileNetV2** ile transfer learning karşılaştırması.

## Pratik İçin Önerilen Veri Setleri
- **CIFAR-100** — CIFAR-10'a çok benzer ama 100 sınıflı, daha zorlayıcı bir sınıflandırma problemi sunar.
- **Fashion-MNIST** — daha hafif, hızlı denemeler için (giysi sınıflandırma).
- **Kaggle — "Intel Image Classification"** (doğa manzaraları, 6 sınıf) veya **"Cats vs Dogs"** — transfer learning pratiği için popüler ve uygun.
