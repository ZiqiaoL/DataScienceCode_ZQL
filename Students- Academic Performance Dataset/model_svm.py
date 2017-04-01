# -*- coding: utf-8 -*-
"""
Created on Fri Mar  3 15:47:47 2017

@author: ZIQIAOLIU
"""
"""
###################################
#####Support Vector Machine########
###################################
"""

from sklearn import svm
from sklearn.metrics import classification_report
import sklearn.metrics
import sklearn.grid_search as gs
import sklearn.cross_validation as cv
from sklearn.metrics import classification_report
import sklearn.metrics


x_train, x_test, y_train, y_test = cv.train_test_split(x, y,
    test_size = 0.2, random_state = 123)

"""
build an instance
"""
svm_model = svm.SVC()
svm_model.set_params(degree = 1)
svm_model.fit(x_train, y_train)
svm_model.score(x_train, y_train)

print "The training error of svm is: %.5f" % (1 - svm_model.score(x_train, y_train))
print "The test     error of svm is: %.5f" % (1 - svm_model.score(x_test, y_test))

"""
The training error of svm is: 0.01562# The test error of svm is: 0.36458
"""

"""
#####Model Performance Evulation####
"""
predictions_svm = svm_model.predict(x_test)
print sklearn.metrics.confusion_matrix(y_test, predictions_svm)
"""
[[15 14 0]
[1 37 3]
[0 17 9]]
"""
print sklearn.metrics.accuracy_score(y_test, predictions_svm)
"""
0.635416666667
"""

"""
Using grid search on svm model
"""

grid_para_svm = [{
    'C': [1, 10, 100, 1000],
    'kernel': ['poly'],
    'degree': [1, 2, 3]
}, \ {
    'C': [1, 10, 100, 1000],
    'gamma': [0.001, 0.0001],
    'kernel': ['rbf']
}]

grid_search_svm = gs.GridSearchCV(svm_model, grid_para_svm, scoring = 'accuracy', cv = 3)
grid_search_svm.fit(x, y)
print grid_search_svm.grid_scores_
print grid_search_svm.best_params_# {
    'kernel': 'poly',
    'C': 10,
    'degree': 1
}
print grid_search_svm.best_score_
"""
0.658333333333
"""