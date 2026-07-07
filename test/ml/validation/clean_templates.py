from PIL import Image, ImageDraw
import numpy as np
import os

def clean_template(filename, polygon_points):
    path = os.path.join("assets/images", filename)
    if not os.path.exists(path):
        print(f"File not found: {path}")
        return
        
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    
    # Use numpy to overwrite pixels inside the polygon mask to fully transparent
    arr = np.array(img)
    
    # Draw binary mask using PIL
    mask_img = Image.new("L", (w, h), 0)
    draw = ImageDraw.Draw(mask_img)
    draw.polygon(polygon_points, fill=255)
    
    mask = np.array(mask_img)
    
    # Overwrite pixels where mask is 255 to transparent
    arr[mask == 255] = [0, 0, 0, 0]
    
    cleaned_img = Image.fromarray(arr)
    cleaned_img.save(path, "PNG")
    print(f"Successfully cleaned and saved: {filename}")

def main():
    # Define exact polygon clearing masks for the neck/mannequin areas
    # Coords are (x, y) relative to 1024x1024 template size
    
    # 1. Men Classic: Clear central neck down to the tie node (y=338)
    men_classic_poly = [
        (420, 0),
        (604, 0),
        (604, 305),
        (512, 342),
        (420, 305)
    ]
    clean_template("men_classic.png", men_classic_poly)
    
    # 2. Men Modern: Clear central neck down to the tie node (y=338)
    men_modern_poly = [
        (420, 0),
        (604, 0),
        (604, 305),
        (512, 342),
        (420, 305)
    ]
    clean_template("men_modern.png", men_modern_poly)
    
    # 3. Women Classic: Clear neck area down to blazer lapels (y=470)
    women_classic_poly = [
        (410, 0),
        (614, 0),
        (614, 420),
        (512, 475),
        (410, 420)
    ]
    clean_template("women_classic.png", women_classic_poly)
    
    # 4. Women Modern: Clear deep V-neck down to blazer connection (y=728)
    # The V-neck starts at y=680 and ends around y=730. 
    # We clear a wide triangle to clean up any mannequin artifacts on the blazer inner edge.
    women_modern_poly = [
        (370, 0),
        (654, 0),
        (654, 660),
        (512, 735),
        (370, 660)
    ]
    clean_template("women_modern.png", women_modern_poly)

if __name__ == "__main__":
    main()
