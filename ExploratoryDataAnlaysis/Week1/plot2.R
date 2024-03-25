# 1. Load the data
electric <- read.csv("./data/household_power_consumption.txt", sep=";")

# 2. Format & Filter
format <- "%d/%m/%Y %H:%M:%S"
start_date <- as.POSIXct("01/02/2007 00:00:00", format=format)
end_date <- as.POSIXct("02/02/2007 23:59:59", format=format)

electric <- electric %>%
  mutate(time = as.POSIXct(paste(Date, Time), format=format)) %>%
  mutate(Global_active_power = as.numeric(Global_active_power)) %>%
  filter(time >= start_date & time <= end_date )

# 3. make the plot
png("plot2.png", width=480, height=480)

plot(x = electric$time, y = electric$Global_active_power,
      type="l", xaxt="n", ylab="Global Active Power (kilowatts)", xlab="Day")
pts <- c(as.POSIXct("2007-02-01 00:00:00"),
         as.POSIXct("2007-02-02 00:00:00"),
         as.POSIXct("2007-02-03 00:00:00") )
axis(1, labels = format(pts, "%a"), at=pts)

dev.off()