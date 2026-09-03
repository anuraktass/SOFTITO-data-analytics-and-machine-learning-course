"""
ORNEK CALISMA: Excel/CSV Veri Analizi (pandas ile)
Konu: iki tabloyu birlestirme (JOIN/Merge), gruplama, basit KPI hesaplama
Calistirmadan once: pip install pandas openpyxl --break-system-packages
"""
import pandas as pd

# 1) Satış ve ürün verisini oku
satislar = pd.read_csv("veri_setleri/satis_veriler.csv")
urunler = pd.read_csv("veri_setleri/urun_veriler.csv")

print("--- Satış verisi ilk 3 satır ---")
print(satislar.head(3))

# 2) İki tabloyu ilişkilendirme (SQL'deki JOIN'in pandas karşılığı: merge)
birlesik = satislar.merge(urunler, on="UrunID", how="left")

# 3) Kategori bazında toplam ciro (GROUP BY benzeri)
kategori_cirosu = (
    birlesik.groupby("Kategori")["Toplam Tutar"]
    .sum()
    .sort_values(ascending=False)
)
print("\n--- Kategori bazında toplam ciro ---")
print(kategori_cirosu)

# 4) Basit bir KPI: ortalama sipariş tutarı
ortalama_siparis = satislar["Toplam Tutar"].mean()
print(f"\nOrtalama sipariş tutarı: {ortalama_siparis:.2f} TL")

# 5) En çok satış yapan temsilci (Satış Temsilcisi bazında toplam ciro)
temsilci_performansi = (
    satislar.groupby("Satış Temsilcisi")["Toplam Tutar"].sum().sort_values(ascending=False)
)
print("\n--- Temsilci bazında toplam ciro ---")
print(temsilci_performansi)

# 6) Basit bir ABC (Pareto) analizi: kümülatif yüzde
kumulatif = kategori_cirosu.cumsum() / kategori_cirosu.sum() * 100
print("\n--- Kümülatif ciro yüzdesi (Pareto) ---")
print(kumulatif)

# ALIŞTIRMA (kendin dene):
# a) student_data.xlsx dosyasını oku (pd.read_excel), sınıf bazında ders ortalamasını hesapla.
# b) saas_ileri.xlsx içindeki "Abonelikler" sayfasını okuyup ay bazında toplam MRR trendini çiz
#    (Abonelikler.groupby("YilAy")["MRR"].sum()).
