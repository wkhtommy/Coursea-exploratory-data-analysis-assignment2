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


# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

Baltimore <- NEI[NEI$fips == "24510",]
BaltimoreByYear <- with(Baltimore,tapply(Emissions,year,sum))

png("plot2.png")
plot(c(1999,2002,2005,2008),BaltimoreByYear,xlim = c(1999,2008),ylim = c(min(BaltimoreByYear),max(BaltimoreByYear)) ,xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Baltimore PM2.5 Emission by Year", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), BaltimoreByYear[1:3],c(2002,2005,2008),BaltimoreByYear[2:4], lwd = 2)
dev.off()

