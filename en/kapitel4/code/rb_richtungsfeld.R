# Fig. 4.3: Direction field of the predator-prey model (book, Section 4.1, Eq. 4.2)
# arrows in the direction (dx/dt, dy/dt), all of equal length; plus the solution from Fig. 4.2 and the steady states
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
library(deSolve)                         # package deSolve: install.packages("deSolve")
r <- 1; K <- 10; c <- 0.5; d <- 0.2; e <- 1
f <- function(t, z) c(r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)
feld <- function(f, xl, yl, nx, ny, laenge = 0.3) {   # direction field: arrows of equal length (relative to the axis lengths)
  g <- expand.grid(x = seq(xl[1], xl[2], length.out = nx), y = seq(yl[1], yl[2], length.out = ny))
  w <- t(apply(g, 1, function(p) f(0, p))); sx <- diff(xl); sy <- diff(yl)
  u <- w[, 1] / sx; v <- w[, 2] / sy; L <- sqrt(u^2 + v^2) + 1e-12
  arrows(g$x, g$y, g$x + u / L * laenge * sx / 11, g$y + v / L * laenge * sy / 11, length = 0.04, col = rgb(0.2, 0.6, 0.25))
}

plot(NULL, xlim = c(0, 11), ylim = c(0, 3), xlab = "Prey x", ylab = "Predators y")
feld(f, c(0.4, 10.6), c(0.15, 2.85), 18, 10)
x <- loese(f, c(8, 0.5), seq(0, 40, length.out = 2001))
lines(x[, 2], x[, 3], col = rgb(0.64, 0.08, 0.18), lwd = 2)
points(c(0, 10), c(0, 0), pch = 21, bg = "white", cex = 1.3, xpd = TRUE)   # unstable
points(5, 1, pch = 16, cex = 1.3)                                          # stable
for (p in list(c(0, 0), c(10, 0), c(5, 1))) { w <- f(0, p); cat(sprintf("(%2d, %g): dx/dt = %g, dy/dt = %g\n", p[1], p[2], w[1], w[2])) }
