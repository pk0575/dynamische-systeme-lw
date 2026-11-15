# Abb. 3.22: Euler-Verfahren mit zu großer Schrittweite (Buch, Abschnitt 3.4, Gl. 3.27)
# T_{n+1} - 5 = (1 - k h)(T_n - 5): für h = 40 ist der Faktor -0.2 (gedämpfte Schwingung), für h = 70 ist er -1.1 (Aufschaukeln)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k <- 0.03; Tu <- 5; T0 <- 80
tt <- seq(0, 700, length.out = 400)
par(mfrow = c(1, 2))
for (h in c(40, 70)) {
  N <- ceiling(700 / h)
  t <- h * (0:N); T <- numeric(N + 1); T[1] <- T0
  for (n in 1:N) T[n + 1] <- T[n] + h * k * (Tu - T[n])
  plot(tt, Tu + (T0 - Tu) * exp(-k * tt), type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2,
       ylim = if (h == 70) c(-250, 250) else range(T), xlab = "t (min)", ylab = "", main = sprintf("h = %d: Faktor 1 - kh = %.1f", h, 1 - k * h))
  lines(t, T, type = "o", lty = 2, pch = 16, cex = 0.7, col = rgb(0.89, 0.44, 0.49))
  abline(h = Tu, lty = 3)
  cat(sprintf("h = %d: T_1 ... T_4 =", h), sprintf("%.2f", T[2:5]), "\n")
}
