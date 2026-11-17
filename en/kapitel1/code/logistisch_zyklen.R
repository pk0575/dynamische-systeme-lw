# Fig. 1.30: Iterates f^2 and f^3 of the logistic model (book, Section 1.4, Eq. 1.38)
# left: f^2 with a = 3.1 (stable 2-cycle);  right: f^3 with a = 3.835 (stable 3-cycle)
# fixed points of f^k: filled black = stable (|(f^k)'| < 1), white = unstable
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
x <- seq(0, 1, length.out = 2000)
par(mfrow = c(1, 2))
for (p in 1:2) {
  a <- c(3.1, 3.835)[p]; k <- c(2, 3)[p]
  f <- function(y) a * y * (1 - y)
  fk <- if (k == 2) function(y) f(f(y)) else function(y) f(f(f(y)))   # f^2 or f^3
  plot(x, fk(x), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(0, 1), ylim = c(0, 1),
       xlab = "x", ylab = sprintf("f^%d(x)", k), main = sprintf("a = %g", a))
  abline(0, 1)
  # fixed points: look for sign changes of f^k(x) - x, then determine precisely with uniroot
  xg <- seq(0, 1, length.out = 20001); g <- fk(xg) - xg
  idx <- which(sign(g[-length(g)]) != sign(g[-1]))
  pts <- 0
  for (i in idx) pts <- c(pts, uniroot(function(z) fk(z) - z, c(xg[i], xg[i + 1]), tol = 1e-12)$root)
  pts <- unique(round(pts * 1e10) / 1e10)
  for (q in pts) {
    e <- 1e-7; ableitung <- (fk(q + e) - fk(q - e)) / (2 * e)
    stabil <- abs(ableitung) < 1
    points(q, q, pch = 21, bg = if (stabil) "black" else "white")
    cat(sprintf("a = %g, f^%d:  x = %.4f  %s  (derivative %.3f)\n", a, k, q, if (stabil) "stable" else "unstable", ableitung))
  }
}
