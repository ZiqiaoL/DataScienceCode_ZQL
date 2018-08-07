# -*- coding: utf-8 -*-
"""
Created on Thu Dec 21 11:18:58 2017

@author: liuziq
"""
path = 'C:\Users\liuziq\Documents\Projects\EV_mapping\\'
path1 = 'C:\Users\liuziq\Documents\Projects\EV_mapping\Polk_ng_zip_Oct 1 2017_test.csv'
path2 = 'C:\Users\liuziq\Documents\Projects\EV_mapping\location_master.csv'

import pandas as pd
polk = pd.read_csv(path1)
# subset ev at MA
polk = polk.loc[polk['STATE']=='MA']
location = pd.read_csv(path2)
# location data includes new england area data
# match geo locations with zipcode and get coordinates
results = polk.join(location, lsuffix = 'zip', rsuffix='zipcode')
results = results.loc[results['STATEzipcode']=='MA']
results.to_csv(path+'polk_location.csv')


path3 = 'C:\Users\liuziq\Documents\Projects\EV_mapping\polk_data\NGRID_VIO_1710_to_1710.csv'
polk_raw = pd.read_csv(path3)
polk_raw = polk_raw.loc[polk_raw['STATE_NAME']=='MASSACHUSETTS']
#polk_pro = 