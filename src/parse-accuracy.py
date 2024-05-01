import os
import re
from collections import defaultdict

accs = defaultdict(list)

for filename in os.listdir(f'out/morph'):
    with open(f'out/morph/{filename}', 'r') as f:
        last_line = f.readlines()[-1]
        m = re.match(r"^INFO - (\d+/\d+/\d+) .+ - TEST (\w\w\w)-(\d+) acc (\w+.\w+) dist", last_line)
        lang = m.group(2)
        fold = m.group(3)
        acc = m.group(4)
        accs[lang] += [float(acc)]

print(accs)

with open('out/accuracies.tsv', 'w') as f:
    for lang, vals in accs.items():
        f.write(f'{lang}\t{sum(vals)/len(vals)}')