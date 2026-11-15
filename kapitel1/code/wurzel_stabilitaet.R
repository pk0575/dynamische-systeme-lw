# Abb. 1.27: stationäre Zustände von x_{n+1} = sqrt(x_n) (Buch, Abschnitt 1.4, Gl. 1.31)
# links: Start bei 0.01 nahe dem instabilen Zustand 0;  rechts: Start bei 1.01 nahe dem stabilen Zustand 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
treppe <- function(x, unten = 0) {      # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
  px <- x[1]; py <- unten
  for (k in 1:(length(x) - 1)) { px <- c(px, x[k], x[k + 1]); py <- c(py, x[k + 1], x[k + 1]) }
  list(x = px, y = py)
}
N <- 4
par(mfrow = c(1, 2))
for (p in 1:2) {
  x0 <- c(0.01, 1.01)[p]; lo <- c(0, 0.99)[p]; hi <- c(1.5, 1.01)[p]
  x <- numeric(N + 1); x[1] <- x0
  for (k in 1:N) x[k + 1] <- sqrt(x[k])
  cat(sprintf("x_0 = %g:", x0), sprintf("%.5f", x), "\n")
  xx <- seq(lo, hi, length.out = 300)
  plot(xx, sqrt(xx), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(lo, hi), ylim = c(lo, hi),
       xlab = "x", ylab = "f(x)")
  abline(0, 1)
  lines(treppe(x, lo), col = rgb(0.64, 0.08, 0.18))
}
cat("f'(x) = 1/(2 sqrt(x)):  f'(1) = 0.5 < 1 (stabil), f'(x) -> unendlich für x -> 0 (instabil)\n")
