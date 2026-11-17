# Fig. 1.32: Steady state of x_{n+1} = exp(-x_n) (book, Section 1.5)
# left: intersection of f(x) = exp(-x) with y = x;  right: equivalently the root of g(x) = exp(-x) - x
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
x <- 0.5
for (n in 1:100) x <- exp(-x)            # fixed-point iteration x_{n+1} = exp(-x_n)
cat(sprintf("fixed-point iteration after 100 steps: x = %.10f\n", x))
cat(sprintf("g(x) = exp(-x) - x = %.1e\n", exp(-x) - x))

blau <- rgb(0, 0.447, 0.741)
xx <- seq(0, 1, length.out = 200)
par(mfrow = c(1, 2))
plot(xx, exp(-xx), type = "l", col = blau, lwd = 2, xlab = "x", ylab = "")
abline(0, 1); points(x, x, pch = 16)
legend("topright", legend = c("f(x) = exp(-x)", "y = x"), col = c(blau, "black"), lwd = c(2, 1))
plot(xx, exp(-xx) - xx, type = "l", col = blau, lwd = 2, xlab = "x", ylab = "")
abline(h = 0); points(x, 0, pch = 16)
legend("topright", legend = "g(x) = exp(-x) - x", col = blau, lwd = 2)
