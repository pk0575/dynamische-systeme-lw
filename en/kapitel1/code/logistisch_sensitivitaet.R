# Fig. 1.24: Sensitivity to the initial value (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n) with y_0 = 0.05 and ~y_0 = 0.06 for a = 2, 3.1, 3.55, 4
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N <- 30
n <- 0:N
par(mfrow = c(2, 2))
for (a in c(2, 3.1, 3.55, 4)) {
  y <- numeric(N + 1); yt <- numeric(N + 1)
  y[1] <- 0.05; yt[1] <- 0.06
  for (k in 1:N) {
    y[k + 1] <- a * y[k] * (1 - y[k])
    yt[k + 1] <- a * yt[k] * (1 - yt[k])
  }
  plot(n, y, type = "o", lty = 2, pch = 16, col = rgb(0.43, 0.04, 0.12), ylim = c(0, 1), xlab = "n", ylab = "")
  lines(n, yt, type = "o", lty = 2, pch = 15, col = rgb(0.89, 0.44, 0.49))
  abline(h = 1 - 1/a)
  legend("bottomright", legend = c(sprintf("y_n, a = %g", a), sprintf("~y_n, a = %g", a)),
         col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), pch = c(16, 15), lty = 2, cex = 0.8)
  cat(sprintf("a = %g:  |y_30 - ~y_30| = %.4f\n", a, abs(y[N + 1] - yt[N + 1])))
}
