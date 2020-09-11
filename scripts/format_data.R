library(data.table)
library(jsonlite)
library(dplyr)
# library(ggplot2)

# Want US data, state data, and county data.

data = fread(file = 'input/data.csv')
data$Date = as.Date(data$Date, format = "%Y/%m/%d")

data = data %>% janitor::clean_names()
data$pct = data$population_staying_at_home / (data$population_staying_at_home + data$population_not_staying_at_home)

country = data %>% filter(level == 'National') %>% arrange(date)
states = data %>% filter(level == 'State') %>% arrange(date)
counties = data %>% filter(level == 'County') %>% arrange(date)

# states %>% filter(state_postal_code == 'AL') %>%
#     ggplot(aes(x = date, y = pct)) +
#     geom_line()

unique_states = states$state_postal_code %>% unique
unique_counties = counties$county_name %>% unique

fwrite(country, 'output/country_data.csv')
fwrite(states, 'output/state_data.csv')
# Write out individual states to reduce load-times when reading county data

county_split = split(counties, counties$state_postal_code)

invisible({
    lapply(county_split, function(x) {
        st = unique(x$state_postal_code)
        fwrite(x, paste0("output/", st, "_data.csv"))
    })
})

jsonlite::write_json(unique_states, path = 'output/unique_states.json')
jsonlite::write_json(unique_counties, path = 'output/unique_counties.json')
