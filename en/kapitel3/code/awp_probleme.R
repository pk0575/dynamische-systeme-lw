# Fig. 3.6: Initial value problems without a unique or without a global solution (book, Section 3.1)
# left dx/dt = t/x, x(0) = 0: x(t) = t and x(t) = -t both solve it;  right dx/dt = x^2, x(0) = 1: x(t) = 1/(1 - t) only for t < 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
par(mfrow = c(1, 2))
t <- seq(0, 2, length.out = 100)
plot(t, t, type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(-2, 2), xlab = "t", ylab = "", main = "dx/dt = t/x, x(0) = 0")
lines(t, -t, lty = 2, col = rgb(0.89, 0.44, 0.49), lwd = 2); points(0, 0, pch = 16)
legend("topleft", legend = c("x_1(t) = t", "x_2(t) = -t"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lty = c(1, 2), lwd = 2)
t <- seq(0, 0.95, length.out = 200)
plot(t, 1 / (1 - t), type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, xlim = c(0, 1.2), ylim = c(0, 20), xlab = "t", ylab = "",
     main = "dx/dt = x^2, x(0) = 1")
abline(v = 1, lty = 2); points(0, 1, pch = 16)
for (tt in c(0.5, 0.9, 0.99)) cat(sprintf("x(%g) = 1/(1 - %g) = %.0f\n", tt, tt, 1 / (1 - tt)))
