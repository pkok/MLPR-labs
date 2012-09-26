"""
Contains the code which is asked for in section 3 of assignment 2.

Classes are represented by their folder paths.
"""
import os

import toolkit

TEST = 'test'
TRAIN = 'train'
HAM = os.curdir + os.sep + 'ham' + os.sep
SPAM = os.curdir + os.sep + 'spam' + os.sep

def instance_prob(instance, features, clss, train=True):
    """
    Corresponds to p(x | C_k) from the assignment.
    
    The instance is a message, which is either of clss HAM or clss SPAM.
    features is a collection of (compiled) regular expressions.  If applied to
    the instance, we compute for every feature, if it occurs in the instance.
    We divide that number by how many training/testing instances of the class
    match against the feature.

    ``The probability of an observation (i.e., an email) given the class (i.e., 
    ham or spam), p(x|Ck ) is then modelled as the probability of seeing
    specific keywords in the email.''
    """
    folder = clss
    if train:
        folder += TRAIN
    else:
        folder += TEST
    # this cant be right, countre can contain zero when a regular expression does not occur
    countre_result = countre(folder, features)[0]
    assert not(Decimal(0) in countre_result)
    return map(lambda x, y: x / y, presentre(instance, features), countre_result)



def clss_prob(clss, instance, features, train=True):
    """
    Corresponds to p(C_k | x) from the assignment.

    This is computed with Bayes' theorem:
        p(C_k | x) = p(x | C_k) p(C_k) / p(x)
                   = p(x | C_k) p(C_k) / (p(x | HAM) p(HAM) 
                        + p(x | SPAM) p(SPAM))

    p(x | C_k) can be computed with instance_prob.  p(C_k) is given by
    dividing the number of messages of one kind by the total number of
    messages.
    """
    ham_folder = ham
    spam_folder = spam

    #if train:
    #    ham_folder += TRAIN
    #else:
    #    ham_folder += TEST
    ham_folder += TRAIN if train else TEST

    ham_prob = toolkit.NUM(len(get_files(ham_folder)))
    spam_prob = toolkit.NUM(len(get_files(spam_folder)))
    file_count = ham_prob + spam_prob
    ham_prob /= file_count
    spam_prob /= file_count

    instance_ham_prob = instance_prob(instance, features, HAM, train)
    instance_spam_prob = toolkit.ONE - instance_ham_prob
    if clss == HAM:
        return instance_ham_prob * ham_prob / class_prior_prob(clss, train)
    return instance_spam_prob * spam_prob  / class_prior_prob(clss, train)



def class_prior_prob(clss, train=True):
    """
    Corresponds to p(C_k) from the assignment.

    The assignment warns you to base this prior on the number of ham and spam
    messages, as that might not represent the real probability.  The samples
    might be drawn from different distributions.

    We still have to collect this data from a better statistic.  These numbers
    are just guesses from Patrick.
    """
    if clss == HAM:
        return toolkit.NUM(0.7)
    return toolkit.ONE - class_prior_prob(clss, train)
