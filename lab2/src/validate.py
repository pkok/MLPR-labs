"""
Validation algorithms for classifiers.

This comprises section 4 of lab assignment 2.
"""
from collections import defaultdict
import operator

import bayes
import features
import toolkit


def validate_classification(roc_step=toolkit.NUM('0.001')):
    """Compute the ROC."""
    correct = defaultdict(lambda: defaultdict(toolkit.NUM))
    false = defaultdict(lambda: defaultdict(toolkit.NUM))
    roc = list()

    # Compute best features.
    best_features = features.best_features(300)
    for feature, prob in best_features:
        print feature, "     ", prob
    best_features = map(operator.itemgetter(0), best_features)

    ham_files = toolkit.get_files(bayes.HAM + bayes.TEST)
    spam_files = toolkit.get_files(bayes.SPAM + bayes.TEST)
    ham_count = len(ham_files)
    spam_count = len(spam_files)
    test_samples = zip(ham_files + spam_files, ham_count * [bayes.HAM] +
            spam_count * [bayes.SPAM])
    ham_count = toolkit.NUM(ham_count)
    spam_count = toolkit.NUM(spam_count)

    from math import log, ceil
    total_count = ham_count + spam_count
    total_digits = ceil(log(total_count, 10))
    print_msg = "Processing file (%%0%dd/%d): %%s " % (total_digits, total_count)
    count = 0
    for filename, clss in test_samples:
        count += 1
        print print_msg % (count, filename)
        threshold = toolkit.ZERO
        while threshold <= toolkit.ONE:
            is_correct = int(bayes.classify(filename, best_features, threshold) == clss)
            correct[threshold][clss] += is_correct
            false[threshold][clss] += (toolkit.NUM(1) - is_correct)
            threshold += roc_step
    threshold = toolkit.ZERO
    while threshold <= toolkit.ONE:
        print false[threshold][bayes.SPAM], "--", correct[threshold][bayes.SPAM]
        roc.append((false[threshold][bayes.SPAM] / ham_count,
            correct[threshold][bayes.SPAM] / spam_count))
        threshold += roc_step
    return correct, false, roc


if __name__ == "__main__":
    correct, false, roc = validate_classification(toolkit.NUM('0.1'))
    print "\n\n"
    for element in roc:
        print element
