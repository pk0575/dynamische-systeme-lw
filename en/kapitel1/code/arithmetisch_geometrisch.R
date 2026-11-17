# Fig. 1.11: Arithmetic and geometric sequences (book, Section 1.2, Eq. 1.11 and 1.13)
# top: x_{n+1} = x_n + b with x_0 = 20;  bottom: x_{n+1} = a x_n with x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49))   # shades of red for several sequences
zeichen <- c(16, 15, 18)
par(mfrow = c(2, 1))

n <- 0:10; bs <- c(2, 1, -1)
plot(NULL, xlim = c(0, 10), ylim = c(8, 42), xlab = "n", ylab = "x_n")
for (i in 1:3) {
  x <- 20 + bs[i] * n                    # solution formula (1.12)
  lines(n, x, type = "o", lty = 2, pch = zeichen[i], col = rot[i])
  cat(sprintf("b = %g:  x_10 = %g\n", bs[i], x[length(x)]))
}
legend("topleft", legend = sprintf("b = %g", bs), col = rot, pch = zeichen, lty = 2)

n <- 0:5; as <- c(1.2, 1.01, 0.5)
plot(NULL, xlim = c(0, 5), ylim = c(0, 2.6), xlab = "n", ylab = "x_n")
for (i in 1:3) {
  x <- as[i]^n                           # solution formula (1.14) with x_0 = 1
  lines(n, x, type = "o", lty = 2, pch = zeichen[i], col = rot[i])
  cat(sprintf("a = %g:  x_5 = %.4f\n", as[i], x[length(x)]))
}
legend("topleft", legend = sprintf("a = %g", as), col = rot, pch = zeichen, lty = 2)
