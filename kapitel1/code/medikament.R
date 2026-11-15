# Abb. 1.16: Medikamentenspiegel mit täglicher Dosis (Buch, Abschnitt 1.2, Gl. 1.23)
# x_{n+1} = a x_n + b_n, b_n = d falls n durch 24 teilbar, sonst 0;  a = 0.99, d = 0.4, x_0 = 0, n in Stunden
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a <- 0.99; d <- 0.4; x0 <- 0
N <- 504                                 # 21 Tage
x <- numeric(N + 1)
x[1] <- x0                               # x[1] ist x_0
for (k in 1:N) {
  n <- k - 1                             # Zeitschritt n
  b <- if (n %% 24 == 0) d else 0        # alle 24 Stunden eine Dosis
  x[k + 1] <- a * x[k] + b
}

xmax <- d / (1 - a^24)                   # Grenzwert der Spitzenwerte
cat(sprintf("x_max = %.4f\n", xmax))
cat(sprintf("Spitzenwert nach 20 Tagen: x_481 = %.4f\n", x[482]))

rot <- rgb(0.64, 0.08, 0.18)
par(mfrow = c(2, 1))
for (ende in c(73, N + 1)) {
  plot(0:(ende - 1), x[1:ende], type = "o", lty = 2, pch = 16, cex = 0.4, col = rot, xlab = "n (Stunden)", ylab = "x_n")
  abline(h = xmax)
}
