## filter lon/lat data
#https://stackoverflow.com/questions/29189241/rdstk-reverse-geocode-lat-lon-to-city-using-coordinates2politics

df <- data.frame(lat=c(34.048381, 37.757836, 40.729855, 42.356391),
                 lon=c(-118.266164, -122.441033, -73.987921, -71.062307))

library(ggmap)
res <- lapply(with(df, paste(lat, lon, sep = ",")), geocode, output = "more")
transform(df, state = sapply(res, "[[", "administrative_area_level_1"))

# test on my own data Donkin Donuts places!
# briferly fiter out impossible locations based on MA border
# lat less than 42.751134, lon above -73.489316 but includes CT area

# read the csv file contains lon, lat
cor = read.csv("~/Projects/EV_mapping/USA-DunkinDonuts.csv", stringsAsFactors = FALSE)
selectrow1 = (cor$lat <= 42.869378 & cor$lon >= -73.510576 & cor$lon<= -70.745387)
cor = cor[selectrow1, ]
# remove CT part
# lon <= -71.412188 & lat <= 41.997337
selectrow2 = (cor$lat <= 42.016766 & cor$lon <= -71.401201)
cor = cor[!selectrow2, ]
# 
res = lapply(with(cor, paste(lat, lon, sep = ",")), geocode, output = "more")

# extract address from res
x=c()
for(i in 1: length(res)){
  x1= c(res[[i]]$lon, res[[i]]$lat, res[[i]]$address)
  x = rbind(x, x1)
}
df = data.frame(x)
# remove rows has NA
df = na.omit(df)
c_names = c('lon','lat', 'address')
names(df) = c_names
# select rows address column has "ma "
df = df[grep("ma ", df$address), ]
df$Business = c("Dunkin Donuts")
# save df, whcih contains Dokin Donuts at MA
write.csv(df, file = "~/Projects/EV_mapping/DD_MA_data.csv")

# https://stackoverflow.com/questions/31893844/how-can-i-save-a-list-to-a-file-and-read-it-in-again-in-r
save(res, file="~/Projects/EV_mapping/res.RData")
