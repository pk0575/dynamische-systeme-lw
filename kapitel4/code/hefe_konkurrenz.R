# Abb. 4.5: Konkurrenz zweier Hefearten (Buch, Abschnitt 4.1, Gl. 4.4)
# dx/dt = r1 (1 - x/K1 - g1 y) x,  dy/dt = r2 (1 - y/K2 - g2 x) y  mit den Parametern nach Gause, x(0) = y(0) = 0.5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
r1 <- 0.0607; K1 <- 5.8; g1 <- 0.0757      # S. kephir
r2 <- 0.2183; K2 <- 13; g2 <- 0.2423       # S. cerevisiae
f <- function(t, z) c(r1 * (1 - z[1] / K1 - g1 * z[2]) * z[1], r2 * (1 - z[2] / K2 - g2 * z[1]) * z[2])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

x <- loese(f, c(0.5, 0.5), seq(0, 300, length.out = 3001))
for (tt in c(50, 100, 300)) {
  i <- which(x[, 1] >= tt - 1e-9)[1]
  cat(sprintf("t = %3d h: x = %.3f,  y = %.3f\n", tt, x[i, 2], x[i, 3]))
}
cat(sprintf("y erreicht sein Maximum %.3f bei t = %.1f h\n", max(x[, 3]), x[which.max(x[, 3]), 1]))
plot(x[, 1], x[, 2], type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 10), xlab = "t (Stunden)", ylab = "Hefevolumen")
lines(x[, 1], x[, 3], col = rgb(0.89, 0.44, 0.49), lwd = 2)
legend("topright", legend = c("S. kephir x(t)", "S. cerevisiae y(t)"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
