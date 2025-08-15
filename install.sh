#!/data/data/com.termux/files/usr/bin/bash

# ===================================================================
# TAHAP 1: INSTALASI DEPENDENSI (VERSI ANTI-GAGAL)
# ===================================================================
echo "🚀 Memulai Instalasi AI Streamer..."
echo "Proses ini akan mengunduh banyak paket dan mungkin memakan waktu lama."
pkg update -y && pkg upgrade -y
pkg install python python-pip ffmpeg yt-dlp wget git cmake ninja libjpeg-turbo clang patchelf jq rust -y
pip install --upgrade pip
pip install numpy opencv-python-headless google-generativeai

# ===================================================================
# TAHAP 2: SETUP API KEY
# ===================================================================
echo ""
echo "🔑 PERSIAPKAN GEMINI API KEY ANDA"
echo "Anda bisa mendapatkannya dari Google AI Studio."
read -s -p "Tempelkan API Key di sini (input tidak akan terlihat), lalu tekan Enter: " gemini_api_key

# Menambahkan key ke file konfigurasi .bashrc
export GOOGLE_API_KEY="$gemini_api_key"
echo "" >> ~/.bashrc
echo "# Google Gemini API Key ditambahkan oleh skrip instalasi" >> ~/.bashrc
echo "export GOOGLE_API_KEY=\"$gemini_api_key\"" >> ~/.bashrc
echo ""
echo "✅ API Key telah disimpan dengan aman."

# ===================================================================
# TAHAP 3: FINALISASI
# ===================================================================
chmod +x stream_crop_AI.sh
clear
echo "
✅✅✅ Instalasi Selesai! ✅✅✅
=================================================
PENTING: Harap tutup dan buka kembali aplikasi Termux Anda untuk mengaktifkan semua perubahan.

Setelah itu, Anda bisa menjalankan skrip sesuai petunjuk di README.md.
"
