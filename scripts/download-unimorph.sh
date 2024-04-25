#!/usr/bin/env bash

set -euxo pipefail

languages=("kbd" "tel")
# languages=("sqi" "amh" "aze" "ben" "cat" "ceb" "nya" "ces" "nld" "eng" "fra" "deu" "got" "hin" "hun" "ind" "ita" "kbd" "csb" "kaz" "khk" "kir" "mlt" "mao" "ood" "orm" "pol" "por" "ron" "rus" "hbs" "sna" "spa" "swc" "swe" "tgl" "tgk" "tel" "tur" "tuk" "ukr" "urd" "uig" "uzb" "zul")

for val1 in ${languages[*]}; do
     git -C data/unimorph clone git@github.com:unimorph/$val1.git; sleep 5
done
