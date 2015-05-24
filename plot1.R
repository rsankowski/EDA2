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
head(NEI)
str(NEI)

##plot 1
library(dplyr) 
tbl_df(NEI) 

## i group the dataset by the year and calculate the annual average emissions
em <- NEI %>% group_by(year) %>% summarize(median(Emissions))
plot(em, pch=20, main = "Average annual PM2.5 Emissions")
lines(em$year, em$median)

##save the plot
dev.copy(png, file = "plot1.png")
dev.off()
## Answer to Q1: pm2.5 values have declined between 1999 and 2008