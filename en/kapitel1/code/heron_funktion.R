# Fig. 1.7: Update function of Heron's method (book, Section 1.1, Eq. 1.4)
# f(x) = (x + 2/x)/2 and first step x_0 = 0.5 -> x_1 = f(x_0)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
f <- function(x) 0.5 * (x + 2 / x)
x0 <- 0.5
x1 <- f(x0)
cat(sprintf("x_0 = %g,  x_1 = f(x_0) = %g\n", x0, x1))   # x_1 = 2.25

rot <- rgb(0.64, 0.08, 0.18); blau <- rgb(0, 0.447, 0.741)
x <- seq(0.16, 4.3, length.out = 400)
plot(x, f(x), type = "l", col = blau, lwd = 2, xlim = c(0, 4.3), ylim = c(0, 6.5), xlab = "x", ylab = "f(x)")
lines(c(x0, x0, 0), c(0, x1, x1), lty = 2, col = rot)      # up to the curve, then to the y-axis
points(c(x0, 0), c(0, x1), pch = 16, col = rot)
legend("topright", legend = "f(x) = (x + 2/x)/2", col = blau, lwd = 2)
