# Fig. 1.15: Newton's law of cooling (book, Section 1.2, Eq. 1.21)
# T_{n+1} = T_n + alpha (T^u - T_n) with T_0 = 35 and T^u = 23
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
T0 <- 35; Tu <- 23; N <- 20
n <- 0:N
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15, 18)
alphas <- c(0.1, 0.2, 0.5, 1.9, 2.0, 2.1)
par(mfrow = c(2, 2))
for (i in 1:6) {
  alpha <- alphas[i]
  T <- numeric(N + 1)
  T[1] <- T0
  for (k in 1:N) T[k + 1] <- T[k] + alpha * (Tu - T[k])
  if (i <= 3) {                          # 0 < alpha < 1: monotone approach to T^u, all in one plot
    if (i == 1) { plot(NULL, xlim = c(0, N), ylim = c(22, 36), xlab = "n", ylab = "T_n"); abline(h = Tu) }
    lines(n, T, type = "o", lty = 2, pch = zeichen[i], col = rot[i])
    if (i == 3) legend("topright", legend = sprintf("alpha = %g", alphas[1:3]), col = rot, pch = zeichen, lty = 2)
  } else {                               # 1 < alpha: oscillations
    plot(n, T, type = "o", lty = 2, pch = 16, col = rot[2], xlab = "n", ylab = "T_n", main = sprintf("alpha = %g", alpha))
    abline(h = Tu)
    cat(sprintf("alpha = %g:  T_19 = %.3f,  T_20 = %.3f\n", alpha, T[20], T[21]))
  }
}
