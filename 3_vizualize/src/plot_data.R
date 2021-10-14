#' Generate diagnostic text based on model results
#' 
#' Takes model output, calculates summary statistics for models
#' and produces a text file
#' 
#' @param data_in tbl, model results from ScienceBase, modified by previous pipeline step
#' @param file_out string, location where diagnostic text will be saved. Must include file name (as png)
#' @param ... further arguments passed to `png`

plot_data <- function(data_in, file_out, ...){
  # Create a plot
  png(file = file.path(file_out), ...)
  par(omi = c(0,0,0.05,0.05), mai = c(1,1,0,0), las = 1, mgp = c(2,0.5,0), cex = 1.5)
  
  plot(NA, NA, xlim = c(2, 1000), ylim = c(4.7, 0.75),
       ylab = "Test RMSE (°C)", xlab = "Training temperature profiles (#)", log = 'x', axes = FALSE)
  
  n_profs <- unique(data_in$n_prof) %>% sort(.) # removing hard coding of x-axis labels
  # n_profs <- c(2, 10, 50, 100, 500, 980)
  
  axis(1, at = c(-100, n_profs, 1e10), labels = c("", n_profs, ""), tck = -0.01) # y-axis
  axis(2, at = seq(0,10), las = 1, tck = -0.01) # x-axis
  
  # slight horizontal offsets so the markers don't overlap:
  offsets <- data.frame(pgdl = c(0.15, 0.5, 3, 7, 20, 30)) %>%
    mutate(dl = -pgdl, pb = 0, n_prof = n_profs)
  
  # loop to generate base plot
  for (mod in c('pb','dl','pgdl')){
    mod_data <- filter(data_in, model_type == mod)
    mod_profiles <- unique(mod_data$n_prof)
    for (mod_profile in mod_profiles){
      d <- filter(mod_data, n_prof == mod_profile) %>% summarize(y0 = min(rmse), y1 = max(rmse), col = unique(col))
      x_pos <- offsets %>% filter(n_prof == mod_profile) %>% pull(!!mod) + mod_profile
      lines(c(x_pos, x_pos), c(d$y0, d$y1), col = d$col, lwd = 2.5)
    }
    d <- group_by(mod_data, n_prof) %>% summarize(y = mean(rmse), col = unique(col), pch = unique(pch)) %>%
      rename(x = n_prof) %>% arrange(x)
    
    lines(d$x + tail(offsets[[mod]], nrow(d)), d$y, col = d$col[1], lty = 'dashed')
    points(d$x + tail(offsets[[mod]], nrow(d)), d$y, pch = d$pch[1], col = d$col[1], bg = 'white', lwd = 2.5, cex = 1.5)
    
  }
  
  # add legend 
  ## generate named list from values assigned in `prep_data` function
  d_legend <- eval_data %>% distinct(model_type, col, pch) %>% 
    mutate(label = case_when(
      model_type == 'dl' ~ 'Deep Learning',
      model_type == 'pb' ~ 'Process-Based',
      model_type == 'pgdl' ~ 'Process-Guided Deep Learning'
    )) %>% 
    asplit(., 1)
  names(d_legend) <- unique(eval_data$model_type)
  
  
  ## Use named list to add labels for each model
  # PGDL label
  points(2.2, 0.79, col = d_legend$`pgdl`[[2]], pch = as.numeric(d_legend$`pgdl`[[3]]), bg = 'white', lwd = 2.5, cex = 1.5)
  text(2.3, 0.80, d_legend$`pgdl`[[4]], pos = 4, cex = 1.1)
  # points(2.2, 0.79, col = '#7570b3', pch = 23, bg = 'white', lwd = 2.5, cex = 1.5)
  # text(2.3, 0.80, 'Process-Guided Deep Learning', pos = 4, cex = 1.1)
  
  # DL label
  points(2.2, 0.94, col = d_legend$`dl`[[2]], pch = as.numeric(d_legend$`dl`[[3]]), bg = 'white', lwd = 2.5, cex = 1.5)
  text(2.3, 0.95, d_legend$`dl`[[4]], pos = 4, cex = 1.1)
  # points(2.2, 0.94, col = '#d95f02', pch = 22, bg = 'white', lwd = 2.5, cex = 1.5)
  # text(2.3, 0.95, 'Deep Learning', pos = 4, cex = 1.1)
  
  # PB label
  points(2.2, 1.09, col = d_legend$`pb`[[2]], pch = as.numeric(d_legend$`pb`[[3]]), bg = 'white', lwd = 2.5, cex = 1.5)
  text(2.3, 1.1, d_legend$`pb`[[4]], pos = 4, cex = 1.1)
  # points(2.2, 1.09, col = '#1b9e77', pch = 21, bg = 'white', lwd = 2.5, cex = 1.5)
  # text(2.3, 1.1, 'Process-Based', pos = 4, cex = 1.1)
  
  dev.off()
}