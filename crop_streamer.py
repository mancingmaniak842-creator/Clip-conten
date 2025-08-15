import cv2, numpy as np, sys, os

if len(sys.argv) < 3: sys.exit(1)
input_file, output_file = sys.argv[1], sys.argv[2]

# Path model dibuat relatif terhadap lokasi skrip input
base_dir = os.path.dirname(os.path.abspath(input_file))
model_path = os.path.join(base_dir, 'models', 'haarcascade_frontalface_default.xml')

if not os.path.exists(model_path):
    print(f"Error: Model file tidak ditemukan di {model_path}")
    sys.exit(1)

face_cascade = cv2.CascadeClassifier(model_path)
cap = cv2.VideoCapture(input_file)
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
fps = cap.get(cv2.CAP_PROP_FPS)
final_width, final_height = 1080, 1920
out = cv2.VideoWriter(os.path.join(base_dir, 'temp_output_cv.mp4'), fourcc, fps, (final_width, final_height))

while True:
    ret, frame = cap.read()
    if not ret: break
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.1, 5, minSize=(40, 40))
    if len(faces) > 0:
        (x, y, w, h) = sorted(faces, key=lambda f: f[2]*f[3], reverse=True)[0]
        center_x, center_y = x + w // 2, y + h // 2
        size = int(max(w, h) * 1.5)
        crop_x1, crop_y1 = max(0, center_x - size // 2), max(0, center_y - size // 2)
        face_crop = frame[crop_y1:crop_y1+size, crop_x1:crop_x1+size]
        top_row = cv2.resize(face_crop, (final_width, final_height // 2), interpolation=cv2.INTER_AREA)
    else:
        top_row = np.zeros((final_height // 2, final_width, 3), dtype=np.uint8)
    
    gameplay_crop = cv2.resize(frame, (final_width, final_height // 2), interpolation=cv2.INTER_AREA)
    combined_frame = np.vstack((top_row, gameplay_crop))
    out.write(combined_frame)

cap.release()
out.release()

os.system(f"ffmpeg -i {os.path.join(base_dir, 'temp_output_cv.mp4')} -vcodec libx264 -crf 23 -preset veryfast -y \"{output_file}\" > /dev/null 2>&1")
os.remove(os.path.join(base_dir, 'temp_output_cv.mp4'))
