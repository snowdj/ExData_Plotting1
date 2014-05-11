
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




# plot 4 
png(filename = "plot4.png",width = 480, height = 480, units = "px")

par(mfcol = c(2, 2), mar = c(4, 4, 2, 1))

# first
plot(myData$DateTime,myData$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab ="") 

# second
plot(myData$DateTime,myData$Sub_metering_1, type="l", ylab = "Energy sub metering", xlab ="") 

lines(myData$DateTime,myData$Sub_metering_2, col="red")

lines(myData$DateTime,myData$Sub_metering_3, col="blue")

legend("topright", lty=1,col = c("black","blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# third

plot(myData$DateTime,myData$Voltage, type="l", xlab = "datetime", ylab ="Voltage") 


# fourth

plot(myData$DateTime,myData$Global_reactive_power, type="l", xlab = "datetime", ylab ="Global_reactive_power") 


dev.off()
