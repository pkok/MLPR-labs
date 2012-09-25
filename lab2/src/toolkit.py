"""
This file contains the translation of the provided Matlab code for lab
assignment 2.
"""
import os
import re
from collections import defaultdict
from decimal import Decimal

""" 
Setting the default numeric type.  

We use Decimal, as it has arbitrary precision (i.e., no floating point error,
or intermediate rounding error). 
"""
NUM = Decimal

"""The value "1" in the default numeric type."""
ONE = NUM(1)

"""The value "0" in the default numeric type."""
ZERO = NUM(0)

def presentre(filename, regexps):
    """ 
    Return a list consisting of 1s and 0s, representing a match for each
    regular expression in the file.
    """
    return presentre_str(''.join(open(filename, 'r').readlines()), regexps)



def presentre_str(text, regexps):
    """ 
    Return a list consisting of 1s and 0s, representing a match for each
    regular expression in the text.
    """
    return [num(bool(re.search(regexp, text))) for regexp in regexps]



def countre(folder, regexps):
    """ 
    Return a list of probabilities that the regexp occurs in a file, and the
    number of files inspected.
    """
    filenames = os.listdir(folder)
    filecount = len(filenames)
    texts = [''.join(open(folder + os.sep + filename, 'r').readlines()) for filename in filenames]
    patterns = [re.compile(regexp) for regexp in regexps]
    match_counts = len(regexps) * [ZERO]

    for text in texts:
        match_counts = [curr + new for (curr, new) in zip(match_counts, presentre_str(text, patterns))]

    match_counts = [count / filecount for count in match_counts]

    return match_counts, filecount



def count_words(directory):
    """
    Return a defaultdict with words as keys and the number of occurences of
    a word in the files in the directory as value.
    """
    word_list = defaultdict(num) 
    directory_content = os.listdir(directory)
    for f in directory_content:
        words = open(directory + os.sep + f, 'r').read().split(' ')
        for w in words:
            word_list[w] += ONE 
    return word_list



def merge_ws(s1, s2):
    """ 
    "Merge word structs."
    
    Strange artifact used by Matlab.  More general Python name is dictsum.
    """
    return dictsum(s1, s2, False)



def wordtable(s1, s2):
    """ What should it do? Do we really need this?"""
    pass



def dictsum(d1, d2, add_default=True):
    """
    Sum the values of corresponding keys of two dictionaries.  
    
    If add_default, the default_factory of both (if present), are summed as
    well.
    """
    sumdict = d1.copy()
    if add_default:
        sumdict.default_factory = lambda: d1.default_factory + d2.default_factory
    for key in d2.iterkeys():
        if add_default or sumdict.has_key(key):
            sumdict[key] += d2[key]
        else:
            sumdict[key] = d2[key]
    return sumdict



if __name__ == "__main__":
    #print count_words('spam/train')
    import toolkit
    help(toolkit)
    pass
