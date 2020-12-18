library(openintro)
library(readxl)
library(stingr)

# Census data for population
popData <- read_excel("nst-est2019-01.xlsx")
colnames(popData) <- c('state_name', 'population')
popData$state_name <- substring(popData$state_name, 2)

avgCases <- aggregate(daily_recent$positiveIncrease, list(daily_recent$state), mean)
avgDeaths <- aggregate(daily_recent$deathIncrease, list(daily_recent$state), mean)
avgTests <- aggregate(daily_recent$totalTestResultsIncrease, list(daily_recent$state), mean)

D3Map <- data.frame(state = avgCases$Group.1, 
                    seven_day_average_Positive = round(avgCases$x), 
                    seven_day_average_Tests = round(avgTests$x), 
                    seven_day_average_death_toll = round(avgDeaths$x))

# Positivity Rate in percent with 2 decimal digits
D3Map$seven_day_positivity_rate <- round(D3Map$seven_day_average_Positive / D3Map$seven_day_average_Tests * 100, 2)

# Remove American Territories
D3Map <- D3Map[!D3Map$state %in% c('AS','GU','MP','PR','VI'),]

# State abbreviations to names
D3Map$state_name <- abbr2state(D3Map$state)

# Negative death numbers to 0
D3Map$seven_day_average_death_toll[D3Map$seven_day_average_death_toll < 0] <- 0

# Add population data
D3Map <- merge(D3Map, popData, by.x = 'state_name')
D3Map$seven_day_average_Positive_percapita <- D3Map$seven_day_average_Positive / popData$population * 100000

# Output CSV
write.csv(D3Map, 'D3Map.csv', row.names = FALSE)

