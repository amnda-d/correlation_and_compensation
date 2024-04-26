#!/bin/bash

languages=("sqi" "amh" "aze" "ben" "cat" "ceb" "nya" "ces" "nld" "eng" "fra" "deu" "got" "hin" "hun" "ind" "ita" "kbd" "csb" "kaz" "khk" "kir" "mlt" "mao" "ood" "orm" "pol" "por" "ron" "rus" "hbs" "sna" "spa" "swc" "swe" "tgl" "tgk" "tel" "tur" "tuk" "ukr" "urd" "uig" "uzb" "zul")

cd scil-phonotactic-complexity

for lang in ${languages[*]}; do
    echo $lang

    python data_layer/parse_unimorph.py --data unimorph --language $lang --eval
    python learn_layer/train_base.py --model phoible --data unimorph --language $lang --eval  --statedict results/"$lang".pt
done