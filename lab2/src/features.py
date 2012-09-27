"""
Feature selection algorithms.

This comprises section 2 of lab assignment 2.
"""

import operator

import toolkit

def strip_word(word):
    w = word.lower().strip()
    w = "".join(filter(lambda x: x.isalpha(), w))
    return w


def compare_words(n):
    """ Attempts to analyse the spam and ham data to find good
    features and tries to print relevant information about the data """

    # set folders
    spam_folder = 'spam/train'
    ham_folder = 'ham/train'

    # get all the words in the folders
    spam_words = toolkit.count_words(spam_folder)
    ham_words = toolkit.count_words(ham_folder)

    # calculate file statistics {{{
    number_of_spam_files = len(toolkit.get_files(spam_folder))
    number_of_ham_files = len(toolkit.get_files(ham_folder))
    total_files = (number_of_spam_files+number_of_ham_files)
    spam_files_percentage = number_of_spam_files/float(total_files) * 100
    ham_files_percentage = 100 - spam_files_percentage

    # calculate word statistics
    number_of_spam_words = reduce(lambda x, y: x + y, spam_words.itervalues())
    number_of_ham_words = reduce(lambda x, y: x + y, ham_words.itervalues())
    total_words = number_of_spam_words + number_of_ham_words 
    spam_words_percentage = number_of_spam_words/total_words * 100
    ham_words_percentage = 100 - spam_words_percentage 

    # print information
    print 'spam files: %d (%.2f%%)' % (number_of_spam_files, spam_files_percentage)
    print 'ham files: %d (%.2f%%)\n' % (number_of_ham_files, ham_files_percentage)
    print 'spam words: %d (%.2f%%)' % (number_of_spam_words, spam_words_percentage)
    print 'ham words: %d (%.2f%%)\n' % (number_of_ham_words, ham_words_percentage) 

    ## sort dictionaries
    #sorted_spam_words = sorted(spam_words.iteritems(), key=operator.itemgetter(1), reverse=True)
    #sorted_ham_words = sorted(ham_words.iteritems(), key=operator.itemgetter(1), reverse=True)
    #print "=======HAM"
    #print_dict(sorted_ham_words[1:n+1])
    #print "=======SPAM"   
    #print_dict(sorted_spam_words[1:n+1]) # }}}

    # create a list containing all unique words
    words = ham_words.keys()
    words.extend(filter(lambda x: not(x in words), spam_words.iterkeys()))
    print "Unique words: %d\n" % len(words)


    # create a dictionairy with all the words, the values are tuples
    # of the percentage of words for (spam, ham). 
    words_dict = {}
    for w in words:
        words_dict[strip_word(w)] = map(lambda x, y: x * toolkit.PRIOR_SPAM + 
            y * toolkit.PRIOR_HAM, 
            words_dict.get(strip_word(w), (0, 0)), (spam_words.get(w, 0) /
            number_of_spam_words, ham_words.get(w, 0)/number_of_ham_words))
  
    # find out which words are enthousiastically represented in ham and spam
    ratio_dict = {}
    for item in words_dict.items():
        ratio_dict[item[0]] = item[1][0] - item[1][1] 
    ratio_dict = sorted(ratio_dict.iteritems(), key=operator.itemgetter(1), reverse=True)
    
    print "SPAM"
    for sl in ratio_dict:
        print "'%s',\t\t%f" % (sl[0], sl[1])
    print "HAM"
 

def print_dict(sorted_list):
    for sl in sorted_list:
        print "'", sl[0], "'\t\t", sl[1]

if __name__ == "__main__":
    compare_words(50)
