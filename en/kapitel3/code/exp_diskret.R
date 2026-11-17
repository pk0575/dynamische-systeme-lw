# Fig. 3.9: Continuous and discrete exponential growth (book, Section 3.2, Eq. 3.17)
# x(t) = e^(0.5 t) and x_n = a^n with a = e^0.5: at the times t = n both agree
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
t <- seq(0, 6, length.out = 300); n <- 0:6
a <- exp(0.5)
plot(t, exp(0.5 * t), type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, xlab = "t or n", ylab = "x")
points(n, a^n, pch = 16, cex = 1.5, col = rgb(0.89, 0.44, 0.49))
cat(sprintf("a = e^0.5 = %.4f;  a^6 = %.4f,  e^3 = %.4f\n", a, a^6, exp(3)))
legend("topleft", legend = c("x(t) = e^(0.5t)", sprintf("x_n = a^n, a = %.4f", a)), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)),
       lwd = c(2, NA), pch = c(NA, 16))
