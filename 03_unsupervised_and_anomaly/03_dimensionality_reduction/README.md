# Boyut İndirgeme (Dimensionality Reduction) — Genel Özet ve Karşılaştırma

Bu klasör üç konuyu içerir, her biri kendi alt klasöründe konu anlatımı (`*_konu_anlatimi.md`) ve uygulama
(`*_uygulama.ipynb` + görsellerle birlikte `*_uygulama.md`) olarak ayrılmıştır:

```
03_dimensionality_reduction/
├── data/                                  → UCI HAR Dataset (ortak veri seti)
├── 01_principal_component_analysis/
│   ├── pca_konu_anlatimi.md
│   ├── pca_uygulama.ipynb
│   └── pca_uygulama.md (+ pca_uygulama_files/ görseller)
├── 02_tsne_visualization/
│   ├── tsne_konu_anlatimi.md
│   ├── tsne_uygulama.ipynb
│   └── tsne_uygulama.md (+ tsne_uygulama_files/ görseller)
└── 03_linear_discriminant_analysis/
    ├── lda_konu_anlatimi.md
    ├── lda_uygulama.ipynb
    └── lda_uygulama.md (+ lda_uygulama_files/ görseller)
```

Not: Notebook'lar veriyi `../data/UCI HAR Dataset` yolundan okuyacak şekilde ayarlanmıştır; klasör yapısını
bozmadan taşırsanız çalışmaya devam eder.

> **Veri seti notu:** Orijinal UCI HAR Dataset ~270 MB'dır (test seti + "Inertial Signals" ham sensör
> verilerini de içerir). Bu üç notebook yalnızca `train/X_train.txt`, `train/y_train.txt`,
> `train/subject_train.txt`, `activity_labels.txt` ve `features.txt` dosyalarını kullandığından, depo
> boyutunu makul tutmak için **test seti ve Inertial Signals klasörleri dahil edilmedi**. Tam veri setine
> ihtiyaç duyarsan: [UCI HAR Dataset](https://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones).

## 0. Boyut İndirgeme Nedir, Neden Kullanılır?

Gerçek veri setleri genellikle onlarca, yüzlerce hatta binlerce özellik (boyut/feature) içerir. Örneğin UCI HAR
(Human Activity Recognition) veri setinde her örnek **561 özellik** ile temsil edilir. Bu kadar yüksek boyutlu
veriyle çalışmanın bazı zorlukları vardır:

- **Boyutluluk laneti (curse of dimensionality):** Boyut arttıkça veri noktaları arasındaki mesafeler anlamsızlaşır,
  modellerin daha fazla veriye ihtiyacı olur.
- **Görselleştirme imkansızlığı:** İnsan gözü 2-3 boyuttan fazlasını göremez.
- **Gürültü ve gereksiz bilgi:** Özelliklerin bir kısmı birbiriyle ilişkili (redundant) ya da sınıflandırma için
  gereksiz olabilir.
- **Hesaplama maliyeti:** Daha fazla boyut = daha fazla işlem yükü.

**Boyut indirgeme**, veri setinin bilgi içeriğini mümkün olduğunca koruyarak, onu daha az sayıda boyuta
(genellikle 2 veya 3'e, görselleştirme için) dönüştürme işlemidir.

| Yöntem | Gözetimli mi? | Doğrusal mı? | Temel Amaç |
|---|---|---|---|
| **PCA** | Hayır (unsupervised) | Evet | Varyansı maksimize eden yönleri bul |
| **t-SNE** | Hayır (unsupervised) | Hayır | Yerel komşuluk yapısını koru (görselleştirme) |
| **LDA** | Evet (supervised) | Evet | Sınıflar arasını en iyi ayıran yönleri bul |

## Karşılaştırmalı Tablo

| Kriter | PCA | t-SNE | LDA |
|---|---|---|---|
| Öğrenme türü | Gözetimsiz | Gözetimsiz | Gözetimli |
| Doğrusallık | Doğrusal | Doğrusal değil | Doğrusal |
| Etiket (y) kullanır mı? | Hayır | Hayır | Evet |
| Optimizasyon hedefi | Varyansı maksimize et | Komşuluk yapısını koru | Sınıf ayrımını maksimize et (S_B/S_W) |
| Maks. bileşen sayısı | min(n_örnek, n_özellik) | Pratikte 2-3 | sınıf sayısı − 1 |
| Yeni veriye uygulanabilir mi? | Evet (`transform`) | Hayır | Evet (`transform`) |
| Hız | Hızlı | Yavaş (büyük veri) | Hızlı |
| Tipik kullanım | Genel boyut indirgeme, ön işleme | Görselleştirme / EDA | Sınıflandırma öncesi boyut indirgeme |

**Pratik kural:**
- Veriyi **anlamak/görselleştirmek** istiyorsan → **t-SNE**
- Modeli **hızlandırmak / gürültüyü azaltmak** istiyorsan → **PCA**
- Elde **etiket varsa ve sınıflandırma** hedefliyorsan → **LDA**

## Veri Seti Üzerindeki Genel Sonuç

Her üç yöntem de UCI HAR verisinde dinamik (yürüme türleri) ve statik (oturma/ayakta durma/yatma) aktiviteleri
büyük ölçüde ayırabiliyor. En net sınıf ayrımını **LDA** (etiket kullandığı için), en kompakt/estetik kümelenmeyi
**t-SNE**, en hızlı ve genellenebilir gösterimi ise **PCA** sağlıyor. Detaylar için ilgili alt klasörlerdeki
konu anlatımı ve uygulama dosyalarına bakın.
