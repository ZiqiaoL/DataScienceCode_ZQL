# edit shapefile from census


path = "~/Projects/EV_mapping/zt25_d00_shp/"
library(foreign)
dbf_esri <- read.dbf("~/Projects/EV_mapping/zt25_d00_shp/zt25_d00.dbf", as.is = TRUE)

library(rgdal)
path_shape = "~/Projects/EV_mapping/zt25_d00_shp/"
path_shape_ny = "~/Projects/EV_mapping/tl_2015_us_zcta510/"
setwd(path_shape_ny)
shape_file_ny<- readOGR('.')
plot(shape_file_ny)
summary(shape_file_ny)
shape_file_ny$GNIS_ID

# conver shapefile to a dataframe
shape_file_ny.df <- as(shape_file_ny, "data.frame")
# filter out ny state
# read ny state info 
ny_path = "~/Projects/EV_mapping/geocorr14.csv"
ny = read.csv(ny_path,stringsAsFactors=FALSE, skip=1)
ny$zipname = gsub(", NY", "", ny$zipname)
ny$ZIP.Census.Tabulation.Area = as.factor(ny$ZIP.Census.Tabulation.Area)

ny_shape = merge(ny, shape_file_ny.df, 
               by.x=c("ZIP.Census.Tabulation.Area"),by.y=c("ZCTA5CE10"))
ny_shape = left_join(shape_file_ny.df, ny,
                 by =c("ZCTA5CE10" ="ZIP.Census.Tabulation.Area"))

shape_file_esri$BEV = dbf_esri1$BEV
shape_file_esri$PHEV = dbf_esri1$PHEV
shape_file_esri$TOTAL = dbf_esri1$TOTAL


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
