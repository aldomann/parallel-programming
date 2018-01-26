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
	data_clean <- df %>%
		mutate(Time = transform_times(Time)) %>%
		mutate(Avg = transform_times(Avg)) %>%
		mutate(Min = transform_times(Min)) %>%
		mutate(Max = transform_times(Max))

	data_clean <- data_clean %>%
		select(Perc = `Time(%)`, Time, Avg, Min, Max, Calls, Name) %>%
		mutate(Perc = Time/sum(Time))

	return(data_clean)
}

plot_timeline <- function(df, time_col) {
	ggplot(df, aes_string(y = time_col, fill = "Name")) +
		geom_bar(aes(x = as.factor(1)), stat="identity", width = 0.5) +
		coord_flip() +
		theme_bw() +
		theme(axis.title.y=element_blank(),
					axis.text.y=element_blank(),
					axis.ticks.y=element_blank()) +
		labs(title = "Profiling results",
				 y = "Time (s)")
}

plot_perf_comparison <- function(df) {
	df <- df %>% mutate(Time = Time * 4)
	ggplot(df, aes(x = Program, y = Time, fill = Program)) +
		geom_bar(stat = "identity", position = "dodge") +
		geom_text(aes(y = Time + 5, label = round(Time, digits = 2)),
							vjust = 0, position=position_dodge(width = 0.9)) +
		labs(title = "Performance comparison (1000 iterations)",
				 x = "Version of the program",
				 y = "Time (s)")
}


# Construct data frames ------------------------------------

setwd("/home/aldomann/Code/C/parallel-programming/gpu")

# Read RAW data
data_gpu1 <- fread("results/lapGPU1.dat")
data_gpu2 <- fread("results/lapGPU2.dat")
data_gpu3 <- fread("results/lapGPU3.dat")
data_gpu4 <- fread("results/lapGPU4.dat")
data_cpu1 <- fread("results/lapCPU1.dat")$V1
data_cpu2 <- fread("results/lapCPU2.dat")$V1
data_cpu3 <- fread("results/lapCPU3.dat")$V1
data_cpu4 <- fread("results/lapCPU4.dat")$V1

# Clean RAW data
data_gpu1 <- clean_data(data_gpu1)
data_gpu2 <- clean_data(data_gpu2)
data_gpu3 <- clean_data(data_gpu3)
data_gpu4 <- clean_data(data_gpu4)

# Construct results data frame
times <- as.data.frame(
	rbind(c(data_cpu1, "cpu1"),
				c(data_cpu2, "cpu2"),
				c(data_cpu3, "cpu3"),
				c(data_cpu4, "cpu4"),
				c(sum(data_gpu1$Time), "gpu1"),
				c(sum(data_gpu2$Time), "gpu2"),
				c(sum(data_gpu3$Time), "gpu3"),
				c(sum(data_gpu4$Time), "gpu4")
				))

colnames(times) <- c("Time", "Program")

times <- times %>%
	mutate(Time = as.numeric(as.character(Time)))

# Analysis -------------------------------------------------

plot_timeline(data_gpu1, "Time")
plot_timeline(data_gpu2, "Time")
plot_timeline(data_gpu3, "Time")

plot_perf_comparison(times) + theme_bw()
