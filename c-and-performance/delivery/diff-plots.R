# Script to visualise performance tests results
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

library(tidyverse)

# Functions definitions ------------------------------------

# Rounded version of f2si from sitools library
f2si2 <- function (number) {
	lut <- c(1, 1000, 1e+06, 1e+09)
	pre <- c("", "k", "M", "G")
	ix <- findInterval(number, lut)

	if (ix > 0 && ix < length(lut) && lut[ix] != 1) {
		sistring <- paste(round(number/lut[ix]), pre[ix])
	}
	else {
		sistring <- as.character(number)
	}
	return(sistring)
}

# Logarithmic transformation
library(scales)
mylog_trans <- function(base=exp(1), from=0)
{
	trans <- function(x) log(x, base)-from
	inv <- function(x) base^(x+from)
	trans_new("mylog", trans, inv, log_breaks(base=base),
						domain = c(base^from, Inf))
}

# Read results
read_results <- function(file, typ) {
	data <- read_csv(file)
	data <- data %>%
		mutate(type = typ) %>%
		mutate(brpmiss = brmiss/br) %>%
		mutate(op = nx * ny * nz * (3 + iter)) %>%
		mutate(size = nx * ny * nz) %>%
		mutate(ipc = inst/cycl) %>%
		mutate(clck = cycl/time/10^9) %>%
		mutate(opps = op/time/10^6) %>%
		mutate(acc = abs(acc))
	return(data.frame(data))
}

# Read data and create plots -------------------------------

# Accuracy plots
get_acc_plots <- function(df) {
	ggplot(df, aes(x = reorder(f2si2(size), size), y = acc, fill = type))+
		geom_bar(stat = "identity", position = "dodge") +
		scale_y_continuous(trans = mylog_trans(base=10, from=-10 )) +
		labs(title = "Accuracy analysis",
				 x = "Size of the problem",
				 y = "Accuracy")
}

# Performance plots
get_perf_plots <- function(df, subtitle) {
	ggplot(df, aes(x = reorder(f2si2(size), size), y = opps, fill = type))+
		geom_bar(stat = "identity", position = "dodge") +
		geom_text(aes(y = opps * 1.01, label = round(opps)),
							vjust = -0.1, position=position_dodge(width=0.9)) +
		labs(title = paste("Performance results", subtitle),
				 x = "Size of the problem",
				 y = "Performance (Mega SAXPYs/second)")
}

# Time plots
get_time_plots <- function(df) {
	ggplot(df, aes(x = reorder(f2si2(size), size))) +
		geom_bar(aes(y = time, fill = "time"), stat = "identity", position = "stack") +
		geom_bar(aes(y = init, fill = "init"), stat = "identity", position = "stack") +
		scale_y_continuous(trans = mylog_trans(base=10, from=-4 )) +
		labs(title = "Elapsed time analysis",
				 x = "Size of the problem",
				 y = "Time (s)")
}
