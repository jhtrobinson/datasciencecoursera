library(dplyr)
# 1. Load the data
electric <- read.csv("./data/household_power_consumption.txt", sep=";")

# 2. Format & Filter
format <- "%d/%m/%Y %H:%M:%S"
start_date <- as.POSIXct("01/02/2007 00:00:00", format=format)
end_date <- as.POSIXct("02/02/2007 23:59:59", format=format)

electric <- electric %>%
  mutate(time = as.POSIXct(paste(Date, Time), format=format)) %>%
  mutate(Global_active_power = as.numeric(Global_active_power)) %>%
  mutate(Sub_metering_1 = as.numeric(Sub_metering_1)) %>%
  mutate(Sub_metering_2 = as.numeric(Sub_metering_2)) %>%
  mutate(Sub_metering_3 = as.numeric(Sub_metering_3)) %>%
  filter(time >= start_date & time <= end_date )

# 3. Do the plot

png("plot3.png", width=480, height=480)

ylim <- range(c(electric$Sub_metering_1,
                electric$Sub_metering_3,
                electric$Sub_metering_3))

plot(electric$time, electric$Sub_metering_1, type = "l", col = "black",
     xlab = "Date", ylab = "Value", ylim = ylim,  xaxt="n")


pts <- c(as.POSIXct("2007-02-01 00:00:00"),
         as.POSIXct("2007-02-02 00:00:00"),
         as.POSIXct("2007-02-03 00:00:00") )
axis(1, labels = format(pts, "%a"), at=pts)

lines(electric$time, electric$Sub_metering_2, col = "red")
lines(electric$time, electric$Sub_metering_3, col = "blue")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1)

dev.off()
