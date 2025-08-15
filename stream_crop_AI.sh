#!/data/data/com.termux/files/usr/bin/bash

# Dapatkan path absolut dari direktori skrip ini, agar bisa dijalankan dari mana saja
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SAVE_DIR="/storage/emulated/0/Download/StreamCutsAI"

# Minta izin akses penyimpanan internal
termux-setup-storage
mkdir -p "$SAVE_DIR"

if [ -z "$1" ]; then
    echo "❌ Error: Link YouTube tidak diberikan."
    echo "Penggunaan: ./stream_crop_AI.sh 'https://www.youtube.com/'"
    exit 1
fi
url=$1

echo "🧠 [Langkah 1/4] Menganalisis video dengan AI untuk menemukan 2 momen viral..."
moments_json=$(python3 "$SCRIPT_DIR/find_moments.py" "$url")
if [ -z "$moments_json" ] || ! echo "$moments_json" | jq . > /dev/null 2>&1; then
    echo "❌ Gagal mendapatkan momen viral dari AI. Pastikan video memiliki subtitle (English/Indonesia) dan API Key Anda benar."
    exit 1
fi

clip_total=$(echo "$moments_json" | jq length)
echo "✅ AI menemukan $clip_total momen. Memulai proses..."
title=$(yt-dlp --get-title "$url" | tr " " "_" | tr -cd "[:alnum:]_")
clip_count=0

echo "$moments_json" | jq -c '.[]' | while read -r moment; do
    clip_count=$((clip_count+1))
    start_time=$(echo "$moment" | jq -r .start_time)
    end_time=$(echo "$moment" | jq -r .end_time)
    
    echo ""
    echo "--- Memproses Klip $clip_count dari $clip_total: $start_time -> $end_time ---"
    
    filename="${title}_AI_Cut_${clip_count}.mp4"
    start_sec=$(date -u -d "1970-01-01 $start_time" +"%s")
    end_sec=$(date -u -d "1970-01-01 $end_time" +"%s")
    duration=$((end_sec - start_sec))
    
    if [ "$duration" -le 0 ]; then
        echo "⚠️ Durasi tidak valid ($duration detik), melewati klip ini."
        continue
    fi

    echo "📥 [Langkah 2/4] Mendownload dan memotong segmen..."
    yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" -o - "$url" | \
    ffmpeg -ss "$start_time" -t "$duration" -i pipe:0 -c copy "$SCRIPT_DIR/temp_cut_ai.mp4" -loglevel quiet

    echo "🎨 [Langkah 3/4] Menerapkan layout vertikal..."
    python3 "$SCRIPT_DIR/crop_streamer.py" "$SCRIPT_DIR/temp_cut_ai.mp4" "${SAVE_DIR}/${filename}"

    rm "$SCRIPT_DIR/temp_cut_ai.mp4"
    echo "✅ [Langkah 4/4] Klip $clip_count disimpan di: ${SAVE_DIR}/${filename}"
done

echo ""
echo "🎉 Semua proses selesai. Cek folder Download/StreamCutsAI Anda!"
