# Fig. 3.12: Logistic growth of yeast (book, Section 3.2, Eq. 3.19 and 3.20)
# dx/dt = r (1 - x/K) x with r = 0.55 per hour, K = 210 (million cells per ml); solution x(t) = x0 K / (x0 + (K - x0) e^(-rt))
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r <- 0.55; K <- 210
x <- function(t, x0) x0 * K / (x0 + (K - x0) * exp(-r * t))
t <- seq(0, 20, length.out = 300)
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49))
x0s <- c(5, 50, 300)
plot(NULL, xlim = c(0, 20), ylim = c(0, 310), xlab = "t (h)", ylab = "x(t)")
for (i in 1:3) {
  lines(t, x(t, x0s[i]), lty = i, col = rot[i], lwd = 2)
  cat(sprintf("x0 = %3d: x(5) = %6.2f,  x(20) = %6.2f\n", x0s[i], x(5, x0s[i]), x(20, x0s[i])))
}
abline(h = K, lty = 2)
legend("bottomright", legend = sprintf("x0 = %d", x0s), col = rot, lty = 1:3, lwd = 2)
