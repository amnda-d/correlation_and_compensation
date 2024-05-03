langs = [
    'amh', 'ceb', 'csb', 'ind', 'kbd', 'kir', 'mlt', 'nya', 'swc', 'tgk', 'tgl', 'tuk', 'uig', 'urd', 'zul'
]

with open('data/wikipron/formatted.tsv', 'w') as outfile:
    for lang in langs:
        with open(f'data/wikipron/{lang}.tsv', 'r') as f:
            for line in f:
                word, ipa = line.strip('\n').split('\t')
                ipa = ' '.join(ipa.split(' '))
                outfile.write(f'{lang}\t{lang}\t{word}\t{word}\t{ipa}\t{ipa}\tx\tx\tx\tx\n')