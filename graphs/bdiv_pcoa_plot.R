#!/usr/bin/env R
## Purpose of script: beta diversity pcoa plot
## Date created: 13.07.2020
## Author: luigui gallardo-becerra (bfllg77@gmail.com)

#Installation of packages
#install.packages('optparse')
library("optparse")
library("ggplot2")

#Declaration of variables
option_list = list(
    make_option(c("-i", "--input"),
        default=NULL,
        help="Input matrix (separated by tabs) whith the format: sample|group|pcoa1(x)|pcoa2(y)."),
    make_option(c("-o", "--output"),
        default=NULL,
        help="Output prefix name."),
    make_option(c("-f", "--format"),
        default="pdf",
        type="character",
        help="Output format, could be pdf, png or jpg."),
    make_option(c("-x", "--xlabel"),
        default="PC1",
        type="character",
        help="X axis label."),
    make_option(c("-y", "--ylabel"),
        default="PC2",
        type="character",
        help="Y axis label."),
    make_option(c("-t", "--tittle"),
        default="PC1 vs PC2",
        type="character",
        help="Tittle of graph."),
    make_option(c("-s", "--subtitle"),
        default="Subtitle",
        type="character",
        help="Subtitle of the graph.")
    )

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

#Data input
data <- read.table(opt$input, sep='\t')
group = data$V2
print(opt$groups)

#Definition of colors
num_colors = length(unique(group))
if (num_colors == 2){
    colors <- c("steelblue", "red2")
} else if (num_colors == 3){
    colors <- c("steelblue", "mediumblue", "red2")
} else {
    colors <- palette()
}
#Definition of shapes
num_shapes = length(unique(group))
if (num_shapes == 2) {
    shapes <- c(15, 16)
} else if (num_shapes == 3){
    shapes <- c(15, 16, 17)
} else {
    shapes <- 16
}

# Creation of the graph
theme_set(theme_bw())
graph <- ggplot(data, aes(V3, V4)) +
geom_point(aes(col=group,
    shape=group),
    size = 3) +
labs(x=opt$xlabel, 
    y=opt$ylabel, 
    title=opt$tittle,
    subtitle = opt$subtitle) +
theme(plot.title = element_text(face = "bold",
    hjust = 0.5,
    size = 15),
    plot.subtitle = element_text(hjust=0.5)) +
geom_hline(yintercept=0,
    color = "gray") +
geom_vline(xintercept=0,
    color = "gray") +
scale_color_manual(values = colors) +
scale_shape_manual(values = shapes) +
theme(legend.title = element_blank(),
    legend.position = "bottom",
    legend.background=element_blank())

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

