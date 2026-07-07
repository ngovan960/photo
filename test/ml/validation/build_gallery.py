import os
import re

def build_gallery():
    img_dir = "img_test/suit_composites"
    files = os.listdir(img_dir)
    
    # Group files by subject
    subjects = {
        "photo-2_female_classic": [],
        "male_suited_classic": [],
        "female_suited_modern": []
    }
    
    pattern = re.compile(r"^(photo-2_female_classic|male_suited_classic|female_suited_modern)_s_([\d\.]+)_dy_(-?\d+)\.png$")
    
    for f in files:
        m = pattern.match(f)
        if m:
            sub, scale_str, dy_str = m.groups()
            subjects[sub].append({
                "file": f,
                "scale": float(scale_str),
                "dy": int(dy_str)
            })
            
    html = """<!DOCTYPE html>
<html>
<head>
  <title>Grid Search Sweep Gallery</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f0f2f5; margin: 20px; }
    h1 { color: #333; }
    .section { background: white; padding: 20px; margin-bottom: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .subject-title { color: #004AC6; font-size: 20px; border-bottom: 2px solid #004AC6; padding-bottom: 5px; margin-bottom: 20px; }
    .row-container { margin-bottom: 15px; }
    .row-title { font-weight: bold; font-size: 15px; margin-bottom: 8px; color: #555; }
    .grid { display: flex; flex-wrap: wrap; gap: 10px; }
    .card { border: 1px solid #ddd; border-radius: 4px; padding: 5px; text-align: center; background: #fafafa; width: 140px; }
    .card img { width: 100%; height: auto; display: block; border-radius: 2px; }
    .label { font-weight: bold; margin-top: 8px; font-size: 12px; color: #333; }
  </style>
</head>
<body>
  <h1>Suit Overlay Grid Search Sweep Gallery</h1>
"""

    for sub_name, items in subjects.items():
        if not items:
            continue
        html += f'<div class="section"><div class="subject-title">{sub_name}</div>'
        # Group by scale
        scales = sorted(list(set(item["scale"] for item in items)))
        for scale in scales:
            html += f'<div class="row-container"><div class="row-title">Scale: {scale:.2f}</div><div class="grid">'
            # Get items for this scale, sorted by dy
            scale_items = sorted([item for item in items if item["scale"] == scale], key=lambda x: x["dy"])
            for item in scale_items:
                html += f'<div class="card"><img src="{img_dir}/{item["file"]}"><div class="label">dy: {item["dy"]}</div></div>'
            html += '</div></div>'
        html += '</div>'
        
    html += "</body>\n</html>"
    
    with open("sweep_gallery_grid.html", "w") as f:
        f.write(html)
    print("Gallery generated successfully!")

if __name__ == "__main__":
    build_gallery()
