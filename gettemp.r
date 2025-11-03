###
# use the noaa api to get some data from a particular station

# string parts
GENERALHEADER <- "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?"
PRODUCTHEAD <- "product="
APPLICATIONHEAD <- "&application="
BEGINDATEHEAD <- "&begin_date="
ENDDATEHEAD <- "&end_date="
STATIONHEAD <- "&station="
TIMEZONEHEAD <- "&time_zone="
UNITSHEAD <- "&units="
INTERVALHEAD <- "&interval="
FORMATHEAD <- "&format="

# general settings
TIMEZONE <- "GMT"
UNITS <- "english"
FORMAT <- "csv"

# modify these as needed
INTERVAL = "h"

STATION <- "8656483"
PRODUCT <- "water_temperature"
APPLICATION <- "NOS.COOPS.TAC.PHYSOCEAN"

# grab the current date to get the last 30 days
curdate <- Sys.Date()
dateback30 <- curdate - 30

# format the begin and end dates
BEGINDATE <- format(dateback30, "%Y%m%d")
ENDDATE <- format(curdate, "%Y%m%d")

# build the string
apistring <- paste0(
  GENERALHEADER,
  PRODUCTHEAD, PRODUCT,
  APPLICATIONHEAD, APPLICATION,
  BEGINDATEHEAD, BEGINDATE,
  ENDDATEHEAD, ENDDATE,
  STATIONHEAD, STATION,
  TIMEZONEHEAD, TIMEZONE,
  UNITSHEAD, UNITS,
  INTERVALHEAD, INTERVAL,
  FORMATHEAD, FORMAT
)

# load the data
dat <- read.table(apistring, header = TRUE, sep = ',', stringsAsFactors = FALSE)

# predict the date format
if(INTERVAL == "h") {
  dateformat = "%Y-%m-%d %H:%M"
} else if(INTERVAL == "6") {
  dateformat = "%Y-%m-%d %H:%M:%S"
} else {
  stop(paste("i don't recognize the interval format", INTERVAL))
}

# make a posix time note the format
dat$datetime_POSIX <- as.POSIXct(dat$Date.Time, format = dateformat)
dat$datetime_datenum <- as.numeric(dat$datetime_POSIX)

plot(dat$datetime_POSIX, dat$Water.Temperature, type = 'l')
