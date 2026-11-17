# Fig. 1.33: The first steps of Newton's method (book, Section 1.5, Eq. 1.44)
# x_{n+1} = x_n - g(x_n)/g'(x_n) for g(x) = exp(-5x) - x with x_0 = 0.05
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
g <- function(x) exp(-5 * x) - x
dg <- function(x) -5 * exp(-5 * x) - 1

x <- numeric(7); x[1] <- 0.05
for (k in 1:6) x[k + 1] <- x[k] - g(x[k]) / dg(x[k])
for (k in 1:7) cat(sprintf("x_%d = %.12f\n", k - 1, x[k]))   # the number of correct digits roughly doubles per step

xx <- seq(0, 0.35, length.out = 300)
par(mfrow = c(1, 2))
for (p in 1:2) {
  plot(xx, g(xx), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, xlim = c(0, 0.35), ylim = c(-0.35, 1), xlab = "x", ylab = "")
  abline(h = 0)
  for (j in 1:p) {                       # tangent at x_{j-1}, its root is x_j
    lines(xx, g(x[j]) + dg(x[j]) * (xx - x[j]))
    lines(c(x[j], x[j]), c(0, g(x[j])), lty = 3)
  }
  points(x[1:(p + 1)], rep(0, p + 1), pch = 16, col = rgb(0.64, 0.08, 0.18))
}
