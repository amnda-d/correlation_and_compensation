#!/usr/bin/env bash

mkdir data/wikipron

curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/amh_ethi_broad.tsv > data/wikipron/amh.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/zul_latn_broad.tsv > data/wikipron/zul.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/ceb_latn_broad.tsv > data/wikipron/ceb.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/nya_latn_broad.tsv > data/wikipron/nya.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/ind_latn_broad.tsv > data/wikipron/ind.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/kbd_cyrl_narrow.tsv > data/wikipron/kbd.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/csb_latn_broad.tsv > data/wikipron/csb.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/kir_cyrl_broad.tsv > data/wikipron/kir.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/mlt_latn_broad_filtered.tsv > data/wikipron/mlt.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/swa_latn_broad.tsv > data/wikipron/swc.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/tgl_latn_broad.tsv > data/wikipron/tgl.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/tgk_cyrl_broad.tsv > data/wikipron/tgk.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/tuk_latn_broad.tsv > data/wikipron/tuk.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/urd_arab_broad.tsv > data/wikipron/urd.tsv
curl https://raw.githubusercontent.com/CUNY-CL/wikipron/fa2f3649c43d1895642e8dc66bd92fa622a3be90/data/scrape/tsv/uig_arab_broad.tsv > data/wikipron/uig.tsv