# 🔍 One-Class SVM — Kredi Kartı Dolandırıcılığı Tespiti

**One-Class SVM**, yalnızca **normal (pozitif) veriyle** eğitilen bir anomali tespit algoritmasıdır.
Test sırasında, modelin öğrendiği "normal" bölgenin **dışına** düşen noktalar **anormal (outlier)** olarak işaretlenir.

---

### 📌 Veri Seti

**Credit Card Fraud Detection** (Kaggle) — Avrupalı kart sahiplerinin 2013 yılındaki işlemleri.
- 284.807 işlem, sadece 492 tanesi dolandırıcılık (%0.17)
- Özellikler `V1..V28` PCA ile dönüştürülmüş (gizlilik nedeniyle), `Amount` işlem tutarı
- `Class`: 0 = normal işlem, 1 = dolandırıcılık

> `creditcard.csv` dosyasını `../data/` klasörüne yerleştirin (bkz. `data/README.md`): https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud

> ⚠️ **Not:** One-Class SVM'in eğitim maliyeti veri boyutuyla ikinci/üçüncü dereceden artar.
> Bu yüzden 284.807 satırın tamamı yerine **dengeli bir örneklem** üzerinde çalışacağız.

---

## 📦 1. Kütüphanelerin İçe Aktarılması

---

## 🗂️ 2. Veri Setinin Yüklenmesi

Gerçek dünya senaryosu: **kredi kartı işlem kayıtları**
- Eğitim verisi → yalnızca **normal** işlemler
- Test verisi → normal + dolandırıcılık işlemleri

---

## ✂️ 3. Örnekleme ve Eğitim / Test Ayrımı

One-Class SVM'in hesaplama maliyeti nedeniyle normal işlemlerden **4.000 örneklik** bir alt küme alıyoruz.
Dolandırıcılık işlemlerinin tamamı (492 kayıt) zaten az sayıda olduğundan **tümü** test setine dahil edilir.

---

## ⚖️ 4. Özellik Ölçekleme (Feature Scaling)

SVM, özellikler arasındaki **ölçek farklılıklarına** çok duyarlıdır.
`StandardScaler`: her özelliği **ortalama=0, standart sapma=1** olacak şekilde dönüştürür.

> ⚠️ **Kritik Kural**: Scaler **yalnızca eğitim verisiyle** fit edilir.
> Test verisi aynı parametrelerle sadece **transform** edilir (data leakage önlenir).

---

## 🤖 5. Model Tanımı ve Hiperparametreler

| Parametre | Açıklama | Örnek Değer |
|-----------|----------|---------|
| `kernel` | Veriyi yüksek boyuta taşıyan çekirdek fonksiyonu | `'rbf'` (en yaygın) |
| `nu` | **Beklenen anomali oranı** ve destek vektörü üst sınırı `(0,1]` | `0.05` |
| `gamma` | RBF çekirdeğinin genişliği; `'scale'` → `1/(n_features * X.var())` | `'scale'` |

---

## 🏋️ 6. Modeli Eğitme

> One-Class SVM, **yalnızca normal veriden** öğrenir.
> Hedef etiket (`y`) **verilmez** → bu bir **unsupervised (gözetimsiz)** öğrenme adımıdır.

---

## 🔮 7. Test Verisi Üzerinde Tahmin

---

## 📊 8. PCA(2B) Uzayında Karar Sınırı Görselleştirmesi

30 boyutlu veriyi görebilmek için **PCA** ile 2 boyuta indirgiyoruz.
Karar sınırını görebilmek adına aynı mimaride ikinci bir One-Class SVM,
**yalnızca görselleştirme amacıyla** PCA(2B) verisi üzerinde ayrıca eğitilir.

---

## 🔬 9. Nu Parametresinin Etkisi

`nu` değerini değiştirdiğimizde model nasıl davranır?
- **Küçük nu** → Sıkı sınır, az outlier kabul eder → Yüksek FN riski
- **Büyük nu** → Gevşek sınır, fazla outlier kabul eder → Yüksek FP riski

---

## 📈 10. Nu Karşılaştırma Grafiği

---

## 📋 11. Özet ve Sonuçlar

---

### 🎯 One-Class SVM'in Çalışma Mantığı

```
Eğitim:  Normal veri → [One-Class SVM] → Karar sınırı öğrenir
Test:    Yeni veri   → [Sınır içinde?] → Normal (+1) veya Dolandırıcılık (-1)
```

### ✅ Avantajlar
- Anormal veri **gerekmez** — gerçek hayatta çok değerli
- RBF çekirdeği sayesinde **doğrusal olmayan** sınırlar çizebilir
- `nu` ile anomali toleransı **ayarlanabilir**

### ⚠️ Sınırlamalar
- Yüksek boyutlu veride ve **büyük veri setlerinde** performans/hız düşer (bu yüzden örneklem alındı)
- `nu` ve `gamma` seçimi **deneyim gerektirir**
- Gerçek anomali oranı bilinmeden `nu` seçimi zor

### 🔧 Hiperparametre Rehberi
| Durum | Önerilen nu |
|-------|-------------|
| Anomali nadir (`<1%`) | 0.01 – 0.03 |
| Anomali az (`~5%`) | 0.05 – 0.10 |
| Anomali orta (`~15%`) | 0.10 – 0.20 |
