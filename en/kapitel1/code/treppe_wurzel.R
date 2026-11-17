# Fig. 1.26: Staircase diagrams for x_{n+1} = sqrt(x_n) (book, Section 1.4, Eq. 1.31)
# x_0 = 0.5 (left) and x_0 = 1.4 (right); the staircase runs toward the intersection of f(x) = sqrt(x) with y = x
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
treppe <- function(x, unten = 0) {      # points of the staircase: vertically to the graph, horizontally to the diagonal
  px <- x[1]; py <- unten
  for (k in 1:(length(x) - 1)) { px <- c(px, x[k], x[k + 1]); py <- c(py, x[k + 1], x[k + 1]) }
  list(x = px, y = py)
}
xx <- seq(0, 1.5, length.out = 300)
N <- 4
par(mfrow = c(1, 2))
for (x0 in c(0.5, 1.4)) {
  x <- numeric(N + 1); x[1] <- x0
  for (k in 1:N) x[k + 1] <- sqrt(x[k])
  cat(sprintf("x_0 = %g:", x0), sprintf("%.4f", x), "\n")
  plot(xx, sqrt(xx), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(0, 1.5), ylim = c(0, 1.5),
       xlab = "x", ylab = "f(x)")
  abline(0, 1)
  lines(treppe(x), col = rgb(0.64, 0.08, 0.18))
}
