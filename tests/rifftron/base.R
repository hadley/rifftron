x <- c(84L, 64L, 24L, 53L, 16L, 97L, 44L, 31L, 51L, 79L)
names(x) <- letters[1:10]
y <- c(77L, 17L, 98L, 41L, 76L, 28L, 44L, 58L, 35L, 95L)

capture_plot("Scatterplot", plot(x, y))

capture_plot("Bar chart", barplot(x))

capture_plot("Pie graph", pie(x))
