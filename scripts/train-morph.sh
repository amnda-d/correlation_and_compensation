#!/bin/bash

languages=("sqi" "amh" "aze" "ben" "cat" "ceb" "nya" "ces" "nld" "got" "hin" "ind" "kbd" "csb" "kaz" "khk" "kir" "mlt" "mao" "orm" "pol" "ron" "sna" "swc" "swe" "tgl" "tel" "tuk" "ukr" "urd" "uig" "uzb" "zul" "tgk" "hbs" "hun" "ita" "rus" "spa" "tur" "deu" "eng" "fra" "por")
nfold=10

for lang in ${languages[*]}; do
    echo $lang

    for fold in $(seq 1 $nfold); do
        sh scil-morph-irregularity/example/irregularity-vs-frequency/run-unimorph.sh $lang $fold
    done
done