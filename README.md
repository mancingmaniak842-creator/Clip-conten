# Termux AI Video Creator 🤖🎬

Skrip otomatis untuk menemukan momen viral dalam video YouTube panjang dan mengubahnya menjadi beberapa klip video pendek (Shorts/TikTok) secara otomatis. Semua proses berjalan di Termux dan ditenagai oleh Google Gemini.

Proyek ini dirancang untuk content creator yang ingin menghemat waktu dengan mengotomatiskan proses "mencari klip" dari streaming atau video berdurasi panjang.

## Fitur Unggulan
- **Analisis AI**: Menggunakan Google Gemini untuk secara otomatis mendeteksi **2 momen terbaik** yang paling menarik dalam sebuah video.
- **Pemotongan Otomatis**: Memotong segmen video berdasarkan waktu yang direkomendasikan AI dengan durasi fleksibel (15 detik - 1 menit).
- **Layout Cerdas**: Membuat layout video vertikal (9:16) dengan deteksi wajah untuk menempatkan streamer di bagian atas dan gameplay di bagian bawah.
- **100% Berjalan di Termux**: Didesain khusus untuk berjalan di lingkungan Android melalui Termux tanpa perlu PC.

---
## Cara Instalasi
Proses instalasi dibuat semudah mungkin dengan satu skrip.

1.  **Clone Repositori**:
    Jalankan perintah ini di Termux untuk mengunduh seluruh proyek:
    ```bash
    git clone [https://github.com/USERNAME/REPO_NAME.git](https://github.com/USERNAME/REPO_NAME.git)
    ```
    *(Ganti `USERNAME` dan `REPO_NAME` dengan milik Anda)*

2.  **Jalankan Skrip Instalasi**:
    Masuk ke direktori proyek dan jalankan skrip instalasi. Skrip ini akan menginstal semua dependensi dan meminta API Key Gemini Anda.
    ```bash
    cd REPO_NAME
    chmod +x install.sh
    ./install.sh
    ```
    Ikuti petunjuk di layar untuk menempelkan API Key Anda.

3.  **Restart Termux**:
    Setelah instalasi selesai, **tutup dan buka kembali** aplikasi Termux Anda. Ini penting untuk mengaktifkan API Key.

---
## Cara Penggunaan
Setelah instalasi berhasil, penggunaan skrip sangat sederhana.

1.  **Masuk ke Direktori Proyek**:
    ```bash
    cd REPO_NAME
    ```
2.  **Jalankan Skrip**:
    Jalankan skrip utama dengan link YouTube sebagai argumen.
    ```bash
    ./stream_crop_AI.sh '[https://www.youtube.com/watch?v=xxxxxxxx](https://www.youtube.com/watch?v=xxxxxxxx)'
    ```

Video hasil akhir akan diproses satu per satu dan disimpan di folder `Download/StreamCutsAI` di penyimpanan internal ponsel Anda.
