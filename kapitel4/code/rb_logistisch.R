# Abb. 4.2: kontinuierliches Räuber-Beute-Modell (Buch, Abschnitt 4.1, Gl. 4.2)
# dx/dt = r (1 - x/K) x - c x y,  dy/dt = d x y - e y  mit r = 1, K = 10, c = 0.5, d = 0.2, e = 1, x(0) = 8, y(0) = 0.5
# links Zeitverläufe, rechts dieselbe Lösung in der Phasenebene
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
r <- 1; K <- 10; c <- 0.5; d <- 0.2; e <- 1
f <- function(t, z) c(r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

x <- loese(f, c(8, 0.5), seq(0, 40, length.out = 2001))   # Spalten: Zeit, x, y
for (tt in c(10, 20, 40)) {
  i <- which(x[, 1] >= tt - 1e-9)[1]
  cat(sprintf("t = %2d: x = %.3f,  y = %.3f\n", tt, x[i, 2], x[i, 3]))
}
cat(sprintf("stationärer Zustand (e/d, r/c (1 - e/(d K))) = (%g, %g)\n", e / d, r / c * (1 - e / (d * K))))
par(mfrow = c(1, 2))
plot(x[, 1], x[, 2], type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 10), xlab = "t", ylab = "")
lines(x[, 1], x[, 3], col = rgb(0.89, 0.44, 0.49), lwd = 2)
legend("topright", legend = c("Beute x(t)", "Räuber y(t)"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
plot(x[, 2], x[, 3], type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlab = "Beute x", ylab = "Räuber y")
points(c(8, 5), c(0.5, 1), pch = 16)
