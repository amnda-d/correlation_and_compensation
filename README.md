# Correlation Does Not Imply Compensation: Complexity and Irregularity in the Lexicon

This repository contains code for the paper Correlation Does Not Imply Compensation: Complexity and Irregularity in the Lexicon (Doucette, Cotterell, Sonderegger, and O'Donnell 2024), presented at [SCiL 2024](https://sites.uci.edu/scil2024/).

It contains submodules forked from [phonotactic-complexity](https://github.com/tpimentelms/phonotactic-complexity) and [neural-transducer](https://github.com/shijie-wu/neural-transducer). Run the following commands to set up the submodules after cloning this repository:

```
git submodule init
git submodule update
```

The data used to produce the figures in the paper can be found in three files on OSF [here](https://osf.io/b3mf8), [here](https://osf.io/8wntf), and [here](https://osf.io/dc27h). To reproduce the plots and run regression models from the paper:

```
mkdir figs-final
Rscript r/figures-models.R
```

Appendix plots, along with additional plots of individual languages, can be generated with:

```
Rscript r/appendix-figures.R
```

To reproduce the data used in the figures, follow these steps. Steps 3 and 4 involve training neural networks, and benefit from running on a GPU -- they will not complete in a reasonable amount of time on a single CPU.

### 1. Download Data

```
make download_unimorph
make download_northeuralex
make download_wikipron
```

### 2. Process Unimorph

Get G2P transcription:

```
python src/unimorph_to_ipa.py
```

Preprocess data:

```
./scripts/generate-data.sh
```

### 3. Phonotactic Complexity

Parse data and train model:

```
./scripts/train-phono.sh
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

R 4.3.3

```
broom.mixed_0.2.9.4
ggthemes_5.1.0
lme4_1.1-35.3
tidyverse_2.0.0
```