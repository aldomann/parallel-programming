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

read_results <- function(file, type) {
	data <- read_csv(file)
	data <- data %>%
		mutate(op = nx * ny * nz * (3 + iter)) %>%
		mutate(size = nx * ny * nz) %>%
		mutate(ipc = inst/cycl) %>%
		mutate(clck = cycl/time/10^9) %>%
		mutate(opps = op/time/10^6) %>%
		mutate(type = type)
	return(data.frame(data))
}

# Read data and create plots -------------------------------

data1 <- read_results("c-and-performance/perf-res-diff.csv", "base")
data2 <- read_results("c-and-performance/perf-res-diff.csv", "optimised")

new.data <- rbind(data1, data2)

ggplot(new.data, aes(x = reorder(f2si2(size), size), y = opps, fill = type))+
	geom_bar(stat = "identity", position = "dodge") +
	labs(x = "Size of the problem", y = "Performance (Giga SAXPYs/second)")

