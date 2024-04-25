#!/bin/bash

mkdir data/wiki

languages=("sq" "am" "az" "bn" "ca" "ceb" "ny" "cs" "nl" "en" "fr" "de" "got" "hi" "hu" "id" "it" "kbd" "csb" "kk" "mn" "ky" "mt" "mi" "om" "pl" "pt" "ro" "ru" "sh" "sn" "es" "sw" "sv" "tl" "tg" "te" "tr" "tk" "ukr" "ur" "ug" "uz" "zu")

for lang in ${languages[*]}; do
    wget https://dumps.wikimedia.org/${lang}wiki/latest/${lang}wiki-latest-pages-articles.xml.bz2 -O data/wiki/$lang.xml.bz2
done