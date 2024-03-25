library(dplyr)
# 1. Load data
electric <- read.csv("./data/household_power_consumption.txt", sep=";")

# 2. transform

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

# 3. set up ticks for weekdays on x-axis
pts <- c(as.POSIXct("2007-02-01 00:00:00"),
         as.POSIXct("2007-02-02 00:00:00"),
         as.POSIXct("2007-02-03 00:00:00") )

# 4.Set up dev and g2x2 grid
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# 5. Plot 1
plot(electric$time, electric$Global_active_power, type="l",
     xlab="", ylab="Global Active Power", xaxt="n")
axis(1, labels = format(pts, "%a"), at=pts)

# 6. Plot 2
plot(electric$time, electric$Voltage, type="l", xaxt="n", xlab="datetime", ylab="Voltage")

axis(1, labels = format(pts, "%a"), at=pts)

# 7. Plot 3
ylim <- range(c(electric$Sub_metering_1,
                electric$Sub_metering_3,
                electric$Sub_metering_3))

plot(electric$time, electric$Sub_metering_1, type = "l", 
     col = "black", xlab = "Date",
     ylab = "Value", ylim = ylim, xaxt="n")

axis(1, labels = format(pts, "%a"), at=pts)

lines(electric$time, electric$Sub_metering_2, col = "red")
lines(electric$time, electric$Sub_metering_3, col = "blue")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, cex=0.8)

# 8. Plot 4
plot(electric$time, electric$Global_reactive_power, type="l",
     xlab="datetime", ylab="Global Reactive Power", xaxt='n')


axis(1, labels = format(pts, "%a"), at=pts)

dev.off()
