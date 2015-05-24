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

##plot 2
library(dplyr) 
library(plyr)
tbl_df(NEI) 

##summarize Emissions by type and year
df <- ddply(NEI, c("type", "year"), summarise,
               median = median(Emissions)) ##I take medians in order not to be misled by outliers

##plot Emissions based on type
##note: in order to have all data visible in the same scale I take the log of the means
library(ggplot2)
g <- qplot(year, log(median), data = df, facets = . ~ type)

g + theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ##modify x-axis labels
  xlab("Emission Source") + ylab("log(median PM2.5 Emission")+ ##add axis labels
  labs(title = "Median pm2.5 emission based on Source")+ ##add title
  geom_smooth() ##add regression line

##save the plot
dev.copy(png, file = "plot3.png")
dev.off()
## Answer to Q3: Point emissions have declined strongly in the observed time;
##Non-Road emissions and On-Road emissions have declined strongly between 1999 and 2002
##and have declined less in the following years;
## Nonpoint emissions have declined between 199 and 2002 and have risen since.