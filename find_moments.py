import os, sys, json, subprocess, google.generativeai as genai

def get_video_transcript(url):
    try:
        command = [ "yt-dlp", "--write-auto-sub", "--sub-lang", "en,id", "--skip-download", url, "-o", "%(id)s" ]
        result = subprocess.run(command, capture_output=True, text=True, timeout=60)
        video_id = result.stdout.strip()
        
        transcript_file_en, transcript_file_id = f"{video_id}.en.vtt", f"{video_id}.id.vtt"
        
        transcript_file = None
        if os.path.exists(transcript_file_en): transcript_file = transcript_file_en
        elif os.path.exists(transcript_file_id): transcript_file = transcript_file_id
        else: return None

        with open(transcript_file, 'r', encoding='utf-8') as f: transcript = f.read()
        
        os.remove(transcript_file)
        return transcript
    except Exception:
        return None

def find_viral_moments(transcript):
    api_key = os.getenv('GOOGLE_API_KEY')
    if not api_key:
        print(json.dumps({"error": "API Key tidak ditemukan"})); sys.exit(1)
    
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel('gemini-1.5-flash')
    
    prompt = f"""
    Anda adalah editor video profesional. Analisis transkrip VTT berikut, temukan 2 momen terbaik yang paling menarik, lucu, atau viral.
    Untuk setiap momen, tentukan durasi idealnya antara 15 detik hingga 1 menit.
    Output Anda HARUS HANYA dalam format JSON array (sebuah list) berisi 2 objek. Setiap objek harus memiliki kunci "start_time" dan "end_time" dalam format "HH:MM:SS".
    Jangan tambahkan markdown atau penjelasan lain.
    Transkrip:
    {transcript}
    """
    
    try:
        response = model.generate_content(prompt)
        cleaned_response = response.text.strip().replace("```json", "").replace("```", "").strip()
        result = json.loads(cleaned_response)
        return result
    except Exception:
        return None

if __name__ == "__main__":
    if len(sys.argv) < 2: sys.exit(1)
    
    video_url = sys.argv[1]
    transcript_content = get_video_transcript(video_url)
    
    if transcript_content:
        moments = find_viral_moments(transcript_content)
        if moments:
            print(json.dumps(moments))
