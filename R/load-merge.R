# code to combine all years of water quality and met data
# calculate daily min, max, and means into one file.

# install.packages(c('SWMPr', 'tidyverse', 'lubridate'))

library(SWMPr)
library(tidyverse)
library(lubridate)
library(SWMPrExtension)

# Load-QAQC ---------------------------------------------------------------

pc_met <- import_local(path = 'data', station_code = 'gtmpcmet', trace = T)
qaqc_met <- qaqcchk(pc_met)
unique(qaqc_met$flag)
pc_met <- qaqc(pc_met, qaqc_keep = c('0', '5', '1'))

fm_wq <- import_local(path = 'data', station_code = 'gtmfmwq', trace = T)
qaqcchk(fm_wq)
fm_wq <- qaqc(fm_wq, qaqc_keep = c('0', '3'), trace = T)

ss_wq <- import_local(path = 'data', station_code = 'gtmsswq', trace = T)
qaqcchk(ss_wq)
ss_wq <- qaqc(ss_wq, qaqc_keep = c('0', '3'), trace = T)

pi_wq <- import_local(path = 'data', station_code = 'gtmpiwq', trace = T)
qaqcchk(pi_wq)
pi_wq <- qaqc(pi_wq, qaqc_keep = c('0', '3'), trace = T)

pc_wq <- import_local(path = 'data', station_code = 'gtmpcwq', trace = T)
qaqcchk(pc_wq)
pc_wq <- qaqc(pc_wq, qaqc_keep = c('0', '3'), trace = T)


# Comb-WQ/MET and bind_rows -----------------------------------------------

fm <- comb(fm_wq, pc_met, timestep = 15, method = 'union') %>% 
  mutate(station = "fm")
ss <- comb(ss_wq, pc_met, timestep = 15, method = 'union')%>% 
  mutate(station = "ss")
pi <- comb(pi_wq, pc_met, timestep = 15, method = 'union') %>% 
  mutate(station = "pi")
pc <- comb(pc_wq, pc_met, timestep = 15, method = 'union') %>% 
  mutate(station = "pc")

full <- bind_rows(pc, fm, pi, ss)



# SWMPrExtension plots ----------------------------------------------------


SWMPrExtension::historical_daily_range(fm_wq, param = 'sal', target_yr = '2021')