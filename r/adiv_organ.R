#!/usr/bin/env Rscript
## Purpose of script: alpha diversity boxplot
## Date created: 22.07.2020
## Author: luigui gallardo-becerra (bfllg77@gmail.com)
# Package installation
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("ggpubr")
library("dplyr")
library("ggplot2")
library("ggpubr")
# Data input
alpha_data <- read.table(file = "alpha_organ.txt", sep = "\t", header = T)
# Define colors
colors <- c("darkviolet", "mediumseagreen")
### chao1 ###
p_value <- list(c("Gut", "Hepatopancreas"))
boxplot <- ggplot(alpha_data, aes(x = group, y = chao1)) +
geom_boxplot(aes(color = group)) +
theme_test() +
theme(legend.position = "none") +
labs(x = "",
    y = "Chao1 Index") +
scale_color_manual(values = colors) +
theme(text = element_text(size = 12),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 14)) +
stat_compare_means(comparisons = p_value, 
#    label = "p.signif",
    method = "wilcox.test")
# Creation of pdf
pdf(file = "chao1_organ.pdf", width = 5, height = 5)
print (boxplot)
dev.off()

### Shannon ###
p_value <- list(c("Gut", "Hepatopancreas"))
boxplot <- ggplot(alpha_data, aes(x = group, y = shannon)) +
geom_boxplot(aes(color = group)) +
theme_test() +
theme(legend.position = "none") +
labs(x = "",
    y = "Shannon Index") +
scale_color_manual(values = colors) +
theme(text = element_text(size = 12),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 14)) +
stat_compare_means(comparisons = p_value, 
#    label = "p.signif",
    method = "wilcox.test")
# Creation of pdf
pdf(file = "shannon_organ.pdf", width = 5, height = 5)
print (boxplot)
dev.off()