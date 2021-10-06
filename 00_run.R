# load libraries
library(dplyr)
library(readr)
library(stringr)
library(sbtools)
library(whisker)

# load functions
source('1_fetch/src/fetch_data.R')
source('2_process/src/prep_data.R')
source('2_process/src/generate_diagnostics.R')
source('3_vizualize/src/plot_data.R')

# download data
data_loc <- fetch_data('1_fetch/out')

# prep for plotting
eval_data <- prep_data(data_loc)

# generate diagnostic text
generate_diagnostics(data_in = eval_data, file_out = '2_process/out')

# generate and save plot
plot_data(data_in = eval_data)
