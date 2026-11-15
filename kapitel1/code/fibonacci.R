# Abb. 1.4: Fibonacci-Folge (Buch, Abschnitt 1.1, Gl. 1.5 und 1.6)
# x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N <- 10                            # Anzahl der Monate
x <- numeric(N + 1)
x[1] <- 1; x[2] <- 1               # zwei Startwerte x_0 und x_1 (R zählt ab 1)
for (k in 2:N) {
  x[k + 1] <- x[k] + x[k - 1]      # Rekursionsvorschrift
}

n <- 0:N
phi <- (1 + sqrt(5)) / 2; psi <- (1 - sqrt(5)) / 2
formel <- (phi^(n + 1) - psi^(n + 1)) / sqrt(5)   # Lösungsformel (Gl. 1.6)
cat(x, "\n")                         # 1 1 2 3 5 8 13 21 34 55 89
cat(round(formel), "\n")             # Lösungsformel liefert dieselben Zahlen

rot <- rgb(0.64, 0.08, 0.18)
plot(n, x, type = "o", lty = 2, pch = 16, col = rot, xaxt = "n", ylim = c(0, 95),
     xlab = "n (Monate)", ylab = "Hasenpaare x_n")
axis(1, at = n)
text(n, x + 4, x, col = rot, cex = 0.8)
