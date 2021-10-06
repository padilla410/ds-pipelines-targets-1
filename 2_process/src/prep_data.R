#' format raw data from ScienceBase for plotting in Base R
#' 
#' Takes raw data downloaded from ScienceBase and prepares it for plotting by adding
#' `col` (color), `pch` (point shapes), and `n_prof` (# of profiles) columns
#' for future plotting
#' 
#' @param file_in String, file location for raw ScienceBase data
#' @param save Boolean, should the prepped data be saved as a csv?
#' 
prep_data <- function(file_in, save = TRUE){
  # Prepare the data for plotting
  eval_data <- readr::read_csv(file_in, col_types = 'iccd') %>%
    filter(str_detect(exper_id, 'similar_[0-9]+')) %>%
    mutate(col = case_when(
      model_type == 'pb' ~ '#1b9e77',
      model_type == 'dl' ~'#d95f02',
      model_type == 'pgdl' ~ '#7570b3'
    ), pch = case_when(
      model_type == 'pb' ~ 21,
      model_type == 'dl' ~ 22,
      model_type == 'pgdl' ~ 23
    ), n_prof = as.numeric(str_extract(exper_id, '[0-9]+')))
  
  if(save){
    # Save the processed data
    readr::write_csv(eval_data, file = file.path('2_process/out/model_summary_results.csv'))
  }

  return(eval_data)
}