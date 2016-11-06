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
png("plot6.png")
ggplot(MotorByYearCity, aes(Year, Value, shape = City, color = City)) + geom_point(size = 2.5) + geom_smooth() +ggtitle("PM2.5 Emissions (tons) By Year ")


dev.off()

