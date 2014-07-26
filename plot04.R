## Exploratory data analysis
## Course assignment 02, plot 04
## Jared Bowden

## Question
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?

## Methods and special considerations 
## This script will limit emission sources to "coal" AND "combustion".
## I have opted to drop 0 values (lines 37 to 42), as it was decided that these
## would skew the plot statisitcs. This option can be adjusted in line 42 
## Emission values are plotted on a log scale, and displayed as density 
## histogram
 
## Set the working directory
setwd('/home/jared/Dropbox/Code/Exploratory_data_analysis/')

## Read in the data file and pollution summary file
rawData <- readRDS('./summarySCC_PM25.rds')
polCode <- readRDS('./Source_Classification_Code.rds')

## Grep to find all of the codes that are associated with coal AND combustion
coalList <- grep("coal.*combustion", polCode[,3], ignore.case = TRUE)

## Let's have a look at these short codes. Are all of these appropriate?
## (n = 8, all look valid)
polCode[coalList, 3]

## We can use these coordinates to subset the polCode data frame
colSCC <- polCode[coalList, 1]

## Now, we can use these SCC codes to subset the rawData to see only SCC codes
## that include both "coal" and "combustion"
coalSub <- rawData[rawData$SCC %in% colSCC, ]

## Test to see if there are any zero values, or less than zero values. 
table(coalSub$Emissions <= 0)

## Looks like we have 4 values that have zero emissions. Drop these values
## (see "methods and special considerations")
cleanData <- subset(coalSub, Emissions > 0)

## Make year a factor
finalData <- transform(cleanData, year = factor(year))

## Load up ggplot2
library(ggplot2)

## Prepare the graphics device to save as a png file
png("./Course_project02/plot04.png", 
    width = 600, 
    height = 480, 
    units = "px",
    pointsize = 12)

## Plot a density graph with facets for the factor: year
ggplot(finalData, aes(x = log(Emissions), fill = year, col = year)) +
    geom_density(size = .5, alpha = .2,) + 
    facet_wrap(~ year, ncol = 2) +
    xlab("PM2.5 Emissions log(tons)") + 
    ggtitle("Coal-combustion related PM2.5 emissions in the USA from 1999-2008")

## Close the graphics device
dev.off()

