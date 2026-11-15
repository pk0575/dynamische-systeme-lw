# Abb. 4.6: gedämpfter Oszillator (Buch, Abschnitt 4.1, Gl. 4.5 und 4.6)
# m x'' + mu x' + k x = 0 als System dx1/dt = x2, dx2/dt = -(k x1 + mu x2)/m  mit m = 1, mu = 0.4, k = 4, x1(0) = 1, x2(0) = 0
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
m <- 1; mu <- 0.4; k <- 4
f <- function(t, z) c(z[2], -(k * z[1] + mu * z[2]) / m)
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

x <- loese(f, c(1, 0), seq(0, 20, length.out = 2001))
for (tt in c(5, 10, 20)) {
  i <- which(x[, 1] >= tt - 1e-9)[1]
  cat(sprintf("t = %2d: x1 = %7.4f,  x2 = %7.4f\n", tt, x[i, 2], x[i, 3]))
}
par(mfrow = c(1, 2))
plot(x[, 1], x[, 2], type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(-2.2, 2.2), xlab = "t", ylab = "")
lines(x[, 1], x[, 3], col = rgb(0.89, 0.44, 0.49), lwd = 2); abline(h = 0)
legend("topright", legend = c("Ort x1", "Geschwindigkeit x2"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
plot(x[, 2], x[, 3], type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlab = "Ort x1", ylab = "Geschwindigkeit x2")
points(c(1, 0), c(0, 0), pch = 16)
