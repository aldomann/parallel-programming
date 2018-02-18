
# Visualisation of Performance --------------------------------------------
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(viridis)

funct <- c("MPI_Init()", "MPI_Comm_size()", "MPI_Comm_rank()", "MPI_Send()", "MPI_Recv()", "MPI_Finalize()", ".TAU application")

# 2 threads
t0 <- c(283, 0, 0, 0.877, 47, 81, 7139)
t1 <- c(282, 0, 0.001, 1, 50, 81, 7138)

df0 <- data.frame(funct, val = t0, l = 0)
df1 <- data.frame(funct, val = t1, l = 1)

df2t <- rbind(df0, df1)

# 4 threads
t0 <- c(298, 0, 0, 1, 60, 81, 3809)
t1 <- c(284, 0, 0, 1, 28, 81, 3795)
t2 <- c(281, 0, 0, 1, 34, 82, 3793)
t3 <- c(276, 0, 0, 1, 55, 82, 3788)

df0 <- data.frame(funct, val = t0, l = 0)
df1 <- data.frame(funct, val = t1, l = 1)
df2 <- data.frame(funct, val = t2, l = 2)
df3 <- data.frame(funct, val = t3, l = 3)

df4t <- rbind(df0, df1, df2, df3)

# Comparing problem size

size128 <- c(287, 0.0005, 0.00025, 0.583, 7, 82, 600)
size256 <- c(334, 0, 0, 1, 15, 282, 1618)
size384 <- c(284, 0.00025, 0, 1, 12, 81, 2299)
size512 <- c(281, 0.0005, 0, 1, 13, 82, 3781)
size640 <- c(280, 0.00075, 0.00025, 1, 13, 82, 5483)
size768 <- c(281, 0.0005, 0.00025, 2, 13, 119, 7705)

df128 <- data.frame(funct, val = size128, l = 128)
df256 <- data.frame(funct, val = size256, l = 256)
df384 <- data.frame(funct, val = size384, l = 384)
df512 <- data.frame(funct, val = size512, l = 512)
df640 <- data.frame(funct, val = size640, l = 640)
df768 <- data.frame(funct, val = size768, l = 768)

dfsizes <- rbind(df128, df256, df384, df512, df640, df768)

# Function -------------------------------------------------

plot_heatmap <- function(df) {
	ggplot(df, aes(x = as.factor(funct), y = as.factor(l))) +
		geom_tile(aes(fill = log10(val))) +
		scale_fill_viridis(discrete=FALSE) +
		labs( x = "Function", y = "Thread Rank", fill = "log(Time)") +
		theme_bw()+
		theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

plot_heatmap_alt <- function(df) {
	ggplot(df, aes(x = as.factor(funct), y = as.factor(l))) +
		geom_tile(aes(fill = log10(val))) +
		scale_fill_viridis(discrete=FALSE) +
		labs( x = "Function", y = "Problem Size", fill = "log(Time)") +
		theme_bw()+
		theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

plot_heatmap(df2t) +
	ggsave(filename = "pprof-2.pdf", width = 6.5, height = 2.8, dpi = 96, device = cairo_pdf)

plot_heatmap(df4t) +
	ggsave(filename = "pprof-4.pdf", width = 6.5, height = 4, dpi = 96, device = cairo_pdf)

plot_heatmap_alt(dfsizes) +
	ggsave(filename = "pprof-sizes.pdf", width = 6.5, height = 5, dpi = 96, device = cairo_pdf)
