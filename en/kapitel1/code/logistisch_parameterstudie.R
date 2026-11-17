# Fig. 1.22: Parameter study of the logistic growth model (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n) with y_0 = 0.008 and a = 0.75, 3.3, 3.55, 4
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
y0 <- 0.008; N <- 24
n <- 0:N
par(mfrow = c(2, 2))
for (a in c(0.75, 3.3, 3.55, 4)) {
  y <- numeric(N + 1)
  y[1] <- y0
  for (k in 1:N) y[k + 1] <- a * y[k] * (1 - y[k])
  plot(n, y, type = "o", lty = 2, pch = 16, col = rgb(0.64, 0.08, 0.18), xlab = "n", ylab = "y_n", main = sprintf("a = %g", a))
  if (a > 1) abline(h = 1 - 1/a, lty = 2)        # steady state 1 - 1/a
  cat(sprintf("a = %g:  y_21 ... y_24 =", a), sprintf("%.4g", y[22:25]), "\n")
}
