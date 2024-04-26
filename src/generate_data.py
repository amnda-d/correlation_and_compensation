import os
import re
import math
from collections import defaultdict

codes = {}
with open('src/unimorph_epitran_codes.tsv', "r", encoding="utf-8") as fp:
    for line in fp:
        line = line.strip().split('\t')
        codes[line[1]] = line[2]

languages = codes.keys()
languages = ['kbd', 'tel']

with open('data/processed.tsv', 'w+', encoding="utf-8") as fp:
    fp.write('lang\ttarget\tmorph_pred\tmorph_loss\tmorph_complexity\tmorph_edit_dist\tphon_loss\tphon_len\tconcept\tbase\tpos\tinflection\tbase_str\ttarget_str\tcount\tfreq\tortho_morph_pred\tortho_morph_loss\tortho_morph_complexity\tortho_morph_edit_dist\n')

for lang in languages:
    print(lang)
    data = {}
    ortho_to_ipa = {}
    cnts = defaultdict(int)
    frqs = defaultdict(float)
    if os.path.exists(f'data/g2p/{lang}/split/{lang}.wiki.cnt'):
        with open(f'data/g2p/{lang}/split/{lang}.wiki.cnt', "r", encoding="utf-8") as fp:
            for line in fp:
                target_str, frq, count = line.strip('\n').split('\t')
                cnts[target_str] = count
                frqs[target_str] = frq

    if os.path.exists(f'data/g2p/{lang}.tsv'):
        with open(f'data/g2p/{lang}.tsv', "r", encoding="utf-8") as fp:
            for line in fp:
                base_str, base, target_str, target, tags = line.strip('\n').split('\t')
                data[(lang, target.strip())] = {
                    'lang': lang,
                    'target_str': target_str.lower().strip(),
                    'base_str': base_str.lower().strip(),
                    'target': target.strip(),
                    'base': base.strip(),
                    'count': cnts[target_str.lower()],
                    'freq': frqs[target_str.lower()]
                }
                ortho_to_ipa[(lang, target_str.lower().strip())] = target.strip()

    # print(list(ortho_to_ipa.items())[:20])

    if os.path.exists(f'data/g2p/{lang}/model'):
        for f in os.listdir(f'data/g2p/{lang}/model'):
            if f.endswith('.decode.test.tsv'):
                print(f, 'g2p')
                with open(f'data/g2p/{lang}/model/{f}', "r", encoding="utf-8") as fp:
                    next(fp)
                    for line in fp:
                        pred, target, loss, dist = line.strip('\n').split('\t')
                        loss = math.exp(-float(loss))
                        # print(lang, target)
                        try:
                            data[(lang, target.strip())].update({
                            'lang': lang,
                            'target': target,
                            'morph_pred': pred,
                            'morph_loss': loss,
                            'morph_complexity': -math.log(loss/(1-loss)),
                            'morph_edit_dist': dist,
                            })
                        except ValueError as e:
                            print(e, loss)
    
    # if os.path.exists(f'data/ortho/{lang}/model'):
    #     for f in os.listdir(f'data/ortho/{lang}/model'):
    #         if f.endswith('.decode.test.tsv'):
    #             # print(f, 'ortho')
    #             with open(f'data/ortho/{lang}/model/{f}', "r", encoding="utf-8") as fp:
    #                 next(fp)
    #                 for line in fp:
    #                     pred, target, loss, dist = line.strip('\n').split('\t')
    #                     loss = math.exp(-float(loss))
    #                     try:
    #                         tgt = ''.join(re.split("(?<=\\S) ", target))
    #                         tgt = ' '.join(tgt.split()).strip()
    #                         # print(lang, ortho_to_ipa[(lang, tgt.lower())])
    #                         data[(lang, ortho_to_ipa[(lang, tgt.lower())])].update({
    #                         'ortho_morph_pred': pred,
    #                         'ortho_morph_loss': loss,
    #                         'ortho_morph_complexity': -math.log(loss/(1-loss)),
    #                         'ortho_morph_edit_dist': dist,
    #                         })
    #                     except ValueError as e:
    #                         print(e, loss)
    #                     except KeyError as e:
    #                         print('key', e, loss, target, tgt)
    #                     except ZeroDivisionError as e:
    #                         print(e, loss)
    
    if os.path.exists(f'data/g2p/{lang}/split'):
        for f in os.listdir(f'data/g2p/{lang}/split'):
            if f.endswith('test'):
                # print(f)
                with open(f'data/g2p/{lang}/split/{f}', "r", encoding="utf-8") as fp:
                    for line in fp:
                        try:
                            base, target, tags = line.strip('\n').split('\t')
                            pos, inflection = tags.split(';')[0], ';'.join(tags.split(';')[1:])
                            data[(lang, target.strip())].update({
                            'base': base,
                            'pos': pos,
                            'inflection': inflection
                        })
                        except KeyError as e:
                            # print(e)
                            # These are 'derived forms' detected by suffix/prefix, which were removed from unimorph data
                            pass
                        except ValueError as e:
                            print(e)
    # if os.path.exists(f'data/ortho/{lang}/split'):
    #     for f in os.listdir(f'data/ortho/{lang}/split'):
    #         if f.endswith('test'):
    #             # print(f)
    #             with open(f'data/ortho/{lang}/split/{f}', "r", encoding="utf-8") as fp:
    #                 for line in fp:
    #                     try:
    #                         base, target, tags = line.strip('\n').split('\t')
    #                         pos, inflection = tags.split(';')[0], ';'.join(tags.split(';')[1:])
    #                         tgt = ''.join(re.split("(?<=\\S) ", target))
    #                         tgt = ' '.join(tgt.split())
    #                         data[(lang, ortho_to_ipa[(lang, tgt.lower())])].update({
    #                         'base': base,
    #                         'pos': pos,
    #                         'inflection': inflection
    #                     })
    #                     except KeyError as e:
    #                         # print(e)
    #                         # These are 'derived forms' detected by suffix/prefix, which were removed from unimorph data
    #                         pass
    #                     except ValueError as e:
    #                         print(e)
    
    data_bases = defaultdict(dict)
    for k, v in data.items():
        data_bases[(lang, v['base'])][k] = v

    if os.path.exists(f'scil-phonotactic-complexity/results/unimorph/normal/orig/{lang}'):
        with open(f'scil-phonotactic-complexity/results/unimorph/normal/orig/{lang}/phoible__results-per-word-eval.csv', "r", encoding="utf-8") as fp:
            next(fp)
            for line in fp:
                if line != '':
                    line = line.strip('\n').split(',')
                    concept = line[1]
                    target = line[3]
                    length = line[4]
                    loss = line[5]
                    # for k in data_bases[(lang, target)].keys():
                    #     data_bases[(lang, target)][k].update({
                    #         'phon_loss': loss,
                    #         'phon_len': length,
                    #         'concept': concept
                    #     })
                    # # keys = [k for k, v in data.items() if v['base'] == target]
                    # for k in keys:
                    try:
                        data[(lang, target.strip())].update({
                            'phon_loss': loss,
                            'phon_len': length,
                            'concept': concept
                        })
                    except KeyError as e:
                        # print(e)
                        # These are 'derived forms' detected by suffix/prefix, which were removed from unimorph data
                        pass
                    except ValueError as e:
                        print(e)

    # data = list(data_bases.values())
    # data = [list(d.values()) for d in data]
    # data = [x for y in data for x in y]
    data = list(data.values())
    print(lang, len(data))
    # print(data[0:5])
    mc = [d for d in data if 'morph_complexity' in d]
    print(lang, 'morph_complexity', len(mc))
    mc = [d for d in data if 'phon_loss' in d]
    print(lang, 'phon_loss', len(mc))
    # mc = [d for d in data if 'ortho_morph_pred' in d]
    # print(lang, 'ortho_morph_pred', len(mc))
    data = [d for d in data if 'phon_loss' in d]
    data = [d for d in data if 'morph_complexity' in d or 'ortho_morph_pred' in d]
    print(lang, len(data))
    print('\n')
    lines = [
        '\t'.join([
            l['lang'],
            l['target'],
            l['morph_pred'] if 'morph_pred' in l else 'NA',
            str(l['morph_loss']) if 'morph_loss' in l else 'NA',
            str(l['morph_complexity']) if 'morph_complexity' in l else 'NA',
            l['morph_edit_dist'] if 'morph_edit_dist' in l else 'NA',
            l['phon_loss'],
            l['phon_len'],
            l['concept'],
            l['base'],
            l['pos'],
            l['inflection'],
            l['base_str'],
            l['target_str'],
            str(l['count']),
            str(l['freq']),
            l['ortho_morph_pred'] if 'ortho_morph_pred' in l else 'NA',
            str(l['ortho_morph_loss']) if 'ortho_morph_loss' in l else 'NA',
            str(l['ortho_morph_complexity']) if 'ortho_morph_complexity' in l else 'NA',
            l['ortho_morph_edit_dist'] if 'ortho_morph_edit_dist' in l else 'NA'
        ]) + '\n' for l in data
    ]

    with open('data/processed.tsv', 'a', encoding="utf-8") as fp:
        fp.writelines(lines)
