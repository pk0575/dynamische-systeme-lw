# Fig. 2.11: Disease progression with steady state (book, Section 2.3, Eq. 2.8)
# The steady state x* = A x* is an eigenvector for the eigenvalue 1, scaled to 100000 persons
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
A <- matrix(c(0.997, 0.6, 0,
              0.003, 0,   0.35,
              0,     0.4, 0.65), nrow = 3, byrow = TRUE)
ev <- eigen(A)
cat("eigenvalues:", sprintf("%.4f", sort(Re(ev$values))), "\n")
i1 <- which.min(abs(ev$values - 1))
v <- Re(ev$vectors[, i1])                # eigenvector for the eigenvalue 1
xs <- v / sum(v) * 100000
cat(sprintf("steady state x* = (%.0f, %.0f, %.0f)\n", xs[1], xs[2], xs[3]))

N <- 30
X <- matrix(0, 3, N + 1); X[, 1] <- c(100000, 0, 0)
for (k in 1:N) X[, k + 1] <- A %*% X[, k]

namen <- c("g_n", "l_n", "k_n")
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18)); zeichen <- c(16, 15, 18)
par(mfrow = c(3, 1), mar = c(4, 4, 1, 1))
for (i in 1:3) {
  plot(0:N, X[i, ], type = "o", lty = 2, pch = zeichen[i], col = farben[i], xlab = if (i == 3) "n (years)" else "", ylab = "")
  abline(h = xs[i], lty = 2)
  legend("bottomright", legend = namen[i], col = farben[i], pch = zeichen[i], lty = 2)
}
