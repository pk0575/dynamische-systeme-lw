# Abb. 2.7: Krankheitsverlauf als lineares System (Buch, Abschnitt 2.2, Gl. 2.8)
# x_{n+1} = A x_n mit x = (gesund, leicht erkrankt, schwer erkrankt), x_0 = (100000, 0, 0), ein Schritt = ein Jahr
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
A <- matrix(c(0.997, 0.6, 0,
              0.003, 0,   0.35,
              0,     0.4, 0.65), nrow = 3, byrow = TRUE)
N <- 20
X <- matrix(0, 3, N + 1)
X[, 1] <- c(100000, 0, 0)
for (k in 1:N) X[, k + 1] <- A %*% X[, k]   # Matrix mal Vektor
cat(sprintf("x_20 = (%.0f, %.0f, %.0f)\n", X[1, N + 1], X[2, N + 1], X[3, N + 1]))
cat(sprintf("Spaltensummen von A: %g %g %g -> die Gesamtzahl bleibt erhalten: %.0f\n", colSums(A)[1], colSums(A)[2], colSums(A)[3], sum(X[, N + 1])))

namen <- c("gesund g_n", "leicht erkrankt l_n", "schwer erkrankt k_n")
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18)); zeichen <- c(16, 15, 18)
par(mfrow = c(3, 1), mar = c(4, 4, 1, 1))
for (i in 1:3) {
  plot(0:N, X[i, ], type = "o", lty = 2, pch = zeichen[i], col = farben[i], xlab = if (i == 3) "n (Jahre)" else "", ylab = "")
    legend("bottomright", legend = namen[i], col = farben[i], pch = zeichen[i], lty = 2)
}
