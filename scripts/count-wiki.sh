#!/bin/bash

# languages_wiki=("sq" "am" "az" "bn" "ca" "ceb" "ny"  "cs"  "nl"  "en" "fr"   "de" "got"  "hi" "hu"   "id"  "it"  "kbd" "csb" "kk"   "mn" "ky"  "mt"  "mi" "om"   "pl"  "pt"   "ro" "ru"   "sh"  "sn" "es"   "sw" "sv" "tl" "tg" "te" "tr" "tk" "uk" "ur" "ug" "uz" "zu")
# languages=("sqi" "amh" "aze" "ben" "cat" "ceb" "nya" "ces" "nld" "eng" "fra" "deu" "got" "hin" "hun" "ind" "ita" "kbd" "csb" "kaz" "khk" "kir" "mlt" "mao" "orm" "pol" "por" "ron" "rus" "hbs" "sna" "spa" "swc" "swe" "tgl" "tgk" "tel" "tur" "tuk" "ukr" "urd" "uig" "uzb" "zul")
languages=("kbd" "tel")
languages_wiki=("kbd" "te")


# for n in $(seq 0 43); do
for n in $(seq 0 1); do
     lang=${languages[$n]}
     wiki=${languages_wiki[$n]}
     python -m gensim.scripts.segment_wiki -i -f data/wiki/"$wiki".xml.bz2 -o data/wiki/"$wiki"wiki-latest.json.gz
     python src/count-wiki.py\
          --wiki data/wiki/"$wiki"wiki-latest.json.gz\
          --testfiles data/g2p/"$lang".tsv\
          --lang "$wiki"\
          --outfile data/g2p/"$lang"/split/"$lang".wiki.cnt
done