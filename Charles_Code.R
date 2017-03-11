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


###################################
## Check usage of stations and features of stations
## Response is the inflow number of stations
## Get the date frame for inflow number
# Truncate data
dt <- X2016_12_trip_data[1:tail(which(X2016_12_trip_data$date_of_ride == "2016-08-31"),1), ]
each_day_dest_number_array <- tapply(dt$to_station_name, dt$date_of_ride, table)
d <- lapply(each_day_dest_number_array, as.data.frame)
inflow_data <- do.call(cbind, d)
street_name <- inflow_data[,1]
inflow_data <- inflow_data[, !sapply(inflow_data, is.factor)]

# Transpose it
# change the row and col names
inflow_data <- t(inflow_data)
colnames(inflow_data) <- street_name
date_name <- rownames(inflow_data)
date_name <- strsplit(date_name, "\\.")
date_name <- sapply(date_name, function(x) {x[[1]]})
inflow_data <- as.data.frame(inflow_data)
rownames(inflow_data) <- date_name


# Get data for regression on weather
t_inflow_data <- inflow_data[1:689,-23]
#inflow_data_trun <- inflow_data[1 : length(X2016_weather_data$Date), ]
inflow_list_turn <- unlist(t_inflow_data[,-1])
weather_repeated <- X2016_weather_data[rep(rownames(X2016_weather_data), ncol(t_inflow_data)-1), ]
station_in_weather <- cbind(inflow_list_turn, weather_repeated)

# do regression
l <- lm(station_in_weather$inflow_list_turn ~ station_in_weather$Mean_Temperature_F +
        station_in_weather$Precipitation_In)
summary(l)
hist(cor(inflow_data[,-1]))
summary(as.vector(cor(inflow_data[,-1])))

## Check equal variance assumption
# Dump data which has different installation date and decomissioned
## Notice "Lake Union Park / Westlake Ave & Aloha St"   in the orginal data set is at row 59!!!
X2016_12_station_data <-X2016_12_station_data[order(X2016_12_station_data$name),] 
which(!X2016_12_station_data$name  %in% colnames(inflow_data) )
X2016_12_station_data<- X2016_12_station_data[-which(!X2016_12_station_data$name  %in% colnames(inflow_data) ), ]
tf <- X2016_12_station_data$install_date == "10/13/2014" & 
  X2016_12_station_data$decommission_date == ""
inflow_var <- inflow_data[,tf]


variance <- apply(inflow_var, 2, var)
me <- apply(inflow_var,2, mean)

# Visual check
plot(me, variance)
which(va == max(va))
plot(table(inflow_data$`Pier 69 / Alaskan Way & Clay St`))

# Transformation
plot(log(variance), log(me))
trans_lm <- lm(log(variance) ~ log(me))
#inflow_var_trans <- (inflow_var[,-1]+1)^(1-1.1203)
inflow_var_trans <- (log(inflow_var+1))
variance <- apply(inflow_var_trans, 2, var)
me <- apply(inflow_var_trans,2, mean)
plot(me, variance)
max(variance) / min(variance)


# Hist before tranformation
par(mfrow= c(3,3))
apply(inflow_var,2, function(x) {plot(table(x))})
# Hist after tranformation
par(mfrow= c(3,3))
apply(inflow_var_trans,2,function(x) {plot(table(x))} )

tme <- me[order(variance)]
tme <- tme[1:40]
tvar <- variance[order(variance)]
tvar <- tvar[1:40]
