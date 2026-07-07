import os
import glob
from rembg import remove
from PIL import Image
import numpy as np

# Create output directory
output_dir = 'img_test/processed'
os.makedirs(output_dir, exist_ok=True)

# Standard specifications for Vietnam CCCD
TARGET_WIDTH_MM = 30
TARGET_HEIGHT_MM = 40
TARGET_DPI = 300

# Convert mm to pixels at 300 DPI
target_width = int(TARGET_WIDTH_MM / 25.4 * TARGET_DPI)   # 354
target_height = int(TARGET_HEIGHT_MM / 25.4 * TARGET_DPI) # 472
target_ratio = target_width / target_height

print("=== STARTING PROFESSIONAL BACKGROUND REMOVAL & CROP FOR VIETNAM CCCD ===")

# Process all files in img_test/ (excluding the processed/ subdirectory)
for filepath in glob.glob('img_test/*'):
    if not os.path.isfile(filepath):
        continue
    
    filename = os.path.basename(filepath)
    if filename.startswith('.'):
        continue
        
    # We will try to process all supported formats
    # Note: AVIF might fail if the Python Pillow package does not have an AVIF plugin
    # but we can try to decode it, and if it fails, catch the error.
    
    print(f"\nProcessing image: {filename}...")
    try:
        # Load image
        input_image = Image.open(filepath)
        print(f"  - Loaded. Resolution: {input_image.size[0]}x{input_image.size[1]} | Format: {input_image.format}")
        
        # 1. Remove background using U2-Net deep learning model
        print("  - Removing background...")
        rgba_image = remove(input_image)
        
        # 2. Composite with a pure white background
        print("  - Compositing with white background...")
        white_bg = Image.new("RGBA", rgba_image.size, (255, 255, 255, 255))
        white_bg.paste(rgba_image, mask=rgba_image)
        rgb_image = white_bg.convert("RGB")
        
        # 3. Crop to standard CCCD aspect ratio (3:4)
        print("  - Cropping to 3:4 aspect ratio...")
        orig_width, orig_height = rgb_image.size
        orig_ratio = orig_width / orig_height
        
        if orig_ratio > target_ratio:
            # Crop width
            crop_height = orig_height
            crop_width = int(orig_height * target_ratio)
            offset_x = (orig_width - crop_width) // 2
            offset_y = 0
        else:
            # Crop height
            crop_width = orig_width
            crop_height = int(orig_width / target_ratio)
            offset_x = 0
            offset_y = (orig_height - crop_height) // 2
            
        cropped = rgb_image.crop((offset_x, offset_y, offset_x + crop_width, offset_y + crop_height))
        
        # 4. Resize to 354x472 pixels
        print(f"  - Resizing to standard {target_width}x{target_height} pixels...")
        resized = cropped.resize((target_width, target_height), Image.Resampling.LANCZOS)
        
        # Save output
        out_name = os.path.splitext(filename)[0] + "_cccd.jpg"
        out_path = os.path.join(output_dir, out_name)
        resized.save(out_path, "JPEG", quality=95)
        print(f"  - SUCCESS! Saved to {out_path}")
        
    except Exception as e:
        print(f"  - FAILED to process {filename}: {e}")

print("\n=== PROCESSING COMPLETE ===")
