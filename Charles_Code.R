# Import data # Mac
#X2016_12_station_data <- read.csv("~/Documents/Work/UW/STAT 504/HW/Project/2016-12_station_data.csv")
#X2016_12_trip_data <- read.csv("~/Documents/Work/UW/STAT 504/HW/Project/2016-12_trip_data.csv")
#X2016_weather_data <- read.csv("~/Documents/Work/UW/STAT 504/HW/Project/2016_weather_data.csv")

# Import data # windows
X2016_weather_data <- read.csv("C:/Working/UW/STAT 504/504-Project/2016_weather_data.csv")
X2016_12_station_data <- read.csv("C:/Working/UW/STAT 504/504-Project/2016-12_station_data.csv")
X2016_12_trip_data <- read.csv("C:/Working/UW/STAT 504/504-Project/2016-12_trip_data.csv")

# Get the date of ride
start_time <- X2016_12_trip_data$starttime
date_of_ride <- strsplit(as.character(start_time),' ')
date_of_ride <- sapply(date_of_ride, function(x) { x[[1]][[1]] } )

## At the date of ride to the data frame
X2016_12_trip_data <- cbind(X2016_12_trip_data, date_of_ride)
## Trouble found. Weather date is only upto 8/31/2016

# Extract data for 2015
date_2015 <- date_of_ride[grepl('2015', date_of_ride) ]
month <- c(1:12)
regex <- "%i/[0-9]?[0-9]?/"
regex <- sprintf(regex, month)
tf_matrix <- sapply(regex, grepl, x = date_2015)
colnames(tf_matrix) <- month.name
month_bike_rentals <- apply(tf_matrix, 2, table)[2, ]

# Visually check the distribution
plot(month_bike_rentals, main = "Number of People Using Bike Rentals in 2015", 
     xlab = "Month", ylab = "Number of People")


# Extract different info for gender
# We truncate the data at 8/31/2016
data_gender_noNA <- X2016_12_trip_data[1:tail(which(X2016_12_trip_data$date_of_ride == "8/31/2016"),1), ]
data_gender_noNA <- data_gender_noNA[data_gender_noNA$gender %in% c("Male", "Female"), ]
data_gender_noNA$date_of_ride <- factor(data_gender_noNA$date_of_ride)
data_gender_noNA$date_of_ride <- as.Date(data_gender_noNA$date_of_ride, "%m/%d/%Y")
male_female_ratio <- tapply(data_gender_noNA$gender, INDEX = data_gender_noNA$date_of_ride, FUN = function(x) {
  sum(x == "Male") / length(x)
})

# Visual check
hist(male_female_ratio)

# Fit model

pairs(test)
test <- cbind(male_female_ratio, X2016_weather_data$Mean_Temperature_F, 
              X2016_weather_data$MeanDew_Point_F, X2016_weather_data$Mean_Humidity, 
              X2016_weather_data$Mean_Sea_Level_Pressure_In, X2016_weather_data$Mean_Visibility_Miles, 
              X2016_weather_data$Mean_Wind_Speed_MPH, X2016_weather_data$Max_Gust_Speed_MPH,
              X2016_weather_data$Precipitation_In)
pairs(test)
test <- as.data.frame(test)
m <- lm(male_female_ratio~. ,data = test)
summary(m)
