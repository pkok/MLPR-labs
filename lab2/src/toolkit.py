"""
This file contains the translation of the provided Matlab code for lab
assignment 2.
"""
import os
import re
import sys
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
    MAX = NUM("Infinity")
NUM=float
MAX = NUM(sys.float_info.max)

"""The value "1" in the default numeric type."""
ONE = NUM(1)

"""The value "0" in the default numeric type."""
ZERO = NUM(0)

"""Default flags for regular expressions."""
RE_FLAGS = re.IGNORECASE

"""
Prior probability for SPAM.

Based on the statistics the MAAWG collected over the third quarter of 2011.
Source: http://www.maawg.org/sites/maawg/files/news/MAAWG_2011_Q1Q2Q3_Metrics_Report_15.pdf
""" 
PRIOR_SPAM = NUM("0.888")

"""
Prior probability for HAM.

Based on the statistics the MAAWG collected over the third quarter of 2011.
Source: http://www.maawg.org/sites/maawg/files/news/MAAWG_2011_Q1Q2Q3_Metrics_Report_15.pdf
""" 
PRIOR_HAM = ONE - PRIOR_SPAM


def presentre(filename, regexps, compiled=False):
    """ 
    Return a list consisting of 1s and 0s, representing a match for each
    regular expression in the file.
    """
    return presentre_str(file_to_str(filename), regexps, compiled=compiled)


previous_presentre_calls = {}
def presentre_str(text, regexps, compiled=False):
    """ 
    Return a list consisting of 1s and 0s, representing a match for each
    regular expression in the text.
    """
    # No regular expression flag can be passed if the regexp is already compiled.
    regexps = tuple(regexps)
    if not previous_presentre_calls.has_key((text, regexps, compiled)):
        flags = 0
        if not compiled:
            flags = RE_FLAGS
        previous_presentre_calls[(text, regexps, compiled)] = map(lambda regexp: NUM(bool(re.search(regexp, text, flags=flags))), regexps)
    return previous_presentre_calls[(text, regexps, compiled)]


previous_countre_calls = {}
def countre(folder, regexps, compiled=False, smoothing=0):
    """ 
    Return a list of probabilities that the regexp occurs in a file, and the
    number of files inspected.

    The values can be smoothed, according to Laplace smoothing.
    """
    regexps = tuple(regexps)
    if not previous_countre_calls.has_key((folder, regexps, compiled, smoothing)):
        filenames = get_files(folder)
        file_count = len(filenames)
        texts = map(file_to_str, filenames)
        if compiled:
            patterns = regexps
        else:
            patterns = map(lambda r: re.compile(r, flags=RE_FLAGS), regexps)
        match_counts = len(regexps) * [ZERO]

        for text in texts:
            match_counts = map(sum, zip(match_counts, presentre_str(text, patterns, compiled=True)))
        
        def smooth_prob(match_count):
            # TODO: Should we use len(regexps), or the number of classes?
            return (match_count + smoothing) / (file_count + len(regexps) * smoothing)
        previous_countre_calls[(folder, regexps, compiled, smoothing)] = map(smooth_prob, match_counts), file_count
    return previous_countre_calls[(folder, regexps, compiled, smoothing)]


previous_count_word_calls = {}
def count_words(directory):
    """
    Return a defaultdict with words as keys and the number of occurences of
    a word in the files in the directory as value.
    """
    if not previous_count_word_calls.has_key(directory):
        word_list = defaultdict(lambda: NUM(0)) 
        for filename in get_files(directory):
            words = re.split('[^a-z]', file_to_str(filename).lower())
            words = filter(lambda x: len(x), words)
            for w in words:
                word_list[w] += ONE 
        previous_count_word_calls[directory] = word_list
    return previous_count_word_calls[directory]


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
        sumdict.default_factory = NUM
        if hasattr(d1, 'default_factory') and hasattr(d2, 'default_factory'):
            sumdict.default_factory = lambda: d1.default_factory() + d2.default_factory()
        elif hasattr(d1, 'default_factory'):
            sumdict.default_factory = lambda: d1.default_factory()
        elif hasattr(d2, 'default_factory'):
            sumdict.default_factory = lambda: d2.default_factory()
    for key in d2.iterkeys():
        if add_default or sumdict.has_key(key):
            sumdict[key] += d2[key]
        else:
            sumdict[key] = d2[key]
    return sumdict


def word_bag(filename):
    return set(filter(None, set(re.split('[^a-z]', file_to_str(filename).lower()))))


def get_files(folder):
    """List all files in a folder."""
    return map(lambda filename: folder + os.sep + filename, os.listdir(folder))


file_contents = {}
def file_to_str(filename):
    """Return the file contents of filename as a single string."""
    if not file_contents.has_key(filename):
        file_contents[filename] = open(filename, 'r').read()
    return file_contents[filename]


def prod(args):
    """Compute the product of the elements of the argument collection."""
    return reduce(lambda x, y: x * y, args)


if __name__ == "__main__":
    #print count_words('spam/train')
    import toolkit
    help(toolkit)
    pass
