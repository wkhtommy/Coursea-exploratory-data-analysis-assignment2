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

plot(c(1999,2002,2005,2008),sumByYear,xlim = c(1999,2008),xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Total PM2.5 Emission by Year", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), sumByYear[1:3],c(2002,2005,2008),sumByYear[2:4], lwd = 2)


# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

Baltimore <- NEI[NEI$fips == "24510",]
BaltimoreByYear <- with(Baltimore,tapply(Emissions,year,sum))

plot(c(1999,2002,2005,2008),BaltimoreByYear,xlim = c(1999,2008),ylim = c(min(BaltimoreByYear),max(BaltimoreByYear)) ,xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Baltimore PM2.5 Emission by Year", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), BaltimoreByYear[1:3],c(2002,2005,2008),BaltimoreByYear[2:4], lwd = 2)


# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

YearType <- as.data.frame(with(Baltimore,tapply(Emissions,list(year, type),sum)))
YearType <- cbind(as.data.frame(c(1999,2002,2005,2008)),YearType)
names(YearType)[1] <- "Year"
require(reshape2)
YearType <- melt(YearType, id.vars="Year")
names(YearType) <- c("Year", "Type", "Value")

require(ggplot2)

ggplot(YearType, aes(Year, Value, shape = Type, color = Type)) + geom_point(size = 2.5) + geom_smooth()+ggtitle("PM2.5 Emissions (tons) By Year ")


# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

coalSource <- SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),1]
coal <- NEI[NEI$SCC %in% coalSource,]


coalByYear <- with(coal,tapply(Emissions,year,sum))

plot(c(1999,2002,2005,2008),coalByYear,xlim = c(1999,2008),xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Total PM2.5 Emission by Year (Coal Related Sources Only)", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), coalByYear[1:3],c(2002,2005,2008),coalByYear[2:4], lwd = 2)


# 5. How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

BaltimoreMotor <- Baltimore[Baltimore$type == "ON-ROAD",]
BaltimoreMotorByYear <- with(BaltimoreMotor,tapply(Emissions,year,sum))

plot(c(1999,2002,2005,2008),BaltimoreMotorByYear,xlim = c(1999,2008),xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Baltimore PM2.5 Emissions (tons) By Year (On-Road Only)", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), BaltimoreMotorByYear[1:3],c(2002,2005,2008),BaltimoreMotorByYear[2:4], lwd = 2)



# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

Motor <-  NEI[(NEI$fips == "24510" | NEI$fips == "06037") & NEI$type == "ON-ROAD",]
Motor$fips <- as.factor(Motor$fips)
MotorByYearCity <- as.data.frame(with(Motor, tapply(Emissions, list(year, fips), sum)))
MotorByYearCity <- cbind(as.data.frame(c(1999,2002,2005,2008)),MotorByYearCity)
names(MotorByYearCity) <- c("Year", "LA", "Baltimore")
require(reshape2)
MotorByYearCity <- melt(MotorByYearCity, id.vars="Year")
names(MotorByYearCity) <- c("Year", "City", "Value")

require(ggplot2)
ggplot(MotorByYearCity, aes(Year, Value, shape = City, color = City)) + geom_point(size = 2.5) + geom_smooth() +ggtitle("PM2.5 Emissions (tons) By Year ")





