#!/usr/bin/env python3
import sys, os
from PIL import Image
from resizeimage import resizeimage

def width_to_169(h, w):
    if (w/h) < (16/9):
        h,w=16*(h//16),9*(h//16)
    else:
        h,w=16*(h//9),9*(h//9)
    
    return h,w



def get_args(name='cropper', ratio='ratio', path='path'):
    return str(name), str(ratio), str(path)

name, ratio, path = get_args(*sys.argv)

# DO SOME FILE STUFF
file_path   = os.path.dirname(path)
file_name   = os.path.basename(path)
file_ext    = os.path.splitext(os.path.basename(path))[1]
file_noext  = os.path.splitext(os.path.basename(path))[0]
file_ratio  = ratio.replace(":", "_" )



# OPEN THE IMAGE
img     = Image.open(path)
img_w   = img.width
img_h   = img.height

if ratio == "16:9":
    h,w = width_to_169(img_h, img_w)
elif ratio == "1:1":
    h = img_w
    w = h
else:
    h = img_h
    w = img_w


img = resizeimage.resize_cover(img, [h, w])
img.save(file_path + '/' + file_name + '-cropped_' + file_ratio + file_ext, img.format)
img.close()