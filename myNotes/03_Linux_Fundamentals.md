
# Linux Fundamentals Part 3

## 1. Terminal Metin Düzenleyicileri (Text Editors)
Sunucularda veya arayüzü (GUI) olmayan sistemlerde dosyaları terminal üzerinden düzenlemek için kullanılır.

- **nano:** Kullanımı en kolay başlangıç editörü.
  - Açmak için: `nano dosya.txt`
  - Kaydetmek için: `Ctrl + O` -> `Enter`
  - Çıkmak için: `Ctrl + X`
- **vim / vi:** Daha profesyonel, fare gerektirmeyen gelişmiş editör.
  - Yazma moduna geçmek için: `i` (Insert)
  - Moddan çıkmak için: `Esc`
  - Kaydedip çıkmak için: `:wq` -> `Enter`

## 2. Dosya İndirme (Downloading Files)
Hedef sisteme sızıldığında veya bir araç indirilmek istendiğinde terminal üzerinden dosya çekmek için kullanılır.

- **wget:** Belirtilen URL'deki dosyayı bulunduğun dizine indirir.
  - Kullanım: `wget https://ornek.com/arac.sh`

## 3. Süreç (Process) Yönetimi
Linux'ta çalışan her bir programa veya komuta "process" (süreç) denir ve her birinin bir PID (Process ID) numarası vardır.

- **ps:** Çalışan süreçleri listeler. Genellikle tüm detayları görmek için `ps aux` şeklinde kullanılır.
- **top:** Windows Görev Yöneticisi gibi sistem kaynaklarını (CPU/RAM) canlı olarak gösterir. Çıkmak için `q` tuşuna basılır.
- **kill:** Belirli bir süreci PID numarası ile sonlandırır.
  - Normal sonlandırma: `kill <PID>`
  - Zorla (Force) sonlandırma: `kill -9 <PID>`
- **Arka Planda Çalıştırma (&):** Bir komutun sonuna `&` eklersen, o işlem arka planda çalışır ve terminali kullanmaya devam edebilirsin.
- **fg:** Arka planda çalışan bir işlemi tekrar ön plana (foreground) getirir.

## 4. Görev Otomasyonu (Cron Jobs)
Sistemde belirli aralıklarla (örneğin her gece saat 3'te yedek alma) otomatik çalışması gereken işlemler `cron` ile ayarlanır.

- **crontab -e:** Cron görevlerini düzenlemek için cron dosyasını açar.
- **crontab -l:** Mevcut cron görevlerini listeler.
- Cron Zaman Formatı: `Dakika Saat Gün Ay Haftanın_Günü Komut`

## 5. Paket Yönetimi (Package Management)
Debian ve Ubuntu tabanlı Linux dağıtımlarında sisteme yeni bir araç veya yazılım kurmak için `apt` (Advanced Package Tool) kullanılır.

- **apt update:** Paket listelerini günceller (Sistemi güncellemez, sadece "yeni ne var" diye listeyi yeniler).
- **apt upgrade:** Yüklü olan paketleri yeni sürümlerine günceller.
- **apt install <paket_adi>:** Yeni bir araç kurar.
- **apt remove <paket_adi>:** Yüklü bir aracı siler.

## 6. Log Analizi ve /var/log Dizinleri
Sistemde olup biten her şey log (kayıt) dosyalarında tutulur. Siber güvenlikte olay müdahalesi (Incident Response) yaparken en çok incelenen yer burasıdır.

- **/var/log:** Tüm sistem loglarının tutulduğu ana dizindir.
- **/var/log/syslog** veya **/var/log/messages:** Genel sistem ve uygulama olayları burada bulunur.
- **/var/log/auth.log:** SSH giriş denemeleri, şifre hataları ve `sudo` kullanımları gibi tüm kimlik doğrulama işlemleri buraya kaydedilir. Brute-force saldırılarını tespit etmek için ilk bakılan yerdir.