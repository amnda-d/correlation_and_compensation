import os

codes = {}
with open('src/unimorph_epitran_codes.tsv', "r", encoding="utf-8") as fp:
    for line in fp:
        line = line.strip().split('\t')
        codes[line[1]] = line[2]

languages= codes.keys()

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
    uni_fp = os.path.join("data/unimorph", lang, lang)
    with open(uni_fp, "r", encoding="utf-8") as fp:
        paradigms = get_paradigms(fp)
        # forms = [form for paradigm in paradigms for form in paradigm]
        # print(lang + '\t' + str(len(par)) + '\t' + str(len(forms)))

        out_fp = os.path.join("data/ortho", lang + '.tsv')
        with open(out_fp, "w", encoding="utf-8") as ofp:
            for paradigm in paradigms:
                for form in paradigm:
                    if len(form) == 3:
                        tags = form[2]
                        ofp.writelines(form[0] + '\t' + ' '.join(form[0]) + '\t' + form[1] + '\t' + ' '.join(form[1]) + '\t' + tags + os.linesep)
                    else:
                        print(form)

# epi = epitran.Epitran('eng-Latn')
#
# print(epi.trans_list('test'))
