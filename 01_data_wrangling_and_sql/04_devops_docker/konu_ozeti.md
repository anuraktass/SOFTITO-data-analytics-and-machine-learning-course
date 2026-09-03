# Docker A'dan Z'ye Rehberi — Konu Özeti

## Docker Nedir?
Docker, uygulamaları **konteynerler** içinde paketleyip dağıtmayı sağlayan açık
kaynak bir platformdur. Bir konteyner, uygulamanın çalışması için gerekli tüm
bağımlılıkları (kütüphaneler, diller, sistem araçları) içinde barındırır — "benim
bilgisayarımda çalışıyordu" sorununu ortadan kaldırır.

**Docker vs Sanal Makine (VM):** VM'ler kendi işletim sistemini taşır (ağır, yavaş
başlar); Docker konteynerleri host'un çekirdeğini paylaşır (hafif, saniyeler içinde
başlar).

## Neden Docker kullanılır?
Dev/test/üretim ortamlarında aynı ortam garantisi; Linux/Windows/Mac/bulutta
sorunsuz çalışma; binlerce konteynerin kolay yönetimi; uygulamaların birbirinden
izolasyonu; verimli kaynak kullanımı; hızlanan geliştirme/dağıtım süreçleri.

## Temel kavramlar
- **Image (İmaj):** uygulamayı çalıştırmak için gereken her şeyi içeren
  okuma-yazma korumalı şablon (katmanlar/layers halinde organize edilir).
- **Container (Konteyner):** image'ın çalışan örneği; hafif, izole,
  çalıştırılabilir bir pakettir. Aynı image'dan birden çok container çalıştırılabilir.
- **Registry:** image'ların depolandığı yer (Docker Hub en popüler public registry).
- **Dockerfile:** image oluşturmak için adım adım talimatlar içeren metin dosyası.
- **Docker Daemon:** arka planda çalışan, image build eden ve container yöneten servis.

## Temel komutlar (özet)
```bash
docker pull <image>          # image indir
docker images                # yerel image'ları listele
docker run -d -p 8080:80 nginx   # container çalıştır (arka planda, port eşle)
docker ps                    # çalışan container'ları listele
docker exec -it <id> bash    # container içine gir
docker cp dosya <id>:/hedef  # dosya kopyala
docker stop/start/rm <id>    # container yaşam döngüsü yönetimi
```

## Volume kullanımı
Container silindikten sonra da verinin kalması için **volume** kullanılır:
`docker run -v veri_klasoru:/app/data image_adi`

## Dockerfile — Image oluşturma
Temel komutlar: `FROM`, `WORKDIR`, `COPY`, `RUN`, `EXPOSE`, `CMD`. **Multi-stage
Dockerfile**, build ve çalışma zamanı ortamlarını ayırarak nihai image boyutunu
küçültür (optimize). Build: `docker build -t isim:tag .`

## Docker Compose — çok konteynerli uygulamalar
Birden fazla container'ı tek bir YAML dosyasıyla (`docker-compose.yml`) tanımlayıp
çalıştırmayı sağlar; microservices mimarisi için idealdir.
```bash
docker compose up -d
docker compose down
docker compose logs -f
```

## Docker Best Practices (özet liste)
1. Küçük base image kullan (örn. `alpine`).
2. Katmanları optimize et (sık değişenleri sona koy → cache verimliliği).
3. `.dockerignore` dosyası kullan.
4. Mümkünse read-only file system.
5. Kaynak limitleri ayarla (CPU/RAM).
6. Non-root kullanıcı ile çalıştır.
7. Secret'ları (şifre, API key) image içine gömme, secret yönetimi kullan.
8. Healthcheck tanımla.
9. Semantik versiyonlama (`v1.2.3`) kullan, `latest` etiketine güvenme.
10. Kurumsal projelerde private registry kullan.

## Pratik örnekler (rehberde yer alan)
- Basit Python web uygulaması (Flask + Dockerfile)
- Node.js + MongoDB (docker-compose ile çok servisli kurulum)
- Nginx reverse proxy
- Temizleme komutları (`docker system prune`)
