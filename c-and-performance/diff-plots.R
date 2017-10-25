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

data1 <- read_results("c-and-performance/perf-base1.csv", "base1")
data2 <- read_results("c-and-performance/perf-base2.csv", "base2")
data3 <- read_results("c-and-performance/perf-base3.csv", "base3")

new.data <- rbind(data1, data2, data3)

ggplot(new.data, aes(x = reorder(f2si2(size), size), y = opps, fill = type))+
	geom_bar(stat = "identity", position = "dodge") +
	geom_text(aes(y = opps * 1.01, label = round(opps)),
						vjust = -0.1, position=position_dodge(width=0.9)) +
	labs(title = "Performance results",
			 x = "Size of the problem",
			 y = "Performance (Mega SAXPYs/second)")
