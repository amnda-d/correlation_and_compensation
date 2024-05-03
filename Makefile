download_northeuralex:
	curl http://www.sfs.uni-tuebingen.de/\~jdellert/northeuralex/0.9/northeuralex-0.9-forms.tsv > scil-phonotactic-complexity/datasets/northeuralex/orig.csv

download_unimorph:
	mkdir -p data/unimorph
	mkdir -p data/g2p
	./scripts/download-unimorph.sh

download_wikipron:
	./scripts/download-wikipron.sh
	python src/parse-wikipron.py
	cat data/wikipron/formatted.tsv >> scil-phonotactic-complexity/datasets/northeuralex/orig.csv
	sed -i '' 's/^hrv/hbs/' scil-phonotactic-complexity/datasets/northeuralex/orig.csv
	sed -i '' 's/^aze/azj/' scil-phonotactic-complexity/datasets/northeuralex/orig.csv