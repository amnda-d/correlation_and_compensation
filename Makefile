download_northeuralex:
	curl http://www.sfs.uni-tuebingen.de/\~jdellert/northeuralex/0.9/northeuralex-0.9-forms.tsv > scil-phonotactic-complexity/datasets/northeuralex/orig.tsv

download_unimorph:
	mkdir -p data/unimorph
	mkdir -p data/g2p
	./scripts/download-unimorph.sh

morph_irregularity:
	cd scil-morph-irregularity; make