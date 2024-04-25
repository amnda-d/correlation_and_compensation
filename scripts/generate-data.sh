#!/bin/bash

languages=("kbd" "tel")
# languages=("sqi" "amh" "aze" "ben" "cat" "ceb" "nya" "ces" "nld" "eng" "fra" "deu" "got" "hin" "hun" "ind" "ita" "kbd" "csb" "kaz" "khk" "kir" "mlt" "mao" "ood" "orm" "pol" "por" "ron" "rus" "hbs" "sna" "spa" "swc" "swe" "tgl" "tgk" "tel" "tur" "tuk" "ukr" "urd" "uig" "uzb" "zul")

nfold=10

for lang in ${languages[*]}; do
  python scil-morph-irregularity/example/irregularity-vs-frequency/preprocess-unimorph.py \
      --infile data/g2p/$lang.tsv \
      --outdir data/g2p/$lang/split/$lang \
      --nfold 10 --nchar 1 --prefix --suffix
  
  python scil-morph-irregularity/example/irregularity-vs-frequency/preprocess-unimorph.py \
      --infile data/ortho/$lang.tsv \
      --outdir data/ortho/$lang/split/$lang \
      --nfold 10 --nchar 1 --prefix --suffix
done