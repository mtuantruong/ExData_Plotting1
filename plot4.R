# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(lubridate)

# Load Data ---------------------------------------------------------------

# Create data directory

if(!dir.exists("data")) { dir.create("data") }

# Download and unzip data file

if(!file.exists("data/household_power_consumption.zip") & !file.exists("data/household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "data/household_power_consumption.zip")
  unzip("data/household_power_consumption.zip", exdir = "data")
}

# Load data from 2007-02-01 to 2007-02-02

data <- read_delim("data/household_power_consumption.txt",
                   delim = ";",
                   na    = c("?"),
                   col_types = list(col_date(format = "%d/%m/%Y"),
                                    col_time(format = ""),
                                    col_number(),
                                    col_number(),
                                    col_number(),
                                    col_number(),
                                    col_number(),
                                    col_number(),
                                    col_number())) %>%
  filter(between(Date, as.Date("2007-02-01"), as.Date("2007-02-02")))

data <- mutate(data, datetime = ymd_hms(paste(Date, Time)))

# Make Plot ---------------------------------------------------------------

# Write to graphics device

png("plot4.png",
    width  = 480,
    height = 480)

# Set graphics device to multiple figures with 2 rows and 2 columns

par(mfrow = c(2, 2))

# Plot 1: Top Left

plot(Global_active_power ~ datetime, data, type = "l",
     ylab = "Global Active Power (kW)",
     xlab = NA)

# Plot 2: Top Right

plot(Voltage ~ datetime, data, type = "l")

# Plot 3: Bottom Left

plot(Sub_metering_1 ~ datetime, data, type = "l",
     ylab = "Energy sub metering",
     xlab = NA)

lines(Sub_metering_2 ~ datetime, data, type = "l", col = "red")

lines(Sub_metering_3 ~ datetime, data, type = "l", col = "blue")

legend("topright",
       col = c("black",
               "red",
               "blue"),
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"),
       lty = 1,
       bty = "n")

# Plot 4: Bottom Right

plot(Global_reactive_power ~ datetime, data, type = "l")

dev.off()

rm(list = ls())


