## Exploratory data analysis
## Course assignment 02, plot 01
## Jared Bowden

## Question
## Have total emissions from PM2.5 decreased in the United States from 1999 to 
## 2008? Using the base plotting system, make a plot showing the total PM2.5 
## emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## Methods and special considerations 
## This script requires the RColorBrewer package.
## Final emission values are plotted in kilotons. If this unit isn't your cup
## of tea, this parameter can be adjusted in line 26. 

## Set the working directory
setwd('/home/jared/Dropbox/Code/Exploratory_data_analysis/')

## Read in the data file
rawData <- readRDS('./summarySCC_PM25.rds')

## Use aggregate function to calculate emissions, totalled across years.
sumData <- aggregate(rawData$Emissions ~ rawData$year, rawData, sum)

## These emission values are reeeally large; base is converting to scientific
## notation. I Would prefer to scale this to kilotons.
kiloPol <- sumData[,2] / 1000 

## Merge x and y variables into a single object for plotting.
names(kiloPol) <- sumData[,1]

## Prepare the graphics device to save as a png file
png("./Course_project02/plot01.png", width = 600, height = 480)

## Load RColorBrewer package
library(RColorBrewer)

## Set the plotting colors. This is a little tricky: we need to reverse the 
## RColorBrewer function to get a decresing gradient.
cols <- rev(brewer.pal(3, "Oranges"))
pal <- colorRampPalette(cols)

## Use base to plot as a bar graph, and add some titles 
barplot(kiloPol, xlab = "Year", ylab = "Total PM2.5 Emissions (kilotons)", 
        col = pal(6), 
        main = "Total PM2.5 emissions in the USA from 1999-2008")

## Close the graphics device
dev.off()

## Answer
## Total emissions in the USA have decreased across years 1999, 2002, 2005
## and 2008