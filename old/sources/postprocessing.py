#!/usr/bin/env python3
"""Fix the font names for the variable fonts"""
# TODO (M Foley) this shouldn't be required. Send fix to fontmake
from fontTools.ttLib import TTFont
from glob import glob
import os

font_paths = glob("../fonts/variable/*.ttf")

for path in font_paths:
    font = TTFont(path)
    if "CrimsonPro-Roman-VF.ttf" == os.path.basename(path):
        font["name"].setName("CrimsonProRoman", 25, 3, 1, 1033)

    del font["MVAR"]
    font.save(path + ".fix")
