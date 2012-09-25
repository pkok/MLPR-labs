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

def count_words(directory):
    """ returns a defaultdict with words as keys and
    the number of occurences of a word in the files 
    in the directory as value. """
    word_list = defaultdict(int) 
    directory_content = os.listdir(directory)
    for f in directory_content:
        words = open(directory + os.sep + f, 'r').read().split(' ')
        for w in words:
            word_list[w] += 1 
    return word_list

if __name__ == "__main__":
    #print count_words('spam/train')
    pass
