# 🌲 Isolation Forest — Kredi Kartı Dolandırıcılığı Tespiti

**Isolation Forest**, anormal noktaları **erken izole etme** prensibine dayanan bir anomali tespit algoritmasıdır.
Fikir şudur: **Anormal noktalar azdır ve diğerlerinden uzak durur** → rastgele bölmelerle çabuk yalnız kalırlar.

---

### 🧠 Temel Sezgi

Bir ormanda rastgele çizgiler çektiğini düşün:
- **Normal nokta** → kalabalık bölgede, izole edilmesi çok bölme gerektirir (derin ağaç)
- **Anormal nokta** → ıssız bölgede, az bölmeyle hemen izole edilir (sığ ağaç)

```
Normal:   ●●●●●●●●   → derin ağaç (izole etmek zor)
Anormal:  ●          → sığ ağaç  (izole etmek kolay)
```

---

### 📌 Veri Seti

**Credit Card Fraud Detection** (Kaggle) — Avrupalı kart sahiplerinin 2013 yılındaki işlemleri.
- 284.807 işlem, sadece 492 tanesi dolandırıcılık (%0.17)
- Özellikler `V1..V28` PCA ile dönüştürülmüş (gizlilik nedeniyle), `Amount` işlem tutarı
- `Class`: 0 = normal işlem, 1 = dolandırıcılık

> `creditcard.csv` dosyasını `../data/` klasörüne yerleştirin (bkz. `data/README.md`): https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud

---

## 📦 1. Kütüphanelerin İçe Aktarılması

---

## 🗂️ 2. Veri Setinin Yüklenmesi

Gerçek dünya senaryosu: **kredi kartı işlem kayıtları**
- Eğitim: yalnızca normal (dolandırıcılık olmayan) işlemler
- Test: normal + dolandırıcılık işlemleri (karışık)

---

## ✂️ 3. Eğitim / Test Ayrımı

Isolation Forest yalnızca **normal** verilerle eğitilecek.
Test setine hem kalan normal işlemler hem de **tüm dolandırıcılık** kayıtları eklenecek.

---

## ⚖️ 4. Özellik Ölçekleme

`StandardScaler`: her özelliği **ortalama=0, standart sapma=1** yaparak ölçekler.

> **Not:** Isolation Forest ağaç tabanlı olduğundan ölçeklemeye One-Class SVM kadar duyarlı değildir.
> Yine de tutarlılık ve iyi pratik için ölçekleme yapıyoruz.

---

## 📊 5. Ham Veri Görselleştirmesi

30 boyutlu veriyi görebilmek için **PCA** ile 2 boyuta indirgiyoruz (sadece görselleştirme amacıyla).

---

## 🌲 6. Isolation Forest — Algoritma Mantığı

### Nasıl Çalışır?

1. **Rastgele Bölme Ağacı (iTrees)** oluşturur:
   - Rastgele bir özellik seç
   - O özelliğin min–max aralığında rastgele bir eşik değeri seç
   - Veriyi ikiye böl, derinleştir

2. **İzolasyon Derinliği** ölçülür:
   - Bir nokta kaç adımda yalnız kalıyor? → **Anomali Skoru**
   - Az adım = sığ ağaç = **anomali**
   - Çok adım = derin ağaç = **normal**

3. **Orman** = `n_estimators` adet iTrees'in ortalaması

| Hiperparametre | Açıklama | Tipik Değer |
|---|---|---|
| `n_estimators` | Ağaç sayısı | 100–200 |
| `contamination` | Beklenen anomali oranı | 0.001–0.01 (nadir dolandırıcılık) |
| `max_samples` | Her ağaç için örneklem sayısı | `'auto'` = min(256, n) |
| `max_features` | Her bölmede kullanılan özellik sayısı | 1.0 (tümü) |

---

## 🏋️ 7. Modeli Eğitme

> One-Class SVM gibi, Isolation Forest da **yalnızca normal veriyle** eğitilir.
> Etiket `(y)` verilmez → **gözetimsiz (unsupervised)** öğrenme.

---

## 🔮 8. Test Verisi Üzerinde Tahmin ve Anomali Skorları

Isolation Forest iki tür çıktı üretir:
- `predict()` → ikili karar: **+1** (normal) veya **-1** (anomali)
- `score_samples()` → sürekli anomali skoru (düşük = daha anormal)

---

## 📈 9. Anomali Skorlarının Dağılımı

Normal ve dolandırıcılık işlemlerinin skor dağılımlarını karşılaştıralım.
İdeal modelde bu iki dağılım **belirgin şekilde ayrışır**.

---

## 🗺️ 10. PCA(2B) Uzayında Karar Sınırı ve Tespit Sonuçları

Gerçek model 30 boyutlu uzayda çalışır; karar yüzeyini görebilmek için **yalnızca görselleştirme amacıyla**
aynı mimaride ikinci bir Isolation Forest, PCA ile indirgenmiş 2 boyutlu veri üzerinde eğitilir.

---

## 🔬 11. Contamination Parametresinin Etkisi

`contamination`: verideki beklenen anomali oranı tahmini.
Bu değer karar eşiğini (threshold) doğrudan etkiler:
- Çok düşük → az şey anomali sayılır → yüksek FN riski
- Çok yüksek → çok şey anomali sayılır → yüksek FP riski

---

## 🌲 12. Isolation Forest vs One-Class SVM Karşılaştırması

One-Class SVM büyük veri setinde çok yavaş olduğu için karşılaştırmayı küçük bir örneklem üzerinde yapıyoruz.

---

## 📋 13. Özet ve Sonuçlar

---

### 🧠 Isolation Forest'in Çalışma Mantığı

```
Normal işlem:        ●●●●●●●   → çok bölme gerekli → derin ağaç → yüksek skor → inlier  (+1)
Dolandırıcılık işlemi: ●        → az bölme yeterli  → sığ ağaç  → düşük skor → outlier (-1)
```

### ⚖️ One-Class SVM vs Isolation Forest

| Özellik | One-Class SVM | Isolation Forest |
|---|---|---|
| **Yaklaşım** | Kernel tabanlı sınır | Ağaç tabanlı izolasyon |
| **Hız** | Yavaş (büyük veri) | Hızlı (lineer ölçeklenir) |
| **Ölçekleme** | Zorunlu | Önerilir |
| **Çok küme** | Zor | Kolay |
| **Anomali skoru** | decision_function | score_samples |
| **Ana parametre** | `nu`, `gamma` | `contamination`, `n_estimators` |

### ✅ Isolation Forest'in Avantajları
- **Büyük veri** ile ölçeklenir (O(n log n)) — 284.807 satırlık veri saniyeler içinde eğitildi
- **Çok sayıda küme** içeren veriyle iyi çalışır
- Anomali oranı bilinmiyorsa `contamination='auto'` kullanılabilir
- Paralel eğitim (`n_jobs=-1`) desteği var

### ⚠️ Sınırlamalar
- Aşırı dengesiz veride (%0.17 dolandırıcılık) düşük `contamination` seçimi kritik önem taşır
- "Küme anomalileri" (birlikte gelen anormal gruplar) zor tespit edilir
- `contamination` seçimi domain bilgisi gerektirir
