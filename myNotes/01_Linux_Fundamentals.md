# Linux Fundamentals - Command Cheat Sheet

## Sistem ve Dizin Yönetimi
*   **`whoami`**: Aktif kullanıcının bilgisini döndürür.
*   **`pwd`** (print working directory): Bulunulan dizinin tam yolunu gösterir.
*   **`cd`** (change directory): Dizinler arası geçiş yapmayı sağlar.
*   **`ls`** (listing): Bulunulan dizindeki dosya ve klasörleri listeler.
*   **`cat`** (concatenate): Dosya içeriğini okur ve terminale yazdırır.
*   **`Ctrl + L`**: Terminal ekranını temizler.

## Arama İşlemleri
*   **`find`**: Dosya ve dizinleri aramak için kullanılır. İsim tam bilinmiyorsa joker karakter (`*`) ile kullanılabilir.
    *   *Örnek:* `find -name "*.txt"`
*   **`grep`**: Dosya içeriklerinde belirli bir metni veya düzenli ifadeyi (regex) arar.
    *   *Örnek:* Alt dizinlerde recursive (kapsamlı) arama için `grep -R` kullanılır.

## Operatörler ve Yönlendirme
*   **`&`**: Komutu arka planda çalıştırır, terminali meşgul etmez (Örn: büyük bir dosya kopyalanırken terminali kullanmaya devam etmek için).
*   **`&&`**: İki komutu birbirine bağlar (Örn: `command1 && command2`). Sadece ilk komut başarılı olursa ikinci komut çalışır.
*   **`>`** (Overwrite): Çıktıyı (output) bir dosyaya yönlendirir ve dosyanın üzerine yazar. 
    *   *Örnek:* `echo hey > welcome` (welcome dosyasının içine sadece "hey" yazar).
*   **`>>`** (Append): Çıktıyı mevcut dosyanın sonuna ekler, eski veriyi silmez. 
    *   *Örnek:* `echo hello >> welcome` (Önceki metni koruyarak "hello" ekler).
