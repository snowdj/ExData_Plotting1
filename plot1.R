
# Url at which the data set is located
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Download zip file
download.file(fileUrl, destfile="household_power_consumption.zip", method="curl")
# Read data set. Call the data frame "powerConsumption"
powerConsumption <- read.table(unz("household_power_consumption.zip", "household_power_consumption.txt"),header=T, sep=";")

# Household power consumption for Feb. 1 and 2, 2007 only
myData <- powerConsumption[as.character(powerConsumption$Date) %in% c("1/2/2007", "2/2/2007"),]

### best way to do it


library(sqldf)
myfile <- "household_power_consumption.txt"
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
myData <- read.csv.sql(myfile,mySql,sep=";",header=T)
names(myData)


## convert any "?" to "NA"
for( i in 1:9) {
  myData[myData[, i] == "?"] <- "NA"
}

myData<-na.omit(myData)

## convert power measurements to numeric
for(i in 3:9){
  myData[, i] <- as.numeric(myData[, i])
}


for( i in 1:2) {
  myData[, i] <- as.character(myData[, i])
}



## convert Date and Time from factor to character 


myData <- within(myData, DateTime <- paste(Date, Time, sep = ' '))

myData$DateTime<-strptime(myData$DateTime,"%d/%m/%Y %H:%M:%S")




# plot 1 global active power vs frequency
png(filename = "plot1.png",width = 480, height = 480,units = "px")
hist(myData$Global_active_power, col= "red",xlab = "Global Active Power (kilowatts)", main="Global Active Power") 
dev.off()
