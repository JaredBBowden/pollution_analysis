## Exploratory data analysis
## Course assignment 02, plot 02
## Jared Bowden

## Question
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
## plot answering this question.

## Methods and special considerations 
## This script requires the RColorBrewer package.
## Final emission values are plotted in kilotons. If this unit isn't your cup
## of tea, this parameter can be adjusted in line 29. 

## Set the working directory
setwd('/home/jared/Dropbox/Code/Exploratory_data_analysis/')

## Read in the data file
rawData <- readRDS('./summarySCC_PM25.rds')

## Subset data to Baltimore City, Maryland (fips == "24510")
subData <- subset(rawData, fips == "24510")

## Use aggregate function to calculate emissions, totalled across years.
totData <- aggregate(subData$Emissions ~ subData$year, subData, sum)

## base is converting to scientific notation. I Would prefer to scale this to 
## kilotons.
kiloPol <- totData[,2] / 1000

## Merge x and y variables into a single object for plotting.
names(kiloPol) <- totData[,1]

## Prepare the graphics device to save as a png file
png("./Course_project02/plot02.png", width = 600, height = 480)

## Load RColorBrewer package
library(RColorBrewer)

## Set the plotting colors. This is a little tricky: we need to reverse the 
## RColorBrewer function to get a decresing gradient. We don't have 
## A consistent decrease across years, so we're just going to use the 
## Brewer function to extract the hex color codes we need.
cols <- rev(brewer.pal(4, "BuGn"))

## Use base to plot as a bar graph, and add some titles
barplot(kiloPol, xlab = "Year", ylab = "Total PM2.5 Emissions (kilotons)", 
    col = c("#006D2C", "#66C2A4", "#2CA25F", "#B2E2E2"),
    main = "Total PM2.5 emissions in Baltimore City, Maryland from 1999-2008")

## Close the graphics device
dev.off()

## Answer
## There is a decreasing trend in total PM2.5 emissions within 
## Baltimore City, Maryland from 1999 to 2008. This trend is strictly linear,
## while the overall trend is decreasing, there is a spike in emissions 
## in 2005.
