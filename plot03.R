## Exploratory data analysis
## Course assignment 02, plot 03
## Jared Bowden

## Question
## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999–2008 for Baltimore City? Which have seen increases in
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
## answer this question.

## Methods and special considerations 
## This question may have been easier to answer by using total emissions.
## However, as this summary method was not specified in the question 
## (as it was in others) I opted to go with a plotting method that would get 
## more statistics on the page. Emission values are plotted on a log scale.

## Load up the ggplot2 library
library(ggplot2)

## Set the working directory
setwd('/home/jared/Dropbox/Code/Exploratory_data_analysis/')

## Read in the data file
rawData <- readRDS('./summarySCC_PM25.rds')

## Subset data to Baltimore City, Maryland (fips == "24510")
subData <- subset(rawData, fips == "24510")

## Subset this into a more concise dataframe
subDF <- subData[,4:6]

## Let's add some factors to this data frame. Go ahead and do this with both
## "year", and "type". 
factorData <- transform(subDF, type = factor(type))
finalData <- transform(factorData, year = factor(year))

## Prepare the graphics device to save as a png file
png("./Course_project02/plot03.png", 
    width = 800, 
    height = 480, 
    units = "px",
    pointsize = 12)

## Well, this is fun: in its original form, this title runs over the margin 
## limit. The fastest way I could think to deal with this was to break it into
## pieces, and then paste it within the plot code. I'd be willing to bet 
## there's a better way to do this...
a <- "PM2.5 emissions in Baltimore City, Maryland"
b <- "plotted by year (1999-2008) and emission type"

## Plot a boxplot with facets for the factor: type
ggplot(finalData, aes(x = year, y = log(Emissions))) +
    geom_boxplot(aes(fill = type), show_guide = FALSE) +
    facet_grid(.~ type) +
    ylab("PM2.5 Emissions log(tons)") +
    ggtitle(paste(a, b))
        
## Close the graphics device
dev.off()

----------------------
## This is the other option for displaying this data
totData <- aggregate(subDF$Emissions ~ subDF$year + subDF$type, subDF, sum)
colnames(totData) <- c("year", "type", "Emissions")

ggplot(totData, aes(x=year, y=log(Emissions), colour=type)) + 
    geom_line() +
    geom_point() 