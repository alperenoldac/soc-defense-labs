
# 📦 Linux Package Management (Paket Yönetimi)

**Bağlantılar:** [[Linux Fundamentals]], [[Security Operations (SecOps)]]
**Kaynak:** NetworkChuck - Linux Package Management (27 min)

## 🧠 Temel Kavramlar
Linux'ta program kurmak Windows'taki gibi `.exe` indirip ileri-ileri demekten farklıdır. **Package Manager (Paket Yöneticisi)**, işletim sisteminin "App Store"udur. Bağımlılıkları (dependencies) otomatik çözer, güncellemeleri takip eder ve yazılımları güvenli bir şekilde merkezi depolardan (Repositories) çeker.

- **Package (Paket):** Derlenmiş yazılım, konfigürasyon dosyaları ve bağımlılık listesini içeren arşiv dosyası (örn. Debian/Ubuntu için `.deb`, RedHat için `.rpm`).
- **Repository (Repo):** Paketlerin barındırıldığı uzak sunucular. Kaynak listesi genellikle `/etc/apt/sources.list` içinde veya `/etc/apt/sources.list.d/` dizininde tutulur.

## 🛠️ APT (Advanced Package Tool) Komutları
Debian ve Ubuntu tabanlı sistemlerde (Kali, Parrot gibi siber güvenlik dağıtımları dahil) en çok kullanılan paket yöneticisi `apt`'dir. 

*Not: Sistem çapında değişiklik yaptığımız için bu komutlar `sudo` yetkisi gerektirir.*

### 1. Sistem Güncelleme (En Kritik Adım)
Herhangi bir şey kurmadan önce mutlaka lokal paket indeksini güncellemek gerekir.

> [!warning] Bilgi
> Sadece repolardaki güncel paket listesini çeker (İndirme/Kurma yapmaz)

`sudo apt update`

> [!warning] Bilgi
> İndirilen listeye göre sistemdeki eski paketleri yeni versiyonlarına yükseltir

`sudo apt upgrade`

*💡 SecOps Notu: Bir sunucuya sızma testi veya denetim yapmadan önce (ya da kendi savunma ortamını kurarken) sistemin güncel (`update` & `upgrade`) olduğundan emin olmak, bilinen zafiyetleri (CVE) kapatmanın ilk adımıdır.*

### 2. Paket Kurma ve Arama

> [!info] Bilgi
> İsimle paket arama (örn: nmap)

`apt search nmap`

> [!info] Bilgi
> Belirli bir paketi kurma

`sudo apt install nmap`

> [!info] Bilgi
> Birden fazla paketi aynı anda kurma

`sudo apt install nmap wireshark tcpdump`


### 3. Paket Silme ve Temizlik

> [!info] Bilgi
> Paketi siler ama konfigürasyon dosyalarını sistemde bırakır

`sudo apt remove nmap`

> [!info] Bilgi
> Paketi VE tüm konfigürasyon dosyalarını tamamen siler (Sıfırdan kurulum yapmak isteniyorsa ideal)

`sudo apt purge nmap`

> [!info] Bilgi
> Artık kullanılmayan, diğer paketlerin bağımlılığı olarak inmiş ama boşa çıkmış paketleri temizler

`sudo apt autoremove`


## 📦 DPKG: Lokal Paket Kurulumu
Bazen araçlar resmi repolarda olmaz ve doğrudan `.deb` dosyası olarak (örneğin GitHub'dan) indirmen gerekir. Bu durumda `apt` yerine doğrudan `dpkg` kullanılır.

> [!info] Bilgi
> İndirilen bir .deb dosyasını kurma

`sudo dpkg -i indirilen_arac_isim.deb`

> [!info] Bilgi
> Paketi silme

`sudo dpkg -r paket_ismi`

*(Eğer dpkg ile kurarken bağımlılık hatası alırsan, hemen ardından `sudo apt --fix-broken install` çalıştırarak eksikleri internetten çekebilirsin.)*

## 🛡️ Güvenlik ve Sistem Denetimi Perspektifi
- **Neden Önemli?:** Siber güvenlikte (özellikle savunma ve analiz tarafında) sistemde hangi paketlerin kurulu olduğunu bilmek hayati önem taşır. Gereksiz kurulan her paket, potansiyel bir saldırı yüzeyi (attack surface) yaratır.
- **Auditing (Denetim):** Sistemde kurulu tüm paketleri listelemek için `apt list --installed` veya `dpkg -l` komutları kullanılabilir. Bu komutlar, yazacağın bash scriptleri (örn: sistem denetim araçları) için harika birer veri kaynağıdır.