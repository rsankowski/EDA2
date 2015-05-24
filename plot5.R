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


##summarize filter for coal related Emissions, then group by year and take means
em <- NEI2 %>% filter(grepl("24510", fips)) %>% filter(grepl('Vehicles', EI.Sector)) %>% group_by(year) %>% summarize(median(Emissions))

##plot coal related Emissions 
par(mfrow = c(1,1), mar = rep(c(4,5), 2))
plot(em, pch=20, main = "Baltimore - Median Emissions from Motor Vehicles")
lines(em$year, em$median)

##save the plot
dev.copy(png, file = "plot5.png")
dev.off()
## Answer to Q5: Emissions from motor vehicles have declined between
## 1999 and 2002 and have risen slightly after

