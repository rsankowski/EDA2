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
em <- NEI2 %>% filter(grepl('Coal', EI.Sector)) %>% group_by(year) %>% summarize(median(Emissions))
##I take the medians in order not to be missled by outliers

##plot coal related Emissions 
par(mfrow = c(1,1), mar = rep(c(4,5), 2))
plot(em, pch=20, main = "Median Emissions of Coal-related Fuel Sources")
lines(em$year, em$median)

##save the plot
dev.copy(png, file = "plot4.png")
dev.off()
## Answer to Q4: Emissions from Coal related sources have declined between
## 1999 and 2002 and increased after
