# Fig. 3.14: Phase line of the logistic model (book, Section 3.3, Eq. 3.22)
# f(x) = r (1 - x/K) x with r = 0.55, K = 210; where f > 0, x grows (arrow to the right), where f < 0, x decreases
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r <- 0.55; K <- 210
f <- function(x) r * (1 - x / K) * x
df <- function(x) r * (1 - 2 * x / K)    # derivative f'(x)
x <- seq(-30, 280, length.out = 400)
plot(x, f(x), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, xlab = "x", ylab = "")
abline(h = 0)
arrows(c(20, 275, -8), 0, c(185, 225, -28), 0, col = rgb(0.64, 0.08, 0.18), lwd = 2.5, length = 0.12)   # phase line
points(0, 0, pch = 21, bg = "white", cex = 1.5); points(K, 0, pch = 16, cex = 1.5)
for (xs in c(0, K)) cat(sprintf("x* = %3d: f'(x*) = %5.2f -> %s\n", xs, df(xs), if (df(xs) < 0) "stable" else "unstable"))
legend("topright", legend = "f(x) = r (1 - x/K) x", col = rgb(0, 0.447, 0.741), lwd = 2.5)
