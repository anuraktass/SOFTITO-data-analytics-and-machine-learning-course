# YOLO ile Nesne Tespiti (Object Detection)

> **Durum:** Notebook henüz eklenmedi — bu README, konu anlatımı ve pratik önerisi olarak hazır.

## 3.1 Sınıflandırma ile Nesne Tespiti Arasındaki Fark
- **Image Classification:** "Bu görüntüde ne var?" sorusuna tek bir etiketle cevap verir.
- **Object Detection:** "Bu görüntüde hangi nesneler var ve **nerede**?" sorusuna, her nesne için bir **bounding box** (sınırlayıcı kutu) ve sınıf etiketiyle cevap verir. Aynı görüntüde birden fazla nesne aynı anda tespit edilebilir.

## 3.2 YOLO (You Only Look Once) Mantığı
Geleneksel nesne tespiti yöntemleri görüntüyü önce bölgelere ayırıp her bölgeyi ayrı ayrı sınıflandırırken (yavaş), YOLO görüntüyü **tek bir geçişte (single pass)** bir ızgaraya (grid) böler ve her hücre için doğrudan bounding box koordinatlarını, nesne olasılığını ve sınıf olasılıklarını aynı anda tahmin eder. Bu, YOLO'yu gerçek zamanlı uygulamalar (video, canlı kamera) için uygun hale getiren temel özelliktir.

## 3.3 Temel Kavramlar
- **Bounding Box:** Nesnenin konumunu tanımlayan dikdörtgen (genelde merkez koordinatı, genişlik, yükseklik olarak).
- **Anchor Box:** Farklı en-boy oranlarındaki nesneleri (uzun bir araba, kare bir top vb.) daha iyi yakalamak için kullanılan önceden tanımlı referans kutular.
- **IoU (Intersection over Union):** Tahmin edilen kutu ile gerçek (ground truth) kutu arasındaki örtüşme oranı; tahminin doğruluğunu ölçmede kullanılır (1'e yakın = mükemmel örtüşme).
- **Non-Max Suppression (NMS):** Aynı nesne için üretilen birden fazla çakışan kutudan, en yüksek güven skoruna sahip olanı bırakıp diğerlerini eleyen adım.
- **mAP (mean Average Precision):** Nesne tespiti modellerinin standart performans metriği; farklı IoU eşiklerinde precision-recall dengesini özetler.

## 3.4 YOLO Sürümlerinin Genel Gelişimi
YOLO, ilk sürümünden (2016) bu yana sürekli geliştirilmiştir (YOLOv3, v4, v5, v8 vb.); her yeni sürüm genellikle daha iyi doğruluk, daha hızlı çıkarım (inference) süresi ve daha kolay eğitim/dağıtım arayüzleri sunar. Güncel sürümler genellikle:
- Kendi custom veri setinizle (özel nesneler) kolayca yeniden eğitilebilir (fine-tuning).
- Hazır ağırlıklarla (pretrained weights) doğrudan yaygın nesneler (insan, araba, hayvan vb.) üzerinde çıkarım yapabilir.

---

## Planlanan Notebook İçeriği
`CNN_YOLO_Tutorial.ipynb` (Bölüm 4): YOLO kurulumu, örnek veri setiyle inference, model bilgileri (katman/parametre sayısı) incelemesi, CNN sınıflandırma ile YOLO nesne tespiti yaklaşımlarının karşılaştırması.

## Pratik İçin Önerilen Veri Setleri
- **COCO128** (Ultralytics'in YOLO eğitimleri için hazırladığı küçük COCO alt kümesi) — resmi ve hafif bir başlangıç seti.
- **Roboflow Universe** üzerindeki hazır etiketlenmiş setlerden biri (ör. "Pothole Detection", "PPE Detection") — gerçek dünya, tek sınıflı nesne tespiti projesi için pratik.
- **Kaggle — "Face Mask Detection"** veri seti (maske takan/takmayan yüzler, bounding box etiketli).
