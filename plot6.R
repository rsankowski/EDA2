## download data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dir.create("./EDA2")
setwd("./data/EDA2/")
download.file(url,destfile="./data.zip", method = "curl")

##unzip
data <- unzip ("data.zip", exdir = "./")

##read tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
head(SCC)
summary(SCC$EI.Sector)
head(NEI)

##join the 2 data frames by SCC
library(plyr)
library(dplyr) 
tbl_df(NEI) 
tbl_df(SCC)
NEI2 <- join(NEI, SCC, by = "SCC")


## subset for LA and Baltimore and take annual emission means
em2 <- NEI2 %>% filter(grepl("24510|06037", fips)) %>% filter(grepl('Vehicles', EI.Sector)) 
df <- ddply(em2, c("fips", "year"), summarise, median = median(Emissions))
##again I take medians in order not to be misled by outliers

##turn fips into actual city names
df$fips <- revalue(df$fips, c("06037" = "Los Angeles County", "24510" = "Baltimore City"))

##plot Vehicle related Emissions after og transformation to make them more comparable
library(ggplot2)
g <- qplot(year, log(median), data = df, facets = . ~ fips)
g + theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ##modify x-axis labels
  xlab("year") + ylab("log(median PM2.5 Emission)")+ ##add axis labels
  labs(title = "Median Annual Vehicle Emissions")+ ##add title
  geom_smooth() ##add line
##save the plot
dev.copy(png, file = "plot6.png")
dev.off()
## Answer to Q6: Emissions from motor vehicles have declined in Baltimore between
## 1999 and 2002 and increase slightly between 2005 and 2008, LA had a decline between 1999 and 2002 
## followed by an increase between 2002 and 2008

