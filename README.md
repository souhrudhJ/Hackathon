# Property Inspection – Core Pipeline

---
## 🚨 SECURITY ALERT
**Critical security issue detected in this repository's git history.**  
**📄 START HERE: [ACTION_REQUIRED.md](ACTION_REQUIRED.md)**

Exposed credentials must be revoked and git history must be cleaned.  
See [SUMMARY.md](SUMMARY.md) for complete details and cleanup instructions.

---

Upload **video** or **image** → frame extraction (for video) → defect detection and marking.

## Quick start

```bash
# Clone the repository
git clone https://github.com/souhrudhJ/Hackathon.git
cd Hackathon

# Create and activate virtual environment
python -m venv venv

# On Windows:
venv\Scripts\activate
# On Linux/Mac:
# source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the app
streamlit run app.py
```

Then open the URL (e.g. http://localhost:8501), upload a video (e.g. `Wall_Defect_Detection_YOLOv9/Wall_Defect.mp4`) or an image, and click **Run detection**.

## Configuration

### API Keys

The app uses Google Gemini Vision API for AI-powered defect detection. You'll need to:
1. Get a free API key from [Google AI Studio](https://aistudio.google.com/apikey)
2. Enter it in the sidebar when you run the app

For training custom models with `train.py`, you'll need a Roboflow API key:
```bash
# On Windows:
set ROBOFLOW_API_KEY=your_api_key_here

# On Linux/Mac:
export ROBOFLOW_API_KEY=your_api_key_here
```

Get your free Roboflow API key from [https://roboflow.com](https://roboflow.com)

## What’s included

- **`app.py`** – Streamlit UI: upload video/image, set frame interval and confidence, run detection, view annotated frames.
- **`detector.py`** – Core logic: load YOLO model, extract frames from video, run inference, draw bounding boxes and labels.
- **`config.py`** – Paths, defect class names (crack, water_seepage, mold, peeling_paint, stairstep_crack), and detection/interval settings.

## Model / weights

- **Default:** Uses Ultralytics `yolov8n.pt` (COCO classes). Good for testing the pipeline; labels will be generic objects, not defects.
- **Defect model:** Place a custom defect model at **`weights/best.pt`**. The app will use it automatically and show the 5 defect classes above.  
  To get defect-trained weights you can:
  - Run the training in **`Wall_Defect_Detection_YOLOv9/yolov9 (1).ipynb`** (e.g. on Colab), then export the best checkpoint to Ultralytics format and save as `weights/best.pt`, or  
  - Train a YOLOv8 model on the same 5 classes (e.g. with Ultralytics or Roboflow) and save the best weights as `weights/best.pt`.

## Sample video

You can use the demo video from the cloned repo:

- **`Wall_Defect_Detection_YOLOv9/Wall_Defect.mp4`**

Upload it in the app to test the full flow: frame extraction → detection → annotated frames.

## Pipeline summary

1. **Upload** – Video (mp4, avi, mov, webm) or image (jpg, png).
2. **Video:** Frames are extracted at the chosen interval (default 1 s); max frames is configurable.
3. **Detection** – Each frame (or the single image) is run through the YOLO model.
4. **Marking** – Bounding boxes and class + confidence are drawn on the frames; results are shown in the UI.

PDF report generation and other features are left for later; this is the core only.
