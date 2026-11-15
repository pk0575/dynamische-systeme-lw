# Abb. 4.7: Euler-Verfahren für das Lotka-Volterra-Modell (Buch, Abschnitt 4.1, Gl. 4.7)
# x_{n+1} = x_n + h (r x_n - c x_n y_n),  y_{n+1} = y_n + h (d x_n y_n - e y_n)  mit h = 0.1; die exakte Bahn ist geschlossen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
r <- 1; c <- 0.5; d <- 0.2; e <- 1
f <- function(t, z) c(r * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2])
h <- 0.1; N <- 160
x <- numeric(N + 1); y <- numeric(N + 1); x[1] <- 3; y[1] <- 2
for (n in 1:N) {
  x[n + 1] <- x[n] + h * (r * x[n] - c * x[n] * y[n])
  y[n + 1] <- y[n] + h * (d * x[n] * y[n] - e * y[n])
}
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)
ex <- loese(f, c(3, 2), seq(0, 6.5, length.out = 651))
H <- function(x, y) d * x - e * log(x) + c * y - r * log(y)
cat(sprintf("H exakt (konstant): %.4f\n", H(3, 2)))
cat("H Euler nach 40, 80, 160 Schritten:", sprintf("%.4f", H(x[c(41, 81, 161)], y[c(41, 81, 161)])), "\n")
plot(x, y, type = "o", pch = 16, cex = 0.5, col = rgb(0.89, 0.44, 0.49), xlab = "Beute x", ylab = "Räuber y")
lines(ex[, 2], ex[, 3], col = rgb(0.43, 0.04, 0.12), lwd = 2.5)
points(c(3, 5), c(2, 2), pch = 16)
legend("topright", legend = c("Euler, h = 0.1", "exakt"), col = c(rgb(0.89, 0.44, 0.49), rgb(0.43, 0.04, 0.12)), lwd = c(1, 2.5), pch = c(16, NA))
