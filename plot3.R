## Read only the rows for the date between 2002-02-01 and 2007-02-02
inputFile <- "household_power_consumption.txt"
con  <- file(inputFile, open = "r")
oneLine <- readLines(con, n=1)
headings <- strsplit(oneLine, ";")
headings <- unlist(headings)

tmpVector <- vector()
tmpDate <- date()
if (exists('hpc')) rm(hpc)
from = as.Date("2007-02-01", format="%Y-%m-%d")
to = as.Date("2007-02-02", format="%Y-%m-%d")

while (length(oneLine <- readLines(con, n = 1, warn = FALSE)) > 0) {
  tmpList <- strsplit(oneLine,";")
  tmpVector <- unlist(tmpList)
  
  tmpDate <- as.Date(tmpVector[1], format="%d/%m/%Y")
  if ((tmpDate >= from) & (tmpDate <= to)){
    if (!exists('hpc')){
      hpc <- data.frame()
      hpc <- rbind(hpc,tmpVector)
      names(hpc) <- headings
      hpc <- data.frame(lapply(hpc, as.character), stringsAsFactors=FALSE)
    }
    else{
      hpc <- rbind(hpc,tmpVector)
    }
  }
} 

close(con)

## Manipulate the hpc data
hpc[,1] <- as.POSIXct(strptime(paste(hpc[,1], hpc[,2]), format = "%d/%m/%Y %H:%M:%S"))
hpc <- subset(hpc, select = -c(2))
colnames(hpc)[1] <- "DateTime"
hpc[,6] <- as.numeric(hpc[,6])
hpc[,7] <- as.numeric(hpc[,7])
hpc[,8] <- as.numeric(hpc[,8])


#plot 3
png(filename="plot3.png", width=480, height=480)
plot(hpc[,1], hpc[,6], xlab="", ylab="Energy sub metering", type="n")
lines(hpc[,1], hpc[,6], type="l")
lines(hpc[,1], hpc[,7], type="l", col="red")
lines(hpc[,1], hpc[,8], type="l", col="blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1), col=c("black", "red", "blue"), cex=0.9)
dev.off()