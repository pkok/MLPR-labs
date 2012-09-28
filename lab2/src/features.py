import math
import operator
from collections import defaultdict

import bayes
import toolkit

def best_features():
    ham_train = bayes.HAM + bayes.TRAIN
    spam_train = bayes.SPAM + bayes.TRAIN
    ham_words = map(lambda s: '/' + s + '/', 
            set.union(*map(toolkit.word_bag, toolkit.get_files(ham_train))))
    spam_words = map(lambda s: '/' + s + '/', 
            set.union(*map(toolkit.word_bag, toolkit.get_files(spam_train))))
    all_words = set(ham_words + spam_words)

    # p(w_i | c)
    p_w_ham = defaultdict(lambda: toolkit.ZERO, zip(ham_words, 
            toolkit.countre(ham_train, ham_words, smoothing=toolkit.ONE)[0]))
    p_w_spam = defaultdict(lambda: toolkit.ZERO, zip(spam_words,
            toolkit.countre(spam_train, spam_words, smoothing=toolkit.ONE)[0]))
    #for word in all_words:
    #    if type(p_w_ham[word]) != toolkit.NUM or type(p_w_spam[word]) != toolkit.NUM:
    #        print p_w_ham[word], p_w_spam[word], word
    #return range(0, 100)
    mut_inf = dict()
    maxlog = math.log(toolkit.MAX)
    def no_error(x, y):
        try:
            return math.log(x / y)
        except Exception:
            return maxlog
    for word in all_words:
        p_w_h = p_w_ham[word]
        #if type(p_w_h)() == list() or type(p_w_s)() == list:
        #    print "'" + word + "'"
        #else:
        #    print "*",
        p_nw_h = toolkit.ONE - p_w_h
        p_w_s = p_w_spam[word]
        p_nw_s = toolkit.ONE - p_w_s
        p_w = p_w_h * toolkit.PRIOR_HAM + p_w_s * toolkit.PRIOR_SPAM
        p_nw = toolkit.ONE - p_w
        log_w_h = no_error(p_w, p_w_h)
        log_nw_h = no_error(p_nw, p_nw_h)
        log_w_s = no_error(p_w, p_w_s)
        log_nw_s = no_error(p_nw, p_nw_s)
        mut_inf[word] = p_w_h * toolkit.PRIOR_HAM * log_w_h
        mut_inf[word] += p_nw_h * toolkit.PRIOR_HAM * log_nw_h
        mut_inf[word] += p_w_s * toolkit.PRIOR_SPAM * log_w_s
        mut_inf[word] += p_nw_s * toolkit.PRIOR_SPAM * log_nw_s
    return sorted(mut_inf.iteritems(), key=operator.itemgetter(1), reverse=True)

if __name__ == "__main__":
    print best_features()[-20:]
