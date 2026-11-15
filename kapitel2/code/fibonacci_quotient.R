# Abb. 2.10: Quotient aufeinanderfolgender Fibonacci-Zahlen (Buch, Abschnitt 2.3, Gl. 2.15)
# System j_{n+1} = e_n, e_{n+1} = e_n + j_n; der Quotient e_{n+1}/e_n strebt gegen den dominanten Eigenwert (goldener Schnitt)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
A <- matrix(c(0, 1,
              1, 1), nrow = 2, byrow = TRUE)
x <- c(1, 0)                             # (j_0, e_0): ein junges Paar
e <- x[2]
for (k in 1:16) { x <- A %*% x; e <- c(e, x[2]) }
q <- e[3:length(e)] / e[2:(length(e) - 1)]
cat("Eigenwerte von A:", sprintf("%.6f", sort(eigen(A)$values)), "\n")
cat("e_{n+1}/e_n:", sprintf("%.6f", tail(q, 4)), " goldener Schnitt:", sprintf("%.6f", (1 + sqrt(5)) / 2), "\n")

plot(seq_along(q), q, type = "o", lty = 2, pch = 16, col = rgb(0.64, 0.08, 0.18), xlab = "n", ylab = "")
abline(h = (1 + sqrt(5)) / 2, lty = 2)
legend("topright", legend = c("e_{n+1}/e_n", "lambda_1 = 1.618"), col = c(rgb(0.64, 0.08, 0.18), "black"), lty = 2, pch = c(16, NA))
