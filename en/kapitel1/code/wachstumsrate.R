# Fig. 1.17: Geometric growth with growth rate r (book, Section 1.3, Eq. 1.24)
# x_{n+1} = (1 + r) x_n with x_0 = 100; left x_n, right ln(x_n)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
x0 <- 100; N <- 30
n <- 0:N
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15, 18)
rs <- c(1, 0.1, -0.5)
par(mfrow = c(1, 2))
plot(NULL, xlim = c(0, 4), ylim = c(0, 1700), xlab = "n", ylab = "x_n")
for (i in 1:3) {
  x <- x0 * (1 + rs[i])^n
  lines(n[1:5], x[1:5], type = "o", lty = 2, pch = zeichen[i], col = rot[i])
}
legend("topleft", legend = sprintf("r = %g", rs), col = rot, pch = zeichen, lty = 2)
plot(NULL, xlim = c(0, N), ylim = c(-16, 26), xlab = "n", ylab = "ln(x_n)")
for (i in 1:3) {
  r <- rs[i]
  x <- x0 * (1 + r)^n
  lines(n, log(x), type = "o", lty = 2, pch = zeichen[i], col = rot[i])
  cat(sprintf("r = %g:  slope of ln(x_n) = ln(1 + r) = %.4f\n", r, log(1 + r)))
}
