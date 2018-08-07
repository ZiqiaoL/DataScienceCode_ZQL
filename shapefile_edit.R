
# ma = read.csv("~/Projects/StormAnalysisCoordination/ma_whole.csv", stringsAsFactors = F)
# days = unique(as.Date(ma[,2]))
# station = unique(ma$StationId)
# sum(is.nan(ma$WindGustKphHourly))

path = "~/Projects/EV_mapping/zipcode_shapefile/"
library(foreign)
dbfdata <- read.dbf("~/Projects/EV_mapping/zipcodes_shapefile/ZIPCODES_NT_POLY.dbf", as.is = TRUE)
# test effects of adding a new data column
#dbfdata$ev = runif(length(dbfdata$POSTCODE), min=0, max=100)
#unique(dbfdata$POSTCODE)
#523 zipcodes
#test = dbfdata[!duplicated(dbfdata[,c('POSTCODE', 'COUNTY')]),]
# with the combination of POSTCODE, COUNTY, the record is not duplicate

# read ev data with zipcode
# read ev data from excel
# require(xlsx)
# ev = read.xlsx("~/Projects/EV_mapping/Polk_ng_zip_Oct_1_2017.xlsx", 
#                sheetName = "ng_zip", stringsAsFactors=FALSE)
ev_path = "~/Projects/EV_mapping/code_sql/test_final.csv"
ev = read.csv(ev_path,stringsAsFactors=FALSE)
# subset rows with elec_type in BEV, PHEV which are the mapping requirements
ev$TYPE = with(ev, ifelse(ev$FUEL_TYPE == "ELECTRIC AND GAS HYBRID", "PHEV", "BEV"))

selectedRows = (ev$TYPE == 'BEV'| ev$TYPE == 'PHEV')
ev = ev[selectedRows, ]
#make up missing lead 0
ev$ZIP_CODE = sapply(ev$ZIP_CODE, function(x){if(nchar(x)<5){paste0(0,x)}else{x}})
ev$STATE_NAME="MA"

library(dplyr)
ev1 <- ev %>%
  group_by(ZIP_CODE, STATE_NAME, COUNTY_NAME, TYPE) %>%
  summarise(TOTAL = sum(TOTAL))

unique(ev$ZIP)
# result1 :group by zipcode and sum YR 2017


# result2: gropu by zipcode, ELEC_TYPE, and then sum 2 cols with different ev type
library(reshape2)

ev_result2 = dcast(ev1, ZIP_CODE + COUNTY_NAME ~ TYPE,fun=sum, value.var ="TOTAL") # correct
#sum(ev_result2$TOTAL)

# change column names of ev_result2
colnames(ev_result2) = c("POSTCODE","COUNTY","BEV","PHEV")
ev_result2$TOTAL = ev_result2$BEV + ev_result2$PHEV
#sum(ev_result2$TOTAL)
#[1] 11303 #508 zipcodes unique(ev_result2$POSTCODE)

#test = ev_result2[!duplicated(ev_result2[,c('POSTCODE', 'COUNTY')]),]
# 517 unique POSTCODE, COUNTY COMBO, no duplicates

# left join on shapfile data
#dbfdata_t= merge(x = dbfdata, y = ev_result2, by = c("POSTCODE", "COUNTY"), all.x = TRUE)
# remove rows with duplicate zipcode

dbfdata1 <- left_join(dbfdata, ev_result2, by = c("POSTCODE", "COUNTY")) 
# may not correct, has error data mismatch
#write.dbf(dbfdata1,"~/Projects/EV_mapping/ZIPCODES_NT_POLY.dbf",factor2char = T)
# > sum(ev_result2$TOTAL, na.rm=T)
# [1] 11303
# > sum(dbfdata1$TOTAL, na.rm=T)
# [1] 11246
# some postcode, county in ev_result2 do not exist in dbfdata

# which postcode, county do not exist?
b = dbfdata[,c("POSTCODE", "COUNTY")]
a = ev_result2[,c("POSTCODE", "COUNTY")]

match =merge(a, b, by.x=c("POSTCODE", "COUNTY"), by.y=c("POSTCODE", "COUNTY"))
# zipcode exist in ev_result2 but do not exist in dbfdata
mismatch = a[!(a$POSTCODE %in% match$POSTCODE),]
# 19 zipcodes in ev_result2 but do not exist in dbfdata
mis_ev = merge(ev_result2, mismatch, 
               by.x=c("POSTCODE", "COUNTY"),by.y=c("POSTCODE", "COUNTY"))

mis_ev_wraw = merge(ev,mismatch, 
                    by.x=c("ZIP_CODE", "COUNTY_NAME"),by.y=c("POSTCODE", "COUNTY"))

library(rgdal)
path_shape = "~/Projects/EV_mapping/data_shapefile_zipcode/zipcodes_nt"
setwd(path_shape)
shape_file<- readOGR('.')
plot(shape_file)
#add new data to it
summary(shape_file)
shape_file$BEV = dbfdata1$BEV
shape_file$PHEV = dbfdata1$PHEV
shape_file$TOTAL = dbfdata1$TOTAL

path_export = "~/Projects/EV_mapping/data_shapefile_zipcode/test"
setwd(path_export)
writeOGR(obj=shape_file, dsn=".", layer="ZIPCODES_NT_POLY", driver="ESRI Shapefile")

# check the raw data
path_raw = "~/Projects/EV_mapping/data_ev_polk_raw_data/NGRID_VIO_1710_to_1710.csv"
raw = read.csv(path_raw,stringsAsFactors=FALSE)
raw$ZIP = sapply(raw$ZIP_CODE, function(x){if(nchar(x)<5){paste0(0,x)}else{x}})
# raw= raw[raw$STATE=="MASSACHUSETTS",]
sum(raw$ZIP == "02457")  # get 0
sum(raw$ZIP== "02481")  # get 190
sum(raw$ZIP=="02482") 
sum[raw$ZIP=="02482" & raw$PLUG_IN =="PLUG IN"]

write.csv(mis_ev, "mis_ev.csv")
