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


def classify(filename):
    return classify_str(file_to_str(filename))


def classify_str(instance):

    return SPAM


def instance_prob(instance, features, clss, train=True, smoothing=0):
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
    return toolkit.prod(instance_feature_prob(instance, features, clss,
        train=train, smoothing=smoothing))


def instance_feature_prob(instance, features, clss, train=True, smoothing=0):
    """
    Corresponds to [p(x_i | C_k) for x_i in x] from the assignment.
    
    The instance is a message, which is either of clss HAM or clss SPAM.
    features is a collection of (compiled) regular expressions.  If applied to
    the instance, we compute for every feature, if it occurs in the instance.
    We divide that number by how many training/testing instances of the class
    match against the feature.

    ``The probability of an observation (i.e., an email) given the class (i.e., 
    ham or spam), p(x|Ck ) is then modelled as the probability of seeing
    specific keywords in the email.''
    """
    folder = clss + TRAIN if train else clss + TEST
    countre_result = toolkit.countre(folder, features, smoothing=smoothing)[0]
    feature_presence = toolkit.presentre(instance, features) 
    return map(lambda c, p: 1 if c == toolkit.ZERO and p == toolkit.ZERO else pow(c, p) * pow(1 - c, 1 - p), countre_result, feature_presence)


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
    ham_folder = HAM + (TRAIN if train else TEST)
    spam_folder = SPAM + (TRAIN if train else TEST)

    # calculating P(C_k)
    ham_prob = toolkit.NUM(len(toolkit.get_files(ham_folder)))
    spam_prob = toolkit.NUM(len(toolkit.get_files(spam_folder)))
    file_count = ham_prob + spam_prob
    ham_prob /= file_count
    spam_prob /= file_count #(here we CAN do 1 - ham_prob, right?)

    # getting P(x|C_k)
    instance_ham_prob = instance_prob(instance, features, HAM, train)
    instance_spam_prob = instance_prob(instance, features, SPAM, train)
    
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
        return toolkit.PRIOR_HAM
    return toolkit.PRIOR_SPAM


if __name__ == "__main__":
    print clss_prob(SPAM, 'spam/train/02', ["Africa"])
    #print instance_prob('spam/test/01', ['Africa', 'valued', 'good day'], SPAM)
