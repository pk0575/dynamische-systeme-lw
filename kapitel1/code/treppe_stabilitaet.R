# Abb. 1.28: Treppendiagramme mit stabilen und instabilen stationären Zuständen (Buch, Abschnitt 1.4, Gl. 1.34)
# oben: f(x) = x - 2x(0.5 - x)(1 - x) mit Fixpunkten 0 und 1 (stabil) sowie 0.5 (instabil)
# unten: f(x) = exp(-2x) (spiralförmige Annäherung) und f(x) = exp(-5x) (spiralförmige Entfernung), jeweils x_0 = 0.2
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
treppe <- function(x, unten = 0) {      # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
  px <- x[1]; py <- unten
  for (k in 1:(length(x) - 1)) { px <- c(px, x[k], x[k + 1]); py <- c(py, x[k + 1], x[k + 1]) }
  list(x = px, y = py)
}
g <- function(x) x - 2 * x * (0.5 - x) * (1 - x)
fs <- list(g, g, function(x) exp(-2 * x), function(x) exp(-5 * x))
namen <- c("f(x) = x - 2x(0.5-x)(1-x)", "f(x) = x - 2x(0.5-x)(1-x)", "f(x) = exp(-2x)", "f(x) = exp(-5x)")
starts <- list(0.6, c(0.4, 0.6), 0.2, 0.2)
schritte <- c(20, 20, 20, 7)
grenzen <- rbind(c(0.5, 1), c(0, 1), c(0, 1), c(0, 1))
par(mfrow = c(2, 2))
for (p in 1:4) {
  f <- fs[[p]]; N <- schritte[p]; lo <- grenzen[p, 1]; hi <- grenzen[p, 2]
  xx <- seq(lo, hi, length.out = 400)
  plot(xx, f(xx), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(lo, hi), ylim = c(lo, hi),
       xlab = "x_n", ylab = "f(x_n)", main = namen[p], cex.main = 0.9)
  abline(0, 1)
  for (x0 in starts[[p]]) {
    x <- numeric(N + 1); x[1] <- x0
    for (k in 1:N) x[k + 1] <- f(x[k])
    lines(treppe(x, lo), col = rgb(0.64, 0.08, 0.18))
    cat(sprintf("%s, x_0 = %g:  x_%d = %.4f\n", namen[p], x0, N, x[N + 1]))
  }
}

# Stabilitätskriterium |f'(x*)| < 1 an den Fixpunkten
for (c in c(2, 5)) {
  xs <- 0.5
  for (k in 1:100) xs <- xs - (exp(-c * xs) - xs) / (-c * exp(-c * xs) - 1)   # Fixpunkt mit dem Newton-Verfahren
  cat(sprintf("f(x) = exp(-%dx):  x* = %.4f,  f'(x*) = %.4f\n", c, xs, -c * exp(-c * xs)))
}
