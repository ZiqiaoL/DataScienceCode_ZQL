# -*- coding: utf-8 -*-
"""
Created on Fri Mar  3 13:57:05 2017

@author: ZIQIAOLIU
"""
"""
###################################################
####Feature Selection by using Random Forest#######
###################################################
"""
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
from sklearn import ensemble


randomForest = ensemble.RandomForestClassifier()

"""
fit a model use random forest by using the whole data set
"""
np.random.seed(123)
randomForest.fit(x, y) 
randomForest.score(x, y)
"""
0.98958333333333337
"""
"""
check the feature importance results
"""
RF_feature= zip(x, randomForest.feature_importances_)
dtype = [('feature', 'S30'), ('importance', 'float')]
RF_feature = np.array(RF_feature, dtype = dtype)
feature_sort = np.sort(RF_feature, order='importance')[::-1]
feature_sort
[i for (i, j) in feature_sort[0:20]]

"""
visualize the feature importance by matlibplot
"""
feature_importance = randomForest.feature_importances_
feature_importance = 100.0 * (feature_importance / feature_importance.max())
sorted_idx = np.argsort(feature_importance)
pos = np.arange(sorted_idx.shape[0]) + .5
fig = plt.figure(figsize=(20, 40), dpi=800)
plt.barh(pos, feature_importance[sorted_idx], align='center')
plt.yticks(pos, x.columns[sorted_idx])
plt.xticks([10,20,30,40,50,60,70,80,90,100])
plt.xlabel('Relative Importance')
plt.title('Feature Importance -- Random Forest Results ')
plt.grid()
plt.show()

"""
##########Feature Plan 2#########
##create new features based on Random Forest analysis results
##select features with relative importnce above 10
##extract the feature names which should be deleted
"""

rf=[i for (i, j) in feature_sort[0:16]]

f2_x=x
f2_x=f2_x[rf]

