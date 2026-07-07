import os
import sys
from rembg import remove
from PIL import Image

def main():
    output_dir = "/home/ngovan960/Documents/mimo/photo_id_app/assets/images"
    os.makedirs(output_dir, exist_ok=True)

    configs = [
        {
            "src": "/home/ngovan960/.gemini/antigravity/brain/a690adaf-0f80-4c66-b2b9-21e9568e82b1/men_classic_suit_1783430496149.png",
            "dest": "men_classic.png",
            "cutoff": 0.0,
            "collar_y_limit": 0.55
        },
        {
            "src": "/home/ngovan960/.gemini/antigravity/brain/a690adaf-0f80-4c66-b2b9-21e9568e82b1/men_modern_suit_1783430511790.png",
            "dest": "men_modern.png",
            "cutoff": 0.0,
            "collar_y_limit": 0.55
        },
        {
            "src": "/home/ngovan960/.gemini/antigravity/brain/a690adaf-0f80-4c66-b2b9-21e9568e82b1/women_classic_suit_1783430527649.png",
            "dest": "women_classic.png",
            "cutoff": 0.0,
            "collar_y_limit": 0.60
        },
        {
            "src": "/home/ngovan960/.gemini/antigravity/brain/a690adaf-0f80-4c66-b2b9-21e9568e82b1/women_modern_suit_1783430541417.png",
            "dest": "women_modern.png",
            "cutoff": 0.0,
            "collar_y_limit": 0.72
        }
    ]

    for conf in configs:
        src_path = conf["src"]
        dest_path = os.path.join(output_dir, conf["dest"])
        
        if not os.path.exists(src_path):
            print(f"Error: Source file {src_path} not found!")
            continue

        print(f"\nProcessing {src_path} -> {dest_path}...")
        
        # 1. Load image
        img = Image.open(src_path)
        
        # 2. Remove background and restore dark jacket pixels
        print("Removing background using rembg...")
        nobg = remove(img).convert("RGBA")
        
        # Restore dark jacket pixels that rembg incorrectly made transparent
        raw_pixels = img.convert("RGB").load()
        nobg_pixels = nobg.load()
        width, height = nobg.size
        restored_count = 0
        for y in range(height):
            for x in range(width):
                r, g, b = raw_pixels[x, y]
                # If pixel is dark (jacket) and rembg made it transparent/semi-transparent
                if r < 160 and g < 160 and b < 160:
                    nobg_pixels[x, y] = (r, g, b, 255)
                    restored_count += 1
        print(f"Restored {restored_count} dark jacket pixels.")
        
        # 3. Mask neck/head skin tone
        pixels = nobg.load()
        
        cutoff_y = int(height * conf["cutoff"])
        collar_y = int(height * conf["collar_y_limit"])
        
        print(f"Masking head/neck (cutoff Y: {cutoff_y}, collar Y: {collar_y})...")
        for y in range(height):
            for x in range(width):
                if y < cutoff_y:
                    # Clear everything above the cutoff line
                    pixels[x, y] = (0, 0, 0, 0)
                elif y < collar_y:
                    # In the neck area, clear skin pixels (leaving the collar/shirt untouched)
                    r, g, b, a = pixels[x, y]
                    if a > 0:
                        # Skin color detection: high R, medium G, lower B
                        is_skin = (r > 120 and g > 80 and b > 60 and 
                                   r > g and g > b and 
                                   (r - g) > 15 and (g - b) > 10)
                        if is_skin:
                            pixels[x, y] = (0, 0, 0, 0)
        
        # Save output
        nobg.save(dest_path, "PNG")
        print(f"Successfully saved to {dest_path}")

    print("\nAll templates processed successfully!")

if __name__ == "__main__":
    main()
