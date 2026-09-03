# Örnek Çalışma: PostgreSQL'i Docker ile Ayağa Kaldırmak

Bu alıştırma, Docker konusunu **01_veritabani_ve_sql/03_postgresql** konusuyla
birleştirir: kurulum yapmadan, Docker ile bir PostgreSQL veritabanı çalıştırıp
`finans_veritabani.sql` dosyasını içine yükleyeceğiz.

## 1) Tek komutla PostgreSQL çalıştır
```bash
docker run -d \
  --name pg_ornek \
  -e POSTGRES_PASSWORD=ornek123 \
  -e POSTGRES_DB=egitim_db \
  -p 5432:5432 \
  -v pg_veri:/var/lib/postgresql/data \
  postgres:16
```
- `-e` → ortam değişkenleri (şifre, veritabanı adı)
- `-p 5432:5432` → host:container port eşlemesi
- `-v pg_veri:/var/lib/postgresql/data` → veri kalıcılığı için volume

## 2) Container'ın çalıştığını doğrula
```bash
docker ps
```

## 3) Örnek şemayı container'ın içine kopyala ve çalıştır
```bash
docker cp ../../01_veritabani_ve_sql/05_ornek_veritabanlari/finans_veritabani.sql pg_ornek:/finans.sql
docker exec -it pg_ornek psql -U postgres -d egitim_db -f /finans.sql
```

## 4) İçeri girip sorgu çalıştır
```bash
docker exec -it pg_ornek psql -U postgres -d egitim_db
```
```sql
SELECT ad_soyad, aylık_gelir FROM musteriler ORDER BY aylık_gelir DESC LIMIT 5;
```

## 5) Basit bir Dockerfile ile kendi ortamını paketleme
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ornek_calisma.py .
CMD ["python", "ornek_calisma.py"]
```
Build & çalıştır:
```bash
docker build -t veri-analiz-ornegi .
docker run --rm veri-analiz-ornegi
```

## ALIŞTIRMA (kendin dene)
1. `docker-compose.yml` yazarak hem PostgreSQL hem de yukarıdaki Python analiz
   scriptini tek komutla (`docker compose up`) ayağa kaldır.
2. Container'ı sildiğinde volume sayesinde verinin kaybolmadığını doğrula:
   `docker rm -f pg_ornek` sonra aynı `docker run` komutunu tekrar çalıştır ve
   verinin hâlâ orada olduğunu kontrol et.
