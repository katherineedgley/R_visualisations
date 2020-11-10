install.packages("tidytuesdayR")
library('data.table')
library(tidyverse)
library(countrycode)
library(janitor)
library(leaflet)
library(plotly)


tuesdata <- tidytuesdayR::tt_load('2020-11-10')
tuesdata <- tidytuesdayR::tt_load(2020, week = 46)

mobile <- data.table(tuesdata$mobile)
landline <- data.table(tuesdata$landline)

colnames(mobile)[6] <- 'subs'
colnames(landline)[6] <- 'subs'

mobile$type <- 'Mobile'
landline$type <- 'Landline'

all_dt <- rbind(mobile, landline)

continent_landlines <- landline[, mean(landline_subs, na.rm=TRUE), by=.(continent, year)]
continent_landlines$continent %>% unique()

p <- ggplot(continent_landlines, aes(year, V1)) + geom_line()
p + facet_grid(vars(continent_landlines$continent))

continent_landlines$type <- 'Landline'
colnames(continent_landlines)[3] <- 'subs'

continent_landlines

continent_mobile <- mobile[, mean(mobile_subs, na.rm=TRUE), by=.(continent, year)]
continent_mobile$continent %>% unique()
continent_mobile$type <- 'Mobile'
colnames(continent_mobile)[3] <- 'subs'
continent_landlines
continent_mobile

continent_dt <- rbind(continent_mobile, continent_landlines)

p <- ggplot(continent_dt, aes(year, subs, colour=factor(type))) + geom_line()
p + facet_grid(vars(continent_dt$continent)) + ylab('Subscriptions') + labs(color='Type')

p <- ggplot(mobile[year == 2017], aes(mobile_subs, gdp_per_cap,text=entity, color=continent)) + geom_point() +
  xlab('Mobile Subscriptions') + ylab('GDP per capita')

ggplotly(p)


