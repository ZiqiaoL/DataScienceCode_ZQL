
#clear workspace
rm(list = ls())

# load packages
library(dplyr)
library(ggplot2)
library(scales)
library(RColorBrewer)
library(ggthemes)

# load data
house_0 = read.csv("~/Downloads/train.csv")

# remove outliers

house_1 = filter(house_0, GrLivArea < 4000)

# remove data with year 2010, since the dataset doesn not contain data after July 2010

house_2 = filter(house_1, YrSold != '2010')

# subset data
names = c(
  "MSZoning",
  "HouseStyle",
  "OverallQual",
  "YearBuilt",
  "Foundation",
  "MoSold",
  "YrSold",
  "SalePrice"
)

house_data = house_2[, names]

# plot1: House Sale Price vs. Year, House Style
# geom_point pch: set the point shape
# geom_point cex: size of the shape
# http://www.cookbook-r.com/Graphs/Shapes_and_line_types/
# scale_color_manual : manually set color 

g1 = ggplot(data = house_data, aes(x = YearBuilt, y = SalePrice))

plot1 = g1 + geom_point(
  aes(color = HouseStyle),
  position = "jitter",
  pch = 8,
  cex = .8
) +
  geom_smooth(method = 'lm', size = 0.5, se = T) +
  scale_y_continuous(labels = comma) +
  ggtitle(" House Sale Price Trend ") +
  ylab("Sale Price ($)") +
  xlab("House Built Year") +
  scale_color_manual(
    values = c(
      '#fc8d62',
      '#dfc27d',
      '#7fbc41',
      '#80cdc1',
      '#a6cee3',
      '#4eb3d3',
      '#984ea3',
      '#e7298a'
    ),
    name = "House Style",
    labels = c(
      "1.5-Story",
      "1.5-Story(U)",
      "1-Story",
      "2.5-Story",
      "2.5-Story(U)",
      "2-Story",
      "Split Foyer",
      "Split Level"
    )
  )

plot1

#plot2: research house market trends of different house styles
#subset data

n_1 = c('2Story', '1Story', '1.5Fin')
n_2 = c('2.5Unf', '2.5Fin', '1.5Unf', 'SFoyer', 'SLvl')

house_n_1 = house_data %>% filter(., HouseStyle %in% n_1)
house_n_2 = house_data %>% filter(., HouseStyle %in% n_2)

#plot2_1: n_1 souse styles
# labels = comma : format axis tick labels with commas 

g2_1 = ggplot(data = house_n_1, aes(x = YearBuilt, y = SalePrice, color = HouseStyle))

plot2_1 = g2_1 + 
  geom_point(aes(color = HouseStyle), position = "jitter",
  pch = 8,cex = .3 ) +
  geom_smooth(method = 'lm', size = 1.0, se = FALSE) +
  scale_y_continuous(labels = comma) +
  theme(legend.position = "bottom") +
  ggtitle(" House SalePrice Trend for HouseStyles") +
  ylab("Sale Price ($)") +
  xlab("House Built Year") +
  scale_color_manual(
    values = c('#fc8d62', '#7fbc41', '#4eb3d3'),
    name = "House Style",
    labels = c("1.5-Story", "1-Story",
               "2-Story")
  )

plot2_1

#plot2_2: n_2 house styles

g2_2 = ggplot(data = house_n_2, aes(x = YearBuilt, y = SalePrice, color = HouseStyle))

plot2_2 = g2_2 + 
  geom_point(aes(color = HouseStyle), position = "jitter",
  pch = 8,cex = .3) +
  geom_smooth(method = 'lm', size = 1.0, se = FALSE) +
  scale_y_continuous(labels = comma) +
  ggtitle(" House SalePrice Trend for HouseStyles") +
  ylab("Sale Price ($)") +
  xlab("House Built Year") +
  scale_color_manual(
    values = c('#dfc27d', '#80cdc1', '#a6cee3', '#984ea3', '#e7298a'),
    name = "House Style",
    labels = c("1.5-Story(U)","2.5-Story","2.5-Story(U)",
                "Split Foyer","Split Level"))

plot2_2


# plot 3: barplot shows median saleprice, sale amount vs. year
# scale_fill_gradient: order the legend

house_yrsold = house_data %>% select(., YrSold, SalePrice) %>%
                group_by(., YrSold) %>% 
                summarise(., total = n(), median_p = median(SalePrice))

house_yrsold$YrSold <-factor(house_yrsold$YrSold,
                      levels = reorder(house_yrsold$YrSold, -house_yrsold$total))

g3 = ggplot(data = house_yrsold, aes(x = YrSold, y = total))

plot3 = g3 + 
        geom_bar(aes(fill = median_p), stat = "identity") +
        scale_fill_gradient(guide = "colorbar",high = "#132B43",
                            low = "#56B1F7",name = "Median Price($)") +
        geom_text(aes(label = median_p),size = 4,hjust = 0.5, vjust = -0.3) +
        xlab(" ") +
        ylab("Number of Houses Sold") +
        ggtitle(" House Sale vs. Year")

plot3


#plot4: check monthly house salerices and amount 
#scale_fill_continuous

house_mosold = house_data %>% select(., YrSold, MoSold, SalePrice) %>%
                group_by(., MoSold) %>% 
                summarise(., total = n(), median_p = median(SalePrice))

house_mosold$MoSold <-factor(house_mosold$MoSold,
                      levels = reorder(house_mosold$MoSold,-house_mosold$total))

g4 = ggplot(data = house_mosold, aes(x = MoSold, y = total))

plot4 = g4 + geom_bar(aes(fill = median_p), stat = "identity") +
        geom_text( aes(label = median_p),size = 3.5,
                    hjust = 0.5,vjust = -0.3) +
        scale_fill_continuous(guide = "colorbar",low = "#56B1F7",
                              high = "#132B43",name = "Median Price($)") +
        xlab("") +
        ylab("Number of Houses Sold") +
        scale_x_discrete(labels = c("Jan","Feb","Mar","Apr","May","Jun",
                                    "Jul","Aug","Sep","Oct","Nov","Dec" )) +
        ggtitle("Houses Sale vs. Sold Month")

plot4


#plot5: violin plot shows house zone vs. saleprice

plot5 = ggplot(data = house_data, 
               aes(x = reorder(MSZoning, SalePrice, median), y =SalePrice)) +
        geom_violin(aes(fill = MSZoning)) + 
        scale_y_continuous(labels = comma) +
        xlab("House Location Zone ") +
        ylab("Sale Price ($)") +
        ggtitle("General House Location Zone vs. Sale Price") +
        scale_fill_manual(values = c('#66c2a5', '#fc8d62', '#8da0cb', '#e78ac3', '#a6d854'),
                          name = " ",
                          labels = c("Others","Floating Village","Residential High Density",
                                      "Residential Low Density","Residential Medium Density"))+
        scale_x_discrete(labels = c("Others", "RM", "RH", "RL", "FV")) +
        theme(legend.position = "bottom")

plot5

#plot6: explored foundation material for high price house

house_data$OverallQual = as.factor(house_data$OverallQual)

house_overqual = house_data %>% 
                  select(., OverallQual, SalePrice, Foundation) %>%
                  group_by(., OverallQual)

g6 = ggplot(data = house_overqual, aes(x = OverallQual))

plot6 = g6 + geom_bar(aes(fill = Foundation), position = "fill") +
        theme(legend.position = "bottom") +
        scale_fill_manual(values = c('#66c2a5','#fc8d62','#8da0cb',
                                     '#e78ac3','#a6d854','#ffd92f'),
        name = "Foundation",
        labels = c("Poured Concrete","Cinder Block","Brik&Tile",
                    "Slab","Stone","Wood")) +
        xlab("Overall Quality") +
        ylab("Percent") +
        ggtitle("House Foundation VS. Overall House Quality ")

plot6
