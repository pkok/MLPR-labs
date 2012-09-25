import os
import re
from collections import defaultdict

def presentre(filename, regexps):
    return [int(bool(re.search(regexp, ''.join(open(filename, 'r').readlines())))) for regexp in regexps]

def countre(folder, regexps):
    filenames = os.listdir(folder)
    filecount = len(filenames)
    match_counts = defaultdict(int)
    patterns = {}
    for regexp in regexps:
        patterns[regexp] = re.compile(regexp)

    for filename in filenames:
        f = ''.join(open(filename, 'r').readlines())
        for regexp in regexps:
        match_counts[regexp] += patterns[regexp].search(f)
    
    for regexp in match_counts.iterkeys():
        match_counts[regexp] /= filecount
    return (match_counts, filecount)
