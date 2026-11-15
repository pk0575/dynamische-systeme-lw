# Abb. 1.31: Treppendiagramme des logistischen Modells über 500 Schritte (Buch, Abschnitt 1.4)
# Startwert 0.05; a = 2 (Fixpunkt), 3.3 (2-Zyklus), 3.55 (8-Zyklus), 4 (aperiodisch)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N <- 500
xx <- seq(0, 1, length.out = 400)
par(mfrow = c(2, 2))
for (a in c(2, 3.3, 3.55, 4)) {
  f <- function(y) a * y * (1 - y)
  y <- numeric(N + 1); y[1] <- 0.05
  for (k in 1:N) y[k + 1] <- f(y[k])
  px <- c(y[1], rep(y[1:N], each = 2)); py <- c(0, rep(y[2:(N + 1)], each = 2))   # Treppe
  px[seq(3, 2 * N + 1, 2)] <- y[2:(N + 1)]
  plot(xx, f(xx), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(0, 1), ylim = c(0, 1),
       xlab = "x_n", ylab = "f(x_n)", main = sprintf("a = %g", a))
  abline(0, 1)
  lines(px, py, col = rgb(0.64, 0.08, 0.18), lwd = if (a < 4) 1.5 else 0.3)
  werte <- sort(unique(round(y[(N - 14):(N + 1)] * 1e4) / 1e4))   # Langzeitverhalten: verschiedene Werte am Ende
  if (length(werte) <= 8) {
    cat(sprintf("a = %g:  %d verschiedene Werte am Ende:", a, length(werte)), sprintf("%.4f", werte), "\n")
  } else {
    cat(sprintf("a = %g:  %d verschiedene Werte am Ende: aperiodisch\n", a, length(werte)))
  }
}
