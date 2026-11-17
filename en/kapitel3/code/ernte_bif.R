# Fig. 3.16: Fish stock with harvesting, steady states as a function of the harvesting rate (book, Section 3.3)
# dx/dt = r (1 - x/K) x - h x with r = 0.5 per year, K = 100 (1000 t):  x_a* = 0 and x_b* = K (1 - h/r)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r <- 0.5; K <- 100
gruen <- rgb(0, 0.39, 0)
h <- seq(0, 1, length.out = 301)
li <- h <= r; re <- h >= r; nah <- h >= r & h <= 0.62
plot(h[li], 0 * h[li], type = "l", lty = 2, col = gruen, lwd = 2, xlim = c(0, 1), ylim = c(-30, 105),
     xlab = "Harvesting rate h (per year)", ylab = "x* (1000 t)")     # x_a* unstable for h < r
lines(h[re], 0 * h[re], col = gruen, lwd = 3)                   # stable for h > r
lines(h[li], K * (1 - h[li] / r), col = gruen, lwd = 3)         # x_b* stable for h < r
lines(h[nah], K * (1 - h[nah] / r), lty = 2, col = gruen, lwd = 2)
abline(v = r, lty = 3)
for (hh in c(0.1, 0.25, 0.4)) cat(sprintf("h = %g: x_b* = %.0f,  yield h x_b* = %.2f\n", hh, K * (1 - hh / r), hh * K * (1 - hh / r)))
