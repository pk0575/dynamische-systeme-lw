# Abb. 1.3: Malaria-Parasiten nach n Tagen (Buch, Abschnitt 1.1, Gl. 1.2 und 1.3)
# Rekursionsvorschrift x_{n+1} = 8 x_n, x_0 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N <- 4                             # Anzahl der Tage
x <- numeric(N + 1)
x[1] <- 1                          # Startwert x_0 = 1 (R zählt ab 1: x[1] ist x_0)
for (k in 1:N) {
  x[k + 1] <- 8 * x[k]             # Rekursionsvorschrift
}

n <- 0:N
cat(x, "\n")                         # 1 8 64 512 4096
cat(8^n * x[1], "\n")                # Lösungsformel x_n = 8^n x_0 liefert dasselbe

rot <- rgb(0.64, 0.08, 0.18)
plot(n, x, type = "o", lty = 2, pch = 16, col = rot, xaxt = "n", ylim = c(0, 4500),
     xlab = "n (Tage)", ylab = "Anzahl Parasiten x_n")
axis(1, at = n)
text(n, x + 250, x, col = rot, cex = 0.8)
