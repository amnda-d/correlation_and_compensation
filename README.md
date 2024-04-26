# Correlation Does Not Imply Compensation: Complexity and Irregularity in the Lexicon

This repository contains code for the paper Correlation Does Not Imply Compensation: Complexity and Irregularity in the Lexicon (Doucette, Cotterell, Sonderegger, and O'Donnell 2024), presented at [SCiL 2024](https://sites.uci.edu/scil2024/).

It contains submodules forked from [phonotactic-complexity](https://github.com/tpimentelms/phonotactic-complexity) and [neural-transducer](https://github.com/shijie-wu/neural-transducer). Run the following commands to set up the submodules after cloning this repository:

```
git submodule init
git submodule update
```

To run the experiments and produce the figures in the paper, follow these steps:

### 1. Download Data

```
make download_unimorph
make download_northeuralex
```

### 2. Process Unimorph

Get G2P transcriptsion:

```
python src/unimorph_to_ipa.py
```

Preprocess data:

```
./scripts/generate-data.sh
```

### 3. Phonotactic Complexity

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

### 4. Morphological Complexity

```
./scripts/train-morph.sh
```

### 5. Frequency Data

```
./scripts/download-wiki.sh
./scripts/count-wiki.sh
```

### 6. Make Data CSV

```
python src/generate_data.py
```

### 7. Generate Plots

## Requirements

Python 3.11.5

```
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

To test: 3, 6, 7