# -*- coding: utf-8 -*-
"""
Created on Fri Mar  3 13:42:23 2017

@author: ZIQIAOLIU
"""

###################################################
####Feature Selection by using Lasso Regression####
###################################################
from sklearn import linear_model
import numpy as np
import pandas as pd 

##creat a lasso instance
lasso = linear_model.Lasso(alpha = 1e-3) 
##fit a lasso model
lasso.fit(x, y)

## get coefficients
print lasso.coef_

## check feature selection results, which ones have been calcelled
lasso_feature = zip(x,lasso.coef_)
dtype = [('feature', 'S20'), ('importance', 'float')]
lasso_feature= np.array(lasso_feature, dtype = dtype)
lasso_feature_sort = np.sort(lasso_feature, order='importance')[::-1]
lasso_feature_sort

m = [i for i in lasso_feature if i[1] == 0]

##extract the feature names which should be deleted
n=[i for (i, j) in m]

##########Feature Plan 1#########
##create new features based on lasso selection results
f1_x=x
f1_x.drop(n, axis=1)

#####
#[('NationalITyEgypt', 0.0),
# ('NationalITyIran', 0.0),
# ('NationalITyJordan', -0.0),
# ('NationalITySyria', 0.0),
# ('NationalITylebanon', 0.0),
# ('NationalITyvenzuela', 0.0),
# ('PlaceofBirthIran', 0.0),
# ('PlaceofBirthJordan', 0.0),
# ('PlaceofBirthKuwaIT', -0.0),
# ('PlaceofBirthSyria', 0.0),
# ('PlaceofBirthTunis', 0.0),
# ('PlaceofBirthlebanon', 0.0),
# ('PlaceofBirthvenzuela', 0.0),
# ('StageIDHighSchool', 0.0),
# ('StageIDMiddleSchool', -0.0),
# ('StageIDlowerlevel', 0.0),
# ('GradeIDG-02', 0.0),
# ('GradeIDG-10', 0.0),
# ('GradeIDG-11', 0.0),
# ('GradeIDG-12', 0.0),
# ('SectionIDB', 0.0),
# ('SectionIDC', 0.0),
# ('TopicChemistry', 0.0),
# ('TopicQuran', -0.0),
# ('TopicSpanish', -0.0),
# ('SemesterS', 0.0),
# ('RelationMum', 0.0)]

####
#StageID could be totally removed
###




