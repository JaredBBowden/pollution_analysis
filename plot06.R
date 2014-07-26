## Exploratory data analysis
## Course assignment 02, plot 06
## Jared Bowden

## Question
## Compare emissions from motor vehicle sources in Baltimore City with 
## emissions from motor vehicle sources in Los Angeles County, California 
## (fips == "06037"). Which city has seen greater changes over time in motor 
## vehicle emissions?

## Methods and special considerations 
## (adapted from notes in plot05.R):
## A great deal of thought was given to what qualified as "motor vehicle"
## emissions. The script below will first limit emissions to "motor" SCC
## codes. However, as we can see in line 50-52, this subsetting will include
## several emission sources that are (presumably) outside the scope of the
## question. From the forums, I'm aware that others have approached this issue 
## by limiting the data to ON-ROAD use. I have applied a slightly different
## method. The following script uses a second subset step (line 69) to exclude
## POINT and NON-POINT emission sources. This serves to eliminate emissions 
## sources such as surface coating and rocket testing, but retains emissions 
## from sources like off road vehicles, and farm equipment. Emission values
## are plotted on a log scale.

## Set the working directory
setwd('/home/jared/Dropbox/Code/Exploratory_data_analysis/')

## Read in the data file and pollution summary file
rawData <- readRDS('./summarySCC_PM25.rds')
polCode <- readRDS('./Source_Classification_Code.rds')

## Subset data to Los Angeles County, California (fips == "06037"), and add a
## new catagorial data column to designate this as "Los Angeles County, 
## California"
subCal <- subset(rawData, fips == "06037")
subCal$city <- "Los Angeles County, California"

## Subset data to Baltimore City, Maryland (fips == "24510"), and add a
## new catagorial data column to designate this as "Baltimore City, Maryland"
subBal <- subset(rawData, fips == "24510")
subBal$city <- "Baltimore City, Maryland"

## Row bind these data sets to make a single data frame
fullData <- rbind(subCal, subBal)

## Grep to find all of the codes that are associated with emissions from motor
## vehicle sources
motorList <- grep("motor", polCode[,3], ignore.case = TRUE)

## Let's have a look at these short codes. Are all of these appropriate? (No,
## they are not).
polCode[motorList, 3]

## Some of these emissions are associated with surface coatings, rocket testing
## I think we'll exercise a little more discretion in our filtering, see 
## line 44-43 (for additional descriptions, see "Methods and Special 
## considerations")

## We can use these coordinates to subset the polCode data frame and find
## SCC codes that correspond with emissions from motor vehicle sources 
motorSCC <- polCode[motorList, 1]

## These SCC codes can be applied  to subset the subData to see only SCC codes
## that include motor vehicle emissions
motorData <- fullData[fullData$SCC %in% motorSCC, ]

## We can remove inappropriate emissions sources by Subsetting to remove POINT 
## and NON-POINT emission types
motorSub <- subset(motorData, type != "NONPOINT" & type != "POINT")

## Let's add some levels to the city data
factorData <- transform(motorSub, city = factor(city))

## Load up ggplot2
library(ggplot2)

## Prepare the graphics device to save as a png file
png("./Course_project02/plot06.png", 
    width = 800, 
    height = 600, 
    units = "px",
    pointsize = 12)

## Plot a boxplot with facets for the factor: year
ggplot(factorData, aes(log(Emissions), x = city, fill=city)) +
    geom_boxplot(alpha=.5) +
    facet_wrap( ~ year, ncol=2) +
    ylab("PM2.5 Emissions log(tons)") + 
    ggtitle("Motor vehicle related PM2.5 emissions in Baltimore City, Maryland
    and Los Angeles County, California from 1999-2008")
            
## Close the graphics device
dev.off()
