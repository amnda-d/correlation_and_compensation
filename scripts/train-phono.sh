#!/bin/bash

languages=("sqi" "amh" "aze" "ben" "cat" "ceb" "nya" "ces" "nld" "eng" "fra" "deu" "got" "hin" "hun" "ind" "ita" "kbd" "csb" "kaz" "khk" "kir" "mlt" "mao" "orm" "pol" "por" "ron" "rus" "hbs" "sna" "spa" "swc" "swe" "tgl" "tgk" "tel" "tur" "tuk" "ukr" "urd" "uig" "uzb" "zul")

cd scil-phonotactic-complexity

for lang in ${languages[*]}; do
    echo $lang

    python data_layer/parse.py --data northeuralex --language $lang
    python learn_layer/train_base_cv.py --model phoible --data northeuralex --language $lang
done