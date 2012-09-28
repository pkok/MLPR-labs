"""
Validation algorithms for classifiers.

This comprises section 4 of lab assignment 2.
"""
from collections import defaultdict
from time import gmtime, strftime
import operator
import numpy

import bayes
import features
import toolkit


def validate_classification(roc_step=toolkit.NUM('0.001')):
    """Compute the ROC."""
    true = dict()
    false = dict()
    true[bayes.HAM] = defaultdict(lambda: toolkit.NUM(0))
    true[bayes.SPAM] = defaultdict(lambda: toolkit.NUM(0))
    false[bayes.HAM] = defaultdict(lambda: toolkit.NUM(0))
    false[bayes.SPAM] = defaultdict(lambda: toolkit.NUM(0))
    ham_roc = list()
    spam_roc = list()

    # Compute best features.
    print "Computing the 300 most characteristic features"
    print "This is done by maximizing abs(p(HAM | word) - p(SPAM | word))"
    print ""
    best_features = features.best_features(300)
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
    print_msg = "[%%s] Processing file %%0%dd of %d: %%s " % (total_digits, total_count)
    count = 0
    for filename, clss in test_samples:
        count += 1
        print print_msg % (strftime("%H:%M:%S", gmtime()), count, filename)
        threshold = toolkit.ZERO
        while threshold <= toolkit.ONE:
            classification =  bayes.classify(filename, best_features, threshold)
            if (classification == clss):
                true[classification][threshold] += toolkit.ONE
            else:
                false[classification][threshold] += toolkit.ONE
            threshold += roc_step
    threshold = toolkit.ZERO
    while threshold <= toolkit.ONE:
        total_false = false[bayes.HAM][threshold] + false[bayes.SPAM][threshold]
        total_true = true[bayes.HAM][threshold] + true[bayes.SPAM][threshold]
        ham_roc.append((false[bayes.HAM][threshold] / total_false,
            true[bayes.HAM][threshold] / total_true))
        spam_roc.append((false[bayes.SPAM][threshold] / total_false,
            true[bayes.SPAM][threshold] / total_true))
        threshold += roc_step
    #roc.reverse()
    print len(ham_roc)
    hamfile = open('ham_roc.dat', 'w')
    spamfile = open('spam_roc.dat', 'w')
    for h_e, s_e in zip(ham_roc, spam_roc):
        hamfile.write(str(h_e[0]) + ' ' + str(h_e[1]) + '\n')
        hamfile.flush()
        spamfile.write(str(s_e[0]) + ' ' + str(s_e[1]) + '\n')
        spamfile.flush()
    hamfile.close()
    spamfile.close()
    return true, false, ham_roc, spam_roc


if __name__ == "__main__":
    correct, false, ham_roc, spam_roc = validate_classification(toolkit.NUM('0.01'))
    print "\n\n======= ROC IS PRINTED TO 'roc.dat' ======="
    """
    f = open('roc.dat', 'w')
    for element in roc:
        f.write(str(element[0]) + " " + str(element[1]) + "\n")
    f.close()
    """
