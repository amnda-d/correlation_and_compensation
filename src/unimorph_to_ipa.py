import epitran
import os

codes = {}
with open('src/unimorph_epitran_codes.tsv', "r", encoding="utf-8") as fp:
    for line in fp:
        line = line.strip().split('\t')
        codes[line[1]] = line[2]

languages = codes.keys()
# languages = ['orm', 'pol', 'por', 'ron', 'rus', 'hbs', 'sna', 'spa', 'swc', 'swe', 'tgl', 'tel', 'tur', 'tuk',
# 'ukr', 'urd', 'uig', 'uzb', 'zul']

def get_paradigms(fp):
    paradigms = []
    for line in fp:
        if line is not os.linesep:
            form = line.strip().split('\t')
            if len(paradigms) == 0 or form[0] != paradigms[-1][-1][0]:
                paradigms += [[form]]
            else:
                paradigms[-1] += [form]
    return paradigms

# languages=['eng']
for lang in languages:
    print(lang)
    epi = epitran.Epitran(codes[lang])
    uni_fp = os.path.join("data/unimorph", lang, lang)
    with open(uni_fp, "r", encoding="utf-8") as fp:
        paradigms = get_paradigms(fp)
        # forms = [form for paradigm in paradigms for form in paradigm]
        # print(lang + '\t' + str(len(par)) + '\t' + str(len(forms)))

        out_fp = os.path.join("data/g2p", lang + '.tsv')
        with open(out_fp, "w", encoding="utf-8") as ofp:
            for paradigm in paradigms:
                par_ipa = ' '.join(epi.trans_list(paradigm[0][0]))
                for form in paradigm:
                    if len(form) == 3:
                        form_ipa = ' '.join(epi.trans_list(form[1]))
                        tags = form[2]
                        ofp.writelines(form[0] + '\t' + par_ipa + '\t' + form[1] + '\t' + form_ipa + '\t' + tags + os.linesep)
                    else:
                        print(form)

# epi = epitran.Epitran('eng-Latn')
#
# print(epi.trans_list('test'))
