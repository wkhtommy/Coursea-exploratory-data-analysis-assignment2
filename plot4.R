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


# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

coalSource <- SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),1]
coal <- NEI[NEI$SCC %in% coalSource,]


coalByYear <- with(coal,tapply(Emissions,year,sum))

png("plot4.png")
plot(c(1999,2002,2005,2008),coalByYear,xlim = c(1999,2008),xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Total PM2.5 Emission by Year (Coal Related Sources Only)", col = "black", cex = 3, pch = 19)
segments(c(1999,2002,2005), coalByYear[1:3],c(2002,2005,2008),coalByYear[2:4], lwd = 2)
dev.off()

