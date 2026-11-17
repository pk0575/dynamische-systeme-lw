# Fig. 4.2: Continuous predator-prey model (book, Section 4.1, Eq. 4.2)
# dx/dt = r (1 - x/K) x - c x y,  dy/dt = d x y - e y  with r = 1, K = 10, c = 0.5, d = 0.2, e = 1, x(0) = 8, y(0) = 0.5
# left time courses, right the same solution in the phase plane
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
library(deSolve)                         # package deSolve: install.packages("deSolve")
r <- 1; K <- 10; c <- 0.5; d <- 0.2; e <- 1
f <- function(t, z) c(r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

x <- loese(f, c(8, 0.5), seq(0, 40, length.out = 2001))   # columns: time, x, y
for (tt in c(10, 20, 40)) {
  i <- which(x[, 1] >= tt - 1e-9)[1]
  cat(sprintf("t = %2d: x = %.3f,  y = %.3f\n", tt, x[i, 2], x[i, 3]))
}
cat(sprintf("steady state (e/d, r/c (1 - e/(d K))) = (%g, %g)\n", e / d, r / c * (1 - e / (d * K))))
par(mfrow = c(1, 2))
plot(x[, 1], x[, 2], type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 10), xlab = "t", ylab = "")
lines(x[, 1], x[, 3], col = rgb(0.89, 0.44, 0.49), lwd = 2)
legend("topright", legend = c("Prey x(t)", "Predators y(t)"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
plot(x[, 2], x[, 3], type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlab = "Prey x", ylab = "Predators y")
points(c(8, 5), c(0.5, 1), pch = 16)
