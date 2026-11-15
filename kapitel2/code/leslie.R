# Abb. 2.9: Leslie-Modell mit drei Altersklassen (Buch, Abschnitt 2.2, Gl. 2.11)
# x_{n+1} = L x_n mit Geburtenrate 9 der Klasse 3 und Überlebensraten 0.1 und 0.6, x_0 = (0, 0, 1000)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
L <- matrix(c(0,   0,   9,
              0.1, 0,   0,
              0,   0.6, 0), nrow = 3, byrow = TRUE)
N <- 20
X <- matrix(0, 3, N + 1)
X[, 1] <- c(0, 0, 1000)
for (k in 1:N) X[, k + 1] <- L %*% X[, k]
cat("Klasse 3 alle drei Schritte:", sprintf("%.1f", X[3, seq(1, N + 1, 3)]), "\n")
cat(sprintf("Faktor pro Periode: 9 * 0.1 * 0.6 = %g < 1, die Population stirbt aus\n", 9 * 0.1 * 0.6))

namen <- c("Klasse 1", "Klasse 2", "Klasse 3")
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18)); zeichen <- c(16, 15, 18)
par(mfrow = c(3, 1), mar = c(4, 4, 1, 1))
for (i in 1:3) {
  plot(0:N, X[i, ], type = "o", lty = 2, pch = zeichen[i], col = farben[i], xlab = if (i == 3) "n" else "", ylab = "")
    legend("bottomright", legend = namen[i], col = farben[i], pch = zeichen[i], lty = 2)
}
