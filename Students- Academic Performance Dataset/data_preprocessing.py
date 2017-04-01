# -*- coding: utf-8 -*-
"""
Created on Fri Mar  3 13:38:21 2017

@author: ZIQIAO CHERYL LIU
"""

import pandas as pd

ADP_data = pd.read_csv("~/Downloads/xAPI-Edu-Data.csv", index_col=False)
print (ADP_data.head(5))

ADP_num= ADP_data.iloc[:,9:13]
print (ADP_num.head(5))

ADP_cat1 = ADP_data.iloc[:,:9]
print (ADP_cat1.head(5))

ADP_cat2 = ADP_data.iloc[:,13:16]
print (ADP_cat2.head(5))

ADP_cat= pd.concat([ADP_cat1,ADP_cat2],axis=1)

cat_dummy=pd.DataFrame([])
for i in range(0,12):
    print i
    tmp=pd.get_dummies(ADP_cat.iloc[:,i])
    tmp.columns = ADP_cat.columns[i] + tmp.columns
    cat_dummy=pd.concat([cat_dummy.reset_index(drop=True),tmp],axis=1)
    
print (cat_dummy.head(5))

ADP_data.Class =ADP_data.Class.astype('category')
class_order = {'H':3, 'M':2, 'L':1}
ADP_data.Class =ADP_data.Class.map(class_order)

x = pd.concat([cat_dummy.reset_index(drop=True),ADP_num],axis=1)
print (x.head(5))
y = ADP_data.Class