## Dependencies

pc:
```
python 3.11.5
epitran==1.24
gensim==4.3.2
langcodes==3.3.0
numpy==1.25.2
pandas==2.1.0
torch==2.3.0
tqdm==4.66.2
nltk==3.8.1
smart_open==6.4.0
```

```
make morph-irregularity
```

## Download Data

```
make download_unimorph
make download_northeuralex
```

## Process Unimorph

Get G2P transcriptsion:

```
python src/unimorph_to_ipa.py
```

Preprocess data:

```
./scripts/generate-data.sh
```

## Phonotactic Complexity

Parse the data:

```
python scil-phonotactic-complexity/data_layer/parse.py --data northeuralex
```

Train the model:

```
python learn_layer/train_base_cv.py --model phoible
```

Get phonotactic complexity scores for UniMorph:

```
./scripts/get-unimorph-phono.sh
```

## Morphological Complexity

```
./scripts/run-unimorph.sh
```

## Frequency Data

```
./scripts/download-wiki.sh
./scripts/count-wiki.sh
```

## Make Data CSV

```
python src/generate_data.py
```