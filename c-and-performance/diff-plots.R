# Script to visualise performance tests results
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

library(tidyverse)

data <- read_csv("c-and-performance/perf-res-diff.csv")

data <- data %>%
	mutate(op = nx * ny * nz * (3 + iter)) %>%
	mutate(size = nx * ny * nz) %>%
	mutate(ipc = inst/cycl) %>%
	mutate(clck = cycl/time/10^9) %>%
	mutate(opps = op/time/10^6) %>%
	mutate(type = "1")

data2 <- read_csv("c-and-performance/perf-res-diff.csv")

data2 <- data2 %>%
	mutate(op = nx * ny * nz * (3 + iter)) %>%
	mutate(size = nx * ny * nz) %>%
	mutate(ipc = inst/cycl) %>%
	mutate(clck = cycl/time/10^9) %>%
	mutate(opps = op/time/10^6) %>%
	mutate(type = "2")

new.data <- rbind(data, data2)

ggplot(data, aes(x = size, y = opps, fill = type))+
	geom_bar(stat = "identity", position = "dodge")
