library(tidyverse)
library(janitor)
library(lubridate)
library(RJSONIO)
library(jsonlite)
library(nhlscrape)
library(stringr)

date = Sys.Date()

GetApiJson("game/2021020902/feed/live")

SetDbPath()

# Select the leafs
AddAllTeamsDb()
leafs_id <- GetTeamId("Toronto Maple Leafs")
bruins_id <- GetTeamId("Boston Bruins")

gids_bruins <- GetGameIdRange(bruins_id, "2021-10-16", date)
gids_leafs <- GetGameIdRange(leafs_id, "2021-10-13", date )

GameIDS_Leafs <- as.data.frame(gids_leafs)


# Add games
AddGameEvents(gids_bruins)
AddGameEvents(gids_leafs)

# Get stats for player
# Tavares
player_id <- GetPlayerId("John Tavares")

stats <- GetPlayerStats(player_id, gids_leafs, bruins_id)

SetDbPath(example = TRUE)
X <- GetHeatmapCoords(10L, `gids_leafs`, "'Shot', 'Goal'")
Y <- GetHeatmapCoords(6L, `gids_bruins`, "'Shot', 'Goal'")

Leafs_Latest <- X %>% 
  rename(X = coordinates_x, Y = coordinates_y,
         Event_Description = result_description,
         Period = about_period, Event = result_event) %>% 
  select(X, Y, Event_Description, Period, Event, game_id)


write.csv(Leafs_Latest,
          file = "leafs_shots_season.csv",
          row.names = F)



Bruins_Latest <- X %>% 
  rename(X = coordinates_x, Y = coordinates_y,
         Event_Description = result_description,
         Period = about_period, Event = result_event) %>% 
  select(X, Y, Event_Description, Period, Event, game_id)


write.csv(Bruins_Latest,
          file = "Bruins_shots_season.csv",
          row.names = F)
