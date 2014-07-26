## Exploratory data analysis
## Course assignment 02, plot 05
## Jared Bowden

## Question
## How have emissions from motor vehicle sources changed from 1999–2008 in
## Baltimore City?

## Methods and special considerations 
## A great deal of thought was given to what qualified as "motor vehicle"
## emissions. The script below will first limit emissions to "motor" SCC
## codes. However, as we can see in line 36-38, this subsetting will include
## several emission sources that are (presumably) outside the scope of the
## question. From the forums, I'm aware that others have approached this issue 
## by limiting the data to ON-ROAD use. I have applied a slightly different
## method. The following script uses a second subset step (line 55) to exclude
## POINT and NON-POINT emission sources. This serves to eliminate emissions 
## sources such as surface coating and rocket testing, but retains emissions 
## from sources like off road vehicles, and farm equipment. Emission values
## are plotted on a log scale.

## Set the working directory
setwd('/home/jared/Dropbox/Code/Exploratory_data_analysis/')

## Read in the data file and pollution summary file
rawData <- readRDS('./summarySCC_PM25.rds')
polCode <- readRDS('./Source_Classification_Code.rds')

## Subset data to Baltimore City, Maryland (fips == "24510")
subData <- subset(rawData, fips == "24510")

## Grep to find all of the codes that are associated with emissions from motor
## vehicle sources
motorList <- grep("motor", polCode[,3], ignore.case = TRUE)

## Let's have a look at these short codes. Are all of these appropriate? (No,
## they are not).
polCode[motorList, ]

## Some of these emissions are associated with surface coatings, rocket testing
## I think we'll exercise a little more discretion in our filtering, see 
## line 44-43 (for additional descriptions, see "Methods and Special 
## considerations")

## We can use these coordinates to subset the polCode data frame and find
## SCC codes that correspond with emissions from motor vehicle sources 
motorSCC <- polCode[motorList, 1]

## These SCC codes can be applied  to subset the subData to see only SCC codes
## that include motor vehicle emissions
motorData <- subData[subData$SCC %in% motorSCC, ]

## We can remove inappropriate emissions sources by Subsetting to remove POINT 
## and NON-POINT emission types
motorSub <- subset(motorData, type != "NONPOINT" & type != "POINT")

## Quick check: do we have any zero values in here? (nope, we're good)
table(motorSub$Emissions == 0)

## Add factors for year 
factorData <- transform(motorSub, year = factor(year))

## I'm going to do that thing with the title again. 
## In its original form, this title runs over the margin limit. The fastest way 
## I could think to deal with this was to break the title into pieces, and then
## paste it within the plot code.
a <- "Motor vehicle related PM2.5 emissions in Baltimore City, Maryland"
b <- "from 1999-2008"
 
## Load ggplot2
library(ggplot2)

## Prepare the graphics device to save as a png file
png("./Course_project02/plot05.png", 
    width = 600, 
    height = 600, 
    units = "px",
    pointsize = 12)

## Plot a boxplot 
ggplot(factorData, aes(x = year, y = log(Emissions), fill = year, col = year)) +
    geom_boxplot(alpha = .2) +
    ylab("PM2.5 Emissions log(tons)") + 
    ggtitle(paste(a, b))
            
## Close the graphics device
dev.off()