# Linux Fundamentals Part 2 - Permissions & System Directories

## Ağ ve Yardımcı Komutlar
*   **`ssh` (Secure Shell):** Cihazlar arasındaki iletişimi kriptografi kullanarak şifrelenmiş formatta yapan protokoldür. Verilerin internet üzerindeki yolculuğunu güvenli hale getirir.
*   **`--help`**: Bir komutun nasıl kullanılacağını ve alabileceği parametreleri özetler.
*   **`man` (Manual):** Komutun çok daha detaylı, resmi kılavuzunu açar (Örn: `man ls`). `--help` komutunun yetersiz kaldığı durumlarda tam dokümantasyon sağlar.

## Dosya ve Dizin Yönetimi
*   **`touch`**: Yeni ve boş bir dosya oluşturur.
*   **`mkdir` (make directory):** Yeni bir klasör (dizin) oluşturur.
*   **`cp` (copy):** Dosya veya dizinleri kopyalar.
*   **`mv` (move):** Dosya veya dizinleri taşır (aynı zamanda yeniden isimlendirme için de kullanılır).
*   **`rm` (remove):** Dosya veya dizinleri siler.
*   **`file`**: Bir dosyanın türünü ve tanımını yapar (uzantısı olmasa bile içeriğine bakarak ne olduğunu anlar).
*   **`ls -a` (--all):** Gizli dosyaları (başında nokta olan dosyalar, örn: `.bashrc`) listelemeyi sağlar.
*   **`ls -lh`**: Dosyaları detaylı (long format) ve boyutlarını insanın okuyabileceği (human-readable - K, M, G) formatta listeler.

## Kullanıcı ve Yetki Yönetimi (Permissions)
*   **`su` (Substitute User):** Başka bir kullanıcı kimliğine geçiş sağlar.
    *   *Not:* `su -l user2` kullanımı, hem kimliği değiştirir hem de kullanıcının tam ortamını (home dizini vb.) yükleyerek temiz bir geçiş yapar.

**Dosya İzinleri (Numeric Format):**
İzinler `rwxrwxrwx` şeklinde 3 ana gruba ayrılır:
1.  **Owner (Sahip):** İlk 3 karakter.
2.  **Group (Grup):** Ortadaki 3 karakter.
3.  **Others (Diğerleri):** Son 3 karakter.

*Değerler (Octal):*
*   **`r` (read / okuma)** = 4
*   **`w` (write / yazma)** = 2
*   **`x` (execute / çalıştırma)** = 1

*Örnekler:*
*   `rwxr-xr-x` = **755** (Owner her şeyi yapabilir; diğerleri sadece okur ve çalıştırır).
*   `rwx------` = **700** (Sadece owner'ın tam yetkisi vardır, diğerleri hiçbir şey yapamaz).

## Kritik Sistem Dizinleri
*   **`/etc`**: Sistem genelindeki yapılandırma (configuration) ve ayar dosyalarının tutulduğu ana merkezdir.
*   **`/var`**: Sistem çalışırken boyutu sürekli değişen log dosyaları, veritabanları veya önbellek (cache) gibi verileri saklar.
*   **`/root`**: Sistemin en yetkili kullanıcısının (süper yöneticinin) izole edilmiş ana dizinidir.
*   **`/tmp`**: İşletim sisteminin ve programların geçici (temporary) dosyalarını sakladığı, RAM gibi çalışan ve yeniden başlatmada silinen klasördür.
