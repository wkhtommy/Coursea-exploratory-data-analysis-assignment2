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


# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

Baltimore <- NEI[NEI$fips == "24510",]
YearType <- as.data.frame(with(Baltimore,tapply(Emissions,list(year, type),sum)))
YearType <- cbind(as.data.frame(c(1999,2002,2005,2008)),YearType)
names(YearType)[1] <- "Year"
require(reshape2)
YearType <- melt(YearType, id.vars="Year")
names(YearType) <- c("Year", "Type", "Value")

require(ggplot2)

png("plot3.png")
ggplot(YearType, aes(Year, Value, shape = Type, color = Type)) + geom_point(size = 2.5) + geom_smooth()+ggtitle("PM2.5 Emissions (tons) By Year ")
dev.off()

