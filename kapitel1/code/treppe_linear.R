# Abb. 1.25: Treppendiagramm zu x_{n+1} = x_n + 0.5 (Buch, Abschnitt 1.4)
# x_0 = 0.25; links ein Schritt, rechts vier Schritte. Der Graph von f schneidet y = x nicht: kein stationärer Zustand.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
f <- function(x) x + 0.5
x <- numeric(5); x[1] <- 0.25
for (k in 1:4) x[k + 1] <- f(x[k])
cat("x_0 ... x_4 =", sprintf("%g", x), "\n")

treppe <- function(x, unten = 0) {      # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
  px <- x[1]; py <- unten
  for (k in 1:(length(x) - 1)) { px <- c(px, x[k], x[k + 1]); py <- c(py, x[k + 1], x[k + 1]) }
  list(x = px, y = py)
}
rot <- rgb(0.64, 0.08, 0.18)
par(mfrow = c(1, 2))
for (s in c(1, 4)) {
  plot(c(0, 3), c(f(0), f(3)), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(0, 3), ylim = c(0, 3),
       xlab = "x", ylab = "f(x)")
  abline(0, 1)
  lines(treppe(x[1:(s + 1)]), col = rot)
  points(x[1:s], x[2:(s + 1)], pch = 16, col = rot)       # Punkte (x_n, x_{n+1})
}
