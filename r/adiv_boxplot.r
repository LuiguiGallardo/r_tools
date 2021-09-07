#!/usr/bin/env Rscript
# Title: adiv_boxplot.r
# Purpose of script: alpha diversity boxplot
# Date created: 19.04.2021
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)

#Installation of packages
#install.packages('optparse')
library("optparse")
library("ggplot2")

#Declaration of variables
option_list = list(
    make_option(c("-i", "--input"),
        default=NULL,
        help="Required: Input matrix (separated by tabs) whith the format: sample|group|adiv_index."),
    make_option(c("-o", "--output"),
        default=NULL,
        help="Required: Output prefix name."),
    make_option(c("-g", "--group"),
        default=NULL,
        type="character",
        help="Required: Name of the group."),
    make_option(c("-m", "--metric"),
        default=NULL,
        type="character",
        help="Required: Name of the alpha diversity metric."),
    make_option(c("-f", "--format"),
        default="pdf",
        type="character",
        help="Output format, could be pdf, png or jpg."),
    make_option(c("-x", "--xlabel"),
        default="",
        type="character",
        help="X axis label."),
    make_option(c("-y", "--ylabel"),
        default="Alpha diversity index",
        type="character",
        help="Y axis label."),
    make_option(c("-t", "--title"),
        default="",
        type="character",
        help="Title of graph.")
    )

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

#Data input
data <- read.table(opt$input, 
    sep='\t',
    header=TRUE)

#Definition of colors
num_colors = length(unique(opt$ group))
if (num_colors == 2){
    colors <- c("steelblue", "red2")
} else if (num_colors == 3){
    colors <- c("steelblue", "mediumblue", "red2")
} else {
    colors <- palette()
}

#Creation of the graph
#p_value <- list(c("Gut", "Hepatopancreas"))
theme_set(theme_bw())
graph <- ggplot(data,
    aes(x = opt$group,
    y = opt$metric)) +
geom_boxplot(aes(color = opt$group)) +
theme(legend.position = "none") +
labs(x=opt$xlabel, 
    y=opt$ylabel, 
    title=opt$title,
    subtitle = opt$subtitle) +
theme(plot.title = element_text(face = "bold",
    hjust = 0.5,
    size = 15)) +
scale_color_manual(values = colors)
#stat_compare_means(comparisons = p_value, 
#    label = "p.signif",
#    method = "wilcox.test")

#Output
if (opt$format == "pdf") {
pdf(file = paste(opt$output,".pdf", sep = ""))
    print(graph)
dev.off()
} else if (opt$format == "png") {
png(file = paste(opt$output,".png", sep = ""))
    print(graph)
dev.off()
} else if (opt$format == "jpg") {
jpeg(file = paste(opt$output,".jpg", sep = ""))
    print(graph)
dev.off()
}