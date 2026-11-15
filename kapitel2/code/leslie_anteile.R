# Abb. 2.12: stabile Altersverteilung im Leslie-Modell (Buch, Abschnitt 2.3, Gl. 2.17)
# L mit b_2 = 5: die Anteile der Klassen nähern sich dem Eigenvektor v_1 zum dominanten Eigenwert lambda_1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
L <- matrix(c(0,   5,   9,
              0.1, 0,   0,
              0,   0.6, 0), nrow = 3, byrow = TRUE)
ev <- eigen(L)
i1 <- which.max(Mod(ev$values))
v1 <- Re(ev$vectors[, i1]); v1 <- v1 / sum(v1)
cat(sprintf("dominanter Eigenwert lambda_1 = %.4f\n", Re(ev$values[i1])))
cat(sprintf("stabile Altersverteilung v_1 = (%.3f, %.3f, %.3f)\n", v1[1], v1[2], v1[3]))

N <- 30
X <- matrix(0, 3, N + 1); X[, 1] <- c(0, 0, 1000)
for (k in 1:N) X[, k + 1] <- L %*% X[, k]
P <- sweep(X, 2, colSums(X), "/")        # Anteile der Klassen
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18)); zeichen <- c(16, 15, 18)
plot(NULL, xlim = c(0, N), ylim = c(0, 1), xlab = "n", ylab = "Anteil der Klasse")
for (i in 1:3) { lines(0:N, P[i, ], type = "o", pch = zeichen[i], col = farben[i]); abline(h = v1[i], lty = 2, col = farben[i]) }
legend("topright", legend = sprintf("Klasse %d", 1:3), col = farben, pch = zeichen, lty = 1)
