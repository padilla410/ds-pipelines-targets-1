library(targets)
source("code.R")
tar_option_set(packages = c("tidyverse", "sbtools", "whisker"))

list(
  # Get the data from ScienceBase
  tar_target(
    model_RMSEs_csv,
    fetch_data(path_out = "1_fetch/out/model_RMSEs.csv"),
    format = "file"
  ), 
  # Prepare the data for plotting
  tar_target(
    eval_data,
    prep_data(file_in = model_RMSEs_csv),
  ),
  # Create a plot
  tar_target(
    figure_1_png,
    plot_data(data_in = eval_data, file_out = "3_vizualize/out/figure_1.png"),
    format = "file"
  ),
  # Save the processed data
  tar_target(
    model_summary_results_csv,
    save_processed_data(data_in = eval_data, file_out = "2_process/out/model_summary_results.csv"),
    format = "file"
  ),
  # Save the model diagnostics
  tar_target(
    model_diagnostic_text_txt,
    generate_diagnostics(data_in = eval_data, file_out = "2_process/out/model_diagnostic_text.txt"),
    format = "file"
  )
)
