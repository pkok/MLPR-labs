"""
This file contains the translation of the provided Matlab code for lab
assignment 2.
"""
import os
import re
from collections import defaultdict

""" 
Setting the default numeric type.  

We like to use arbitrary precision numbers, so we do not end up with floating
point errors, or intermediate rounding errors.  gmpy is a non-default library,
which supplies a much faster implementation of aribrary precision numbers,
than decimal does. 
"""
try:
    from gmpy import mpf as NUM
except ImportError:
    from decimal import Decimal as NUM

"""The value "1" in the default numeric type."""
ONE = NUM(1)

"""The value "0" in the default numeric type."""
ZERO = NUM(0)

"""Default flags for regular expressions."""
RE_FLAGS = re.IGNORECASE

"""Prior probability for HAM""" 
PRIOR_HAM = NUM(0.7)
"""Prior probability for SPAM""" 
PRIOR_SPAM = NUM(1-PRIOR_HAM)

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
    try:
        return map(lambda regexp: NUM(bool(re.search(regexp, text, flags=RE_FLAGS))), regexps)
    except ValueError:
        # No regular expression flag can be passed if the regexp is already compiled.
        return map(lambda regexp: NUM(bool(re.search(regexp, text, flags=0))), regexps)



def countre(folder, regexps):
    """ 
    Return a list of probabilities that the regexp occurs in a file, and the
    number of files inspected.
    """
    filenames = get_files(folder)
    file_count = len(filenames)
    texts = [''.join(open(filename, 'r').readlines()) for filename in filenames]
    patterns = [re.compile(regexp, flags=RE_FLAGS) for regexp in regexps]
    match_counts = len(regexps) * [ZERO]

    for text in texts:
        match_counts = [curr + new for (curr, new) in zip(match_counts, presentre_str(text, patterns))]

    return map(lambda match_count: match_count / file_count, match_counts), file_count



def count_words(directory):
    """
    Return a defaultdict with words as keys and the number of occurences of
    a word in the files in the directory as value.
    """
    word_list = defaultdict(NUM) 
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
    """ What should it do? Do we really need this? I believe it translates
    one data structure to another for Matlab. We do not use Matlab so
    we should not need it. """
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



def get_files(folder):
    return map(lambda filename: folder + os.sep + filename, os.listdir(folder))


def prod(args):
    return reduce(lambda x, y: x * y, args)



if __name__ == "__main__":
    #print count_words('spam/train')
    import toolkit
    help(toolkit)
    pass
