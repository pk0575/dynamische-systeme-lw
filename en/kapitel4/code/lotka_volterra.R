# Fig. 4.4: Classical Lotka-Volterra model (book, Section 4.1, Eq. 4.3)
# dx/dt = r x - c x y,  dy/dt = d x y - e y  with r = 1, c = 0.5, d = 0.2, e = 1
# left periodic time courses for x(0) = 3, y(0) = 2, right closed orbits for different initial values
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
library(deSolve)                         # package deSolve: install.packages("deSolve")
r <- 1; c <- 0.5; d <- 0.2; e <- 1
f <- function(t, z) c(r * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2])
H <- function(x, y) d * x - e * log(x) + c * y - r * log(y)   # remains constant along every solution
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)

par(mfrow = c(1, 2))
x <- loese(f, c(3, 2), seq(0, 25, length.out = 2501))
plot(x[, 1], x[, 2], type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 10), xlab = "t", ylab = "")
lines(x[, 1], x[, 3], col = rgb(0.89, 0.44, 0.49), lwd = 2)
legend("topright", legend = c("Prey", "Predators"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49))
plot(NULL, xlim = c(0, 16), ylim = c(0, 7), xlab = "Prey x", ylab = "Predators y")
x0s <- c(4, 3, 1.5)
for (i in 1:3) {
  x <- loese(f, c(x0s[i], 2), seq(0, 12, length.out = 1201))
  lines(x[, 2], x[, 3], col = rot[i], lwd = 2)
  n <- nrow(x)
  cat(sprintf("x(0) = %g: H at the start %.6f, at the end %.6f\n", x0s[i], H(x0s[i], 2), H(x[n, 2], x[n, 3])))
}
points(e / d, r / c, pch = 16)
