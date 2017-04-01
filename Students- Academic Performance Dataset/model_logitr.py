# -*- coding: utf-8 -*-
"""
Created on Fri Mar  3 15:57:13 2017

@author: ZIQIAOLIU
"""

"""
###############################
####Logistic Regression########
###############################
"""

from sklearn import linear_model
from sklearn.metrics import classification_report
import sklearn.metrics
import sklearn.cross_validation as cv
from sklearn.cross_validation import train_test_split


x_train, x_test, y_train, y_test = cv.train_test_split(x, y, 
                                                       test_size=0.2, random_state=123)
                                                       
"""                                                      
build an instance  
"""                                               
logit = linear_model.LogisticRegression(C=1e4)                                                   
logit.fit(x_train, y_train)


print "The training error of logistic regression is: %.5f" %(1- logit.score(x_train, y_train)) 
print "The test  error of logistic regression is: %.5f"  %(1- logit.score(x_test, y_test))
"""
The training error of logistic regression is: 0.16667
The test  error of logistic regression is: 0.31250
"""

print logit.intercept_

"""
Model Performance Evulation
"""
predictions=logit.predict(x_test)
print sklearn.metrics.confusion_matrix(y_test,predictions)
"""
([[24,  5,  0],
  [ 2, 27, 12],
  [ 1, 10, 15]])
"""
print sklearn.metrics.accuracy_score(y_test, predictions)  
"""     
0.6875
"""