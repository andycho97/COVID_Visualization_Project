
avgCases <- aggregate(daily_recent$positiveIncrease, list(daily_recent$state), mean)
avgDeaths <- aggregate(daily_recent$deathIncrease, list(daily_recent$state), mean)
avgTests <- aggregate(daily_recent$totalTestResultsIncrease, list(daily_recent$state), mean)

D3Map <- data.frame(state = avgCases$Group.1, 
                    seven_day_average_Positive = round(avgCases$x), 
                    seven_day_average_Tests = round(avgTests$x), 
                    seven_day_average_death_toll = round(avgDeaths$x))

D3Map$seven_day_positivity_rate <- round(D3Map$seven_day_average_Positive / D3Map$seven_day_average_Tests * 100, 2)
D3Map <- D3Map[!D3Map$state %in% c('AS','GU','MP','PR','VI'),]
D3Map$state_name <- abbr2state(D3Map$state)
write.csv(D3Map, 'D3Map.csv', row.names = FALSE)