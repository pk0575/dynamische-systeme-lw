# Fig. 4.7: Euler's method for the Lotka-Volterra model (book, Section 4.1, Eq. 4.7)
# x_{n+1} = x_n + h (r x_n - c x_n y_n),  y_{n+1} = y_n + h (d x_n y_n - e y_n)  with h = 0.1; the exact orbit is closed
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
library(deSolve)                         # package deSolve: install.packages("deSolve")
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
cat(sprintf("H exact (constant): %.4f\n", H(3, 2)))
cat("H Euler after 40, 80, 160 steps:", sprintf("%.4f", H(x[c(41, 81, 161)], y[c(41, 81, 161)])), "\n")
plot(x, y, type = "o", pch = 16, cex = 0.5, col = rgb(0.89, 0.44, 0.49), xlab = "Prey x", ylab = "Predators y")
lines(ex[, 2], ex[, 3], col = rgb(0.43, 0.04, 0.12), lwd = 2.5)
points(c(3, 5), c(2, 2), pch = 16)
legend("topright", legend = c("Euler, h = 0.1", "exact"), col = c(rgb(0.89, 0.44, 0.49), rgb(0.43, 0.04, 0.12)), lwd = c(1, 2.5), pch = c(16, NA))
