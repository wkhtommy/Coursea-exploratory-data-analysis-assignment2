# 0. Get and load the data
if (!file.exists("exdata%2Fdata%2FNEI_data.zip")){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileURL, "exdata%2Fdata%2FNEI_data.zip")
}  

if (!file.exists("Source_Classification_Code.rds") & !file.exists("summarySCC_PM25.rds")){
        unzip("exdata%2Fdata%2FNEI_data.zip") 
}

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

sumByYear <- with(NEI,tapply(Emissions,year,sum))

png("plot1.png")
plot(c(1999,2002,2005,2008),sumByYear,xlim = c(1999,2008),xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Total PM2.5 Emission by Year", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), sumByYear[1:3],c(2002,2005,2008),sumByYear[2:4], lwd = 2)
dev.off()
