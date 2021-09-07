#!/usr/bin/env Rscript
# Title: rpkm_log2_fer.r
# Purpose of script: barplot with the log2 RPKM values
# Date created: 20.08.2021
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)

# Packages
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("ggpubr")) install.packages("ggpubr")
if (!require("svglite")) install.packages("svglite")
if (!require("optparse")) install.packages("optparse")

library("ggplot2")
library("ggpubr")
library("svglite")
library("optparse")

#Declaration of variables
option_list = list(
  make_option(c("-i", "--input"),
              default=NULL,
              help="Required: Input matrix (separated by tabs) whith the format: scaffold|value"),
  make_option(c("-o", "--output"),
              default=NULL,
              help="Required: Output prefix name"),
  make_option(c("-t", "--title"),
              default="",
              type="character",
              help="Title of graph"),
  make_option(c("-c", "--color"),
              default="skyblue4",
              type="character",
              help="Color of the bars")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# Data input 
rpkm_table <- read.table(opt$input,
                          sep = '\t',
                          header = TRUE)

# log2 transformation
rpkm_table$value = log2(rpkm_table$value)

# Graph
theme_set(theme_bw())

rpkm_histograpm_plot <- ggplot(rpkm_table, aes(x=value)) +
  geom_histogram(aes(x=value),
                 colour="black", 
                 fill=opt$color,
                 binwidth = 0.1) + # Distance between values to plot (default = 1)
  labs(x="log2 (RPKM)",
       y="Frecuency",
       title=opt$title)

# Plot information
plot_information <- ggplot_build(rpkm_histograpm_plot)

plot_information_data <- plot_information$plot$data

write.table(plot_information_data,
            file = paste(opt$output,".txt", sep = ""),
            sep = '\t',
            row.names = FALSE)

# Output files
# svg
svglite(file = paste(opt$output,".svg", sep = ""))
  print(rpkm_histograpm_plot)
dev.off()

# png
png(file = paste(opt$output,".png", sep = ""))
  print(rpkm_histograpm_plot)
dev.off()