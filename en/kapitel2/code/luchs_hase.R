# Fig. 2.2: Lynx and snowshoe hares (book, Section 2.1)
# number of pelts purchased by the Hudson's Bay Company (in thousands), 1900-1920, after Odum (1953)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
jahr <- 1900:1920
hasen <- c(30, 47.2, 70.2, 77.4, 36.3, 20.6, 18.1, 21.4, 22, 25.4, 27.1, 40.3, 57, 76.6, 52.3, 19.5, 11.2, 7.6, 14.6, 16.2, 24.7)
luchse <- c(4, 6.1, 9.8, 35.2, 59.4, 41.7, 19, 13, 8.3, 9.1, 7.4, 8, 12.3, 19.5, 45.7, 51.1, 29.7, 15.8, 9.7, 10.1, 8.6)

for (g in list(c(1900, 1909), c(1910, 1920))) {      # maxima per decade: the lynx follow the hares
  m <- jahr >= g[1] & jahr <= g[2]
  cat(sprintf("%d-%d: most hares %d, most lynx %d\n", g[1], g[2], jahr[m][which.max(hasen[m])], jahr[m][which.max(luchse[m])]))
}

plot(jahr, hasen, type = "o", lty = 2, pch = 16, col = rgb(0.43, 0.04, 0.12), ylim = c(0, 80), xlab = "Year", ylab = "Pelts (thousands)")
lines(jahr, luchse, type = "o", lty = 2, pch = 15, col = rgb(0.89, 0.44, 0.49))
legend("topright", legend = c("Snowshoe hares", "Lynx"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), pch = c(16, 15), lty = 2)
