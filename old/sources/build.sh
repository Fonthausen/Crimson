#!/bin/sh
set -e
 
echo "Generating Static fonts"
mkdir -p ../fonts/ttfs
fontmake -g CrimsonPro-Roman.glyphs -i -o ttf --output-dir ../fonts/ttfs/
fontmake -g CrimsonPro-Italic.glyphs -i -o ttf --output-dir ../fonts/ttfs/

echo "Generating VFs"
mkdir -p ../fonts/variable
fontmake -g CrimsonPro-Roman.glyphs -o variable --output-path ../fonts/variable/CrimsonPro-Roman-VF.ttf
fontmake -g CrimsonPro-Italic.glyphs -o variable --output-path ../fonts/variable/CrimsonPro-Italic-VF.ttf

rm -rf master_ufo/ instance_ufo/
echo "Post processing"


ttfs=$(ls ../fonts/ttfs/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	gftools fix-nonhinting $ttf "$ttf.fix";
	mv "$ttf.fix" $ttf;
done
rm ../fonts/ttfs/*backup*.ttf

vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs
do
	gftools fix-dsig -f $vf;
	gftools fix-nonhinting $vf "$vf.fix";
	mv "$vf.fix" $vf;
done
rm ../fonts/variable/*backup*.ttf

gftools fix-vf-meta $vfs;
for vf in $vfs
do
	mv "$vf.fix" $vf;
done

for vf in $vfs
do
	gftools gen-stat $vf --src stat.yaml --inplace;
done

python postprocessing.py
mv ../fonts/variable/CrimsonPro-Italic-VF.ttf.fix ../fonts/variable/CrimsonPro-Italic-VF.ttf
mv ../fonts/variable/CrimsonPro-Roman-VF.ttf.fix ../fonts/variable/CrimsonPro-Roman-VF.ttf

echo "QAing"
gftools qa ../fonts/variable/*.ttf -o ../qa --fontbakery --plot-glyphs

