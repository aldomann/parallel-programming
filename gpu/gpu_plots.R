library(tidyverse)
library(data.table)

# Functions ------------------------------------------------

transform_times <- function(time) {
	ifelse( grepl("ns", time), as.numeric(gsub("[a-z]", "", time))/10^9,
					ifelse( grepl("us", time), as.numeric(gsub("[a-z]", "", time))/10^6,
									ifelse( grepl("ms", time), as.numeric(gsub("[a-z]", "", time))/10^3,
													ifelse( grepl("s", time), as.numeric(gsub("[a-z]", "", time)),
																	time ))))
}

clean_data<- function(df) {
	data.clean <- df %>%
		mutate(Time = transform_times(Time)) %>%
		mutate(Avg = transform_times(Avg)) %>%
		mutate(Min = transform_times(Min)) %>%
		mutate(Max = transform_times(Max))

	data.clean <- data.clean %>%
		select(Perc = `Time(%)`, Time, Avg, Min, Max, Calls, Name) %>%
		mutate(Perc = Time/sum(Time))

	return(data.clean)
}

plot_timeline <- function(df, time_col, name) {
	ggplot(df, aes_string(y = time_col, fill = "Name")) +
		geom_bar(aes(x = as.factor(1)), stat="identity", width = 0.5) +
		coord_flip() +
		theme_bw() +
		theme(axis.title.y=element_blank(),
					axis.text.y=element_blank(),
					axis.ticks.y=element_blank()) +
		labs(title = paste("Profiling results of", name),
				 y = "Time (s)")
}

plot_perf_comparison <- function(df, margin = 50, padding = 5) {
	df <- df %>% mutate(Time = Time)
	ggplot(df, aes(x = Program, y = Time, fill = Program)) +
		geom_bar(stat = "identity", position = "dodge") +
		geom_text(aes(y = Time + padding, label = round(Time, digits = 2)),
							vjust = 0, position=position_dodge(width = 0.9)) +
		labs(title = "Performance comparison (10000 iterations)",
				 x = "Version of the program",
				 y = "Time (s)") +
		scale_y_continuous(expand = c(0,margin))
}

# Construct data frames ------------------------------------

setwd("/home/aldomann/Code/C/parallel-programming/gpu")

# Read RAW data
data.gpu1.bad <- fread("results/lapGPU1-bad.dat")
data.gpu1 <- fread("results/lapGPU1.dat")
data.gpu2 <- fread("results/lapGPU2.dat")
data.gpu3 <- fread("results/lapGPU3.dat")
data.gpu4 <- fread("results/lapGPU4.dat")
data.gpu5 <- fread("results/lapGPU5.dat")
data.gpu6 <- fread("results/lapGPU6.dat")

data.cpu1 <- fread("results/lapCPU1.dat")$V1
data.cpu2 <- fread("results/lapCPU2.dat")$V1
data.cpu3 <- fread("results/lapCPU3.dat")$V1
data.cpu4 <- fread("results/lapCPU4.dat")$V1

# Interpolate iterations
data.cpu1 <- data.cpu1 * 40
data.cpu2 <- data.cpu2 * 40
data.cpu3 <- data.cpu3 * 40
data.cpu4 <- data.cpu4 * 40

# Clean RAW data
data.gpu1.bad <- clean_data(data.gpu1.bad)
data.gpu1 <- clean_data(data.gpu1)
data.gpu2 <- clean_data(data.gpu2)
data.gpu3 <- clean_data(data.gpu3)
data.gpu4 <- clean_data(data.gpu4)
data.gpu5 <- clean_data(data.gpu5)
data.gpu6 <- clean_data(data.gpu6)

# Fix GPU1 (bad) results
# data.gpu1.bad <- data.gpu1.bad %>%
# 	mutate(Time = Time * 40)

# Construct results data frames
times.cpu <- as.data.frame(
	rbind(c(data.cpu1, "cpu1"),
				c(data.cpu2, "cpu2"),
				c(data.cpu3, "cpu3"),
				c(data.cpu4, "cpu4")
	))

times.gpu <- as.data.frame(
	rbind(c(sum(data.gpu1$Time), "gpu1"),
				c(sum(data.gpu2$Time), "gpu2"),
				c(sum(data.gpu3$Time), "gpu3"),
				c(sum(data.gpu4$Time), "gpu4"),
				c(sum(data.gpu5$Time), "gpu5"),
				c(sum(data.gpu6$Time), "gpu6")
	))

colnames(times.cpu) <- c("Time", "Program")
colnames(times.gpu) <- c("Time", "Program")

times.cpu <- times.cpu %>%
	mutate(Time = as.numeric(as.character(Time)))

times.gpu <- times.gpu %>%
	mutate(Time = as.numeric(as.character(Time)))

times <- rbind(times.cpu, times.gpu)

# Analysis -------------------------------------------------

# Timelines for the GPU
plot_timeline(data.gpu1.bad, "Time", "lapGPU1 (bad)") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu1b.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)
plot_timeline(data.gpu1, "Time", "lapGPU1") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu1.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)
plot_timeline(data.gpu2, "Time", "lapGPU2") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu2.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)
plot_timeline(data.gpu3, "Time", "lapGPU3") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu3.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)
plot_timeline(data.gpu4, "Time", "lapGPU4") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu4.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)
plot_timeline(data.gpu5, "Time", "lapGPU5") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu5.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)
plot_timeline(data.gpu6, "Time", "lapGPU6") #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "timeline-gpu6.pdf", width = 5, height = 2, dpi = 96, device = cairo_pdf)

# Comparison plots
plot_perf_comparison(times.cpu, margin = 500) + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "times-cpu.pdf", width = 6, height = 2.75, dpi = 96, device = cairo_pdf)

plot_perf_comparison(times.gpu, margin = 5, padding = 1) + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "times-gpu.pdf", width = 6, height = 2.75, dpi = 96, device = cairo_pdf)

plot_perf_comparison(times, margin = 300, padding = 10) + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "times-all.pdf", width = 6.5, height = 3.5, dpi = 96, device = cairo_pdf)
