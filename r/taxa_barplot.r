#!/usr/bin/env Rscript
# Title: taxa_barplot.r
# Purpose of script: taxonomy barplot
# Date created: 19.04.2021
# Author: Luigui Gallardo-Becerra (bfllg77@gmail.com)

#Installation of packages
#install.packages('optparse')
#install.packages("reshape")
library("optparse")
library("ggplot2")
library("reshape")

#Declaration of variables
option_list = list(
    make_option(c("-i", "--input"),
        default=NULL,
        help="Input matrix (separated by tabs) whith the format: taxa|group1|group2."),
    make_option(c("-o", "--output"),
        default=NULL,
        help="Output prefix name."),
    make_option(c("-f", "--format"),
        default="pdf",
        type="character",
        help="Output format, could be pdf, png or jpg."),
    make_option(c("-x", "--xlabel"),
        default="",
        type="character",
        help="X axis label."),
    make_option(c("-y", "--ylabel"),
        default="Relative abundance",
        type="character",
        help="Y axis label."),
    make_option(c("-l", "--legend_title"),
        default="Taxonomy",
        type="character",
        help="Legend title."),
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

#Reshape table
data <- melt(data)

#Creation of the graph
theme_set(theme_bw())
graph <- ggplot(data) +
geom_col(aes(x = variable,
y = value,
fill = taxa)) +
labs(x=opt$xlabel, 
    y=opt$ylabel,
    title=opt$title,
    fill = opt$legend) +
scale_x_discrete(expand = c(0, 0)) +
scale_y_continuous(limits = c(0, 1),
expand = c(0, 0)) +
theme(text = element_text(size = 12),
    axis.text.x = element_text(size = 12),
    legend.title = element_text(size = 14,
        hjust = 0.5),
    plot.title = element_text(face = "bold",
        hjust = 0.5,
        size = 15))

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
