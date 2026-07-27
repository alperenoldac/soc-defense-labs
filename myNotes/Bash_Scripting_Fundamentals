## Bash ve Çalışma Ortamı Temelleri
*   **Bash Nedir?**: "Bourne Again Shell" kısaltmasıdır. Linux sistemlerinde komut satırı otomasyonu için en yaygın kullanılan betik (script) dilidir.
*   **Shebang (`#!/bin/bash`)**: Script dosyasının en üst satırına (1. satır) yazılır. İşletim sistemine bu dosyanın doğrudan Bash yorumlayıcısı ile çalıştırılması gerektiğini söyler.
*   **Vim Editör Modları**:
    *   **`i` (Insert)**: İmlecin tam bulunduğu karakterden yazmaya başlar.
    *   **`a` (Append)**: İmlecin bir karakter sonrasından yazmaya başlar.
    *   **`:wq`**: Kaydet ve çık (Write & Quit).
    *   **`:q!`**: Yapılan değişiklikleri yok sayarak zorla çık.

## İzinler ve Temel Komutlar
*   **`chmod u+x script.sh`**: Yazılan betiğe çalıştırılabilme (executable) yetkisi verir (`u`: user/owner, `x`: execute). Bu yetki verilmeden betikler çalışmaz.
*   **`echo`**: Terminale veya bir dosyaya belirtilen metni yazdırır. 
    *   *Not:* `echo -n` kullanımı, alt satıra geçme (newline) karakterini iptal eder.
*   **`cat`**: Bir dosyanın tam içeriğini terminalde okumak/yazdırmak için kullanılır.

## Değişkenler ve Argümanlar (Variables & Arguments)
*   **Değişken Tanımlama**: Eşittir işaretinin etrafında boşluk bırakılmadan tanımlanır (Örn: `first_name="Alperen"`).
*   **Değişkeni Çağırma**: Başına `$` işareti konularak çağrılır (Örn: `echo $first_name`). Güvenli kullanım için `${first_name}` veya küçük harfe zorlamak için `${1,,}` gibi parametre genişletmeleri yapılabilir.
*   **Kullanıcıdan Girdi Alma (`read`)**: Betik çalışırken kullanıcıdan interaktif olarak veri almak için kullanılır.
*   **Positional Arguments (Konumsal Argümanlar)**: Script çalıştırılırken dışarıdan verilen değerlerdir. `$1`, `$2` şeklinde çağrılır. 
    *   Örn: `./script.sh Alperen` komutunda `$1` değeri "Alperen" olur. `$0` ise scriptin kendi dosya adıdır.

## Yönlendirmeler ve Piping (Redirection & Pipes)
*   **`|` (Pipe)**: Bir komutun çıktısını (output), bir sonraki komutun içine girdi (input) olarak fırlatır (Örn: `ls -l | grep bash`).
*   **`>` (Output Redirect)**: Çıktıyı dosyaya yazar. Dosya daha önceden varsa içeriğini tamamen **siler ve üstüne yazar.**
*   **`>>` (Append Redirect)**: Çıktıyı dosyanın sonuna **ekler**, eski veriyi korur. Loglama işlemleri için idealdir.
*   **`<` (Input Redirect)**: Bir dosyanın içeriğini komuta girdi olarak besler.
*   **`<< EOF` (Here Document)**: Terminal üzerinden çok satırlı (multi-line) metin girmek için kullanılır. Belirlenen sınır kelimesi (EOF) tekrar yazılana kadar veriyi alır.
*   **`<<<` (Here String)**: Tek satırlık bir metni/string'i değişkene ihtiyaç duymadan doğrudan komuta besler (Örn: `wc -w <<< "Hello there"`).

## Kontrol Yapıları (Control Structures)
*   **Test İfadeleri (`[ ]`)**: Koşulları test eder. Köşeli parantezlerin içinde **başta ve sonda boşluk bırakılması zorunludur!** (Örn: `[ "$1" = "admin" ]`).
*   **Exit Status (`$?`)**: Son çalışan komutun başarı durumunu gösterir. (0 = Başarılı, 1 = Hatalı).
*   **If-Elif-Else Yapısı**:
    *   `if [ koşul ]; then` ile başlar.
    *   `elif [ koşul ]; then` ile alternatif/ekstra koşullar eklenir.
    *   `else` ile hiçbir koşul uymazsa yapılacaklar belirlenir.
    *   `fi` ile if bloğu tamamen kapatılır.
*   **Case Yapısı**: Çoklu durum kontrollerinde `if-else` yerine kullanılan daha temiz yapıdır. 
    *   Seçenekler `|` (pipe) işaretiyle yan yana çoğaltılabilir (Örn: `admin | root)` ). 
    *   Catch-all (varsayılan) durum `*)` ile belirtilir.
    *   `esac` ile kapatılır.

## Diziler ve Döngüler (Arrays & Loops)
*   **Dizi Tanımlama**: `liste=(1 2 3 4)` (Elemanlar virgülle değil, **boşlukla** ayrılır).
*   **Diziyi Okuma**: 
    *   Tüm elemanları okumak için: `${liste[@]}`
    *   Spesifik eleman (0'dan başlar): `${liste[0]}`
*   **For Döngüsü**: Bir liste/dizi içindeki elemanları tek tek işler.
    *   *Kullanım:* `for item in ${liste[@]}; do echo $item; done`

## Fonksiyonlar (Functions)
*   Script içinde tekrar eden kodları paketlemeyi ve modüler hale getirmeyi sağlar.
*   **Tanımlama**: `fonksiyon_adi() { komutlar }`
*   **`local` Değişkenler**: Bir fonksiyon içindeki değişkenlerin scriptin genelini (global) bozmasını engellemek için, fonksiyon içinde değişken tanımlarken başına mutlaka `local` yazılmalıdır (Örn: `local up=$(uptime)`).

## İleri Seviye Metin Manipülasyonu (awk & sed)
*   **`awk`**: Metinleri veya komut çıktılarını belirli ayırıcılara (boşluk, virgül vb.) göre bölüp, spesifik sütunları yazdırmak için kullanılır. 
    *   Örn: `awk '{print $1}'` sadece ilk sütunu/kelimeyi yazdırır. Virgülle ayrılmış CSV dosyalarında ayırıcı belirtmek için `-F,` bayrağı kullanılır.
*   **`sed` (Stream Editor)**: Metin içerisindeki değerleri aramak ve değiştirmek için (substitute) kullanılır. 
    *   Örn: `sed 's/eski_kelime/yeni_kelime/g' dosya.txt` (Sondaki `g` harfi "global" anlamına gelir ve dosyadaki tüm eşleşmeleri değiştirir). 
    *   `-i` (in-place) bayrağı, değişikliği sadece ekrana basmakla kalmaz, orijinal dosyaya kalıcı olarak kaydeder.
