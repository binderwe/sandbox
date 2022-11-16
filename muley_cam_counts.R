library(dplyr)
library(lubridate)
library(stringr)

setwd("C:/Users/binde/OneDrive/Desktop/Yellowstone/Camera Trapping")

W22raw <- read.csv("W22raw.csv")

W22muley <- W22raw %>%
  # format as POSIXt
  mutate(t = as.Date(DateTime, "%Y-%m-%d")) %>%
  subset(Species == "Mule Deer") %>% 
  subset(t > "2021-10-31 23:59:59" & t < "2022-04-01 00:00:00") %>% 
  select("station.id", "t")

W22muley <- unique(W22muley)

#format to match traps
W22muley$station.id <- str_pad(W22muley$station.id, 5, side = "left", pad = "0")

#create count per station
W22muley_totals <- as.data.frame(table(W22muley['station.id']))

W22muley_totals <- W22muley_totals %>% 
                    mutate(station.id = Var1) %>% 
                    select("station.id", "Freq")

#bring in coords
traps22 <- read.csv("C:/Users/binde/OneDrive/Desktop/Yellowstone/Camera Trapping/Earthpoint/W22/all_traps22_latlong.csv")  

traps22$Cell.ID <- str_pad(traps22$Cell.ID, 3, side = "left", pad = "0")

traps22$Station <- paste(traps22$Cell.ID, traps22$Station, sep = ".")

traps22$station.id <- traps22$Station

#merge dataframes together
W22md_totals_ep <- merge(W22muley_totals, traps22, all.x = TRUE) %>%
                        select("Freq", "station.id", "Longitude", "Latitude", "Icon", "IconColor", "LabelColor")

write.csv(W22md_totals_ep, "C:/Users/binde/OneDrive/Desktop/Yellowstone/Camera Trapping/Earthpoint/muleys/W22md_totals_ep.csv")

write.csv(W22muley_totals, "C:/Users/binde/OneDrive/Desktop/Yellowstone/Camera Trapping/Earthpoint/muleys/W22muley_totals.csv")
