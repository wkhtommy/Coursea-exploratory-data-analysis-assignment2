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


# 5. How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

Baltimore <- NEI[NEI$fips == "24510",]
BaltimoreMotor <- Baltimore[Baltimore$type == "ON-ROAD",]
BaltimoreMotorByYear <- with(BaltimoreMotor,tapply(Emissions,year,sum))

png("plot5.png")
plot(c(1999,2002,2005,2008),BaltimoreMotorByYear,xlim = c(1999,2008),xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Baltimore PM2.5 Emissions (tons) By Year (On-Road Only)", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), BaltimoreMotorByYear[1:3],c(2002,2005,2008),BaltimoreMotorByYear[2:4], lwd = 2)
dev.off()

