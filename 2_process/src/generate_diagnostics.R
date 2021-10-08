#' Generate diagnostic text based on model results
#' 
#' Takes model output, calculates summary statistics for models
#' and produces a text file
#' 
#' @param data_in tbl, model results from ScienceBase
#' @param file_out string, location where diagnostic text will be saved
#' 
generate_diagnostics <- function(data_in, file_out){
  
  # Save the model diagnostics
  render_data <- render_stats(data_in, rd = 2, stat_lab = 'mean', FUN = function(x) mean(x))

  # prepare a text template
  template_1 <- 'resulted in mean RMSEs (means calculated as average of RMSEs from the five dataset iterations) of {{pgdl_980mean}}, {{dl_980mean}}, and {{pb_980mean}}°C for the PGDL, DL, and PB models, respectively.
  The relative performance of DL vs PB depended on the amount of training data. The accuracy of Lake Mendota temperature predictions from the DL was better than PB when trained on 500 profiles 
  ({{dl_500mean}} and {{pb_500mean}}°C, respectively) or more, but worse than PB when training was reduced to 100 profiles ({{dl_100mean}} and {{pb_100mean}}°C respectively) or fewer.
  The PGDL prediction accuracy was more robust compared to PB when only two profiles were provided for training ({{pgdl_2mean}} and {{pb_2mean}}°C, respectively). '

  # populate and save diagnostic text file
  whisker::whisker.render(template_1 %>%
                          stringr::str_remove_all('\n') %>%
                          stringr::str_replace_all('  ', ' '), render_data ) %>%
  cat(file = file.path(file_out, 'model_diagnostic_text.txt'))
}

#' Generate summary stats for model results
#' 
#' A function internally called by `generate_diagnostics` to summarize results from all 
#' unique combinations of model and profiles
#' 
#' @param data_in tbl, model results from ScienceBase
#' @param rd num, number of digits for rounding
#' @param stat_lab string, appropriate stat name used to generate summary statistics
#' @param FUN function, a custom function that is used to calculate summary statistics
#' 
render_stats <- function(data_in, rd = 2, stat_lab = 'mean',  FUN = function(x) mean(x)){
  # use group_by to generate stats for all unique combos of model and profile
  stat_out <- data_in %>% 
    group_by(model_type, n_prof) %>% 
    summarise(stat = FUN(rmse)) %>% 
    mutate(stat = round(stat, rd)) %>% 
    mutate(lab = paste(model_type, '_', n_prof, stat_lab, sep = ''))
  
  # convert results into a list and add names
  ls_stat_out <- stat_out %>% pull(stat) %>% sapply(., list)
  names(ls_stat_out) <- stat_out %>% pull(lab)
  
  return(ls_stat_out)
}

