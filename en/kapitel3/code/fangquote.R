# Fig. 3.17: Harvesting with a fixed catch quota (book, Section 3.3)
# dx/dt = r (1 - x/K) x - q with r = 0.5, K = 100;  steady at x* = K/2 (1 ± sqrt(1 - 4q/(rK))) as long as q <= rK/4 = 12.5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r <- 0.5; K <- 100
gruen <- rgb(0, 0.39, 0)
par(mfrow = c(1, 2))
x <- seq(0, 100, length.out = 300)
plot(x, r * x * (1 - x / K), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, ylim = c(0, 17), xlab = "x (1000 t)", ylab = "",
     main = "Growth r x (1 - x/K) and catch q")
qs <- c(8, 12.5, 16)
for (i in 1:3) abline(h = qs[i], lty = i, col = rgb(0.64, 0.08, 0.18), lwd = 2)
legend("bottom", legend = c("Growth", sprintf("q = %g", qs)), col = c(rgb(0, 0.447, 0.741), rep(rgb(0.64, 0.08, 0.18), 3)), lty = c(1, 1:3), lwd = 2, cex = 0.8)
q <- seq(0, 12.5, length.out = 300)
w <- sqrt(1 - 4 * q / (r * K))
plot(q, K / 2 * (1 + w), type = "l", col = gruen, lwd = 3, xlim = c(0, 21), ylim = c(0, 100),
     xlab = "Catch quota q (1000 t/year)", ylab = "", main = "bifurcation diagram")
lines(q, K / 2 * (1 - w), lty = 2, col = gruen, lwd = 2); points(12.5, 50, pch = 16)
legend("bottomright", legend = c("x_+* stable", "x_-* unstable"), col = gruen, lty = 1:2, lwd = c(3, 2))
for (qq in c(8, 12.5)) {
  ww <- sqrt(1 - 4 * qq / (r * K))
  cat(sprintf("q = %g: x_- = %.2f,  x_+ = %.2f\n", qq, K / 2 * (1 - ww), K / 2 * (1 + ww)))
}
cat(sprintf("largest catch quota (MSY): q = rK/4 = %g\n", r * K / 4))
