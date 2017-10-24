# Script to visualise performance tests results
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

library(tidyverse)

data <- read_csv("c-and-performance/perf-res-diff.csv")

data <- data %>%
	mutate(op = nx * ny * nz * (3 + 100)) %>%
	mutate(size = nx * ny * nz) %>%
	mutate(ipc = inst/cycl) %>%
	mutate(clck = cycl/time/10^9) %>%
	mutate(opps = op/time/10^6) %>%
	mutate(type = "1")

data2 <- data %>%
	mutate(op = nx * ny * nz * (3 + 100)) %>%
	mutate(size = nx * ny * nz) %>%
	mutate(ipc = inst/cycl) %>%
	mutate(clck = cycl/time/10^9) %>%
	mutate(opps = op/time/10^6) %>%
	mutate(type = "2")

new.data <- rbind(data, data2)

ggplot(new.data, aes(x = size, y = opps, fill = type))+
	geom_bar(stat = "identity", position = "dodge")
