# Abb. 1.30: Iterierte f^2 und f^3 des logistischen Modells (Buch, Abschnitt 1.4, Gl. 1.38)
# links: f^2 mit a = 3.1 (stabiler 2-Zyklus);  rechts: f^3 mit a = 3.835 (stabiler 3-Zyklus)
# Fixpunkte von f^k: schwarz gefüllt = stabil (|(f^k)'| < 1), weiß = instabil
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
x <- seq(0, 1, length.out = 2000)
par(mfrow = c(1, 2))
for (p in 1:2) {
  a <- c(3.1, 3.835)[p]; k <- c(2, 3)[p]
  f <- function(y) a * y * (1 - y)
  fk <- if (k == 2) function(y) f(f(y)) else function(y) f(f(f(y)))   # f^2 bzw. f^3
  plot(x, fk(x), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, asp = 1, xlim = c(0, 1), ylim = c(0, 1),
       xlab = "x", ylab = sprintf("f^%d(x)", k), main = sprintf("a = %g", a))
  abline(0, 1)
  # Fixpunkte: Vorzeichenwechsel von f^k(x) - x suchen, dann mit uniroot genau bestimmen
  xg <- seq(0, 1, length.out = 20001); g <- fk(xg) - xg
  idx <- which(sign(g[-length(g)]) != sign(g[-1]))
  pts <- 0
  for (i in idx) pts <- c(pts, uniroot(function(z) fk(z) - z, c(xg[i], xg[i + 1]), tol = 1e-12)$root)
  pts <- unique(round(pts * 1e10) / 1e10)
  for (q in pts) {
    e <- 1e-7; ableitung <- (fk(q + e) - fk(q - e)) / (2 * e)
    stabil <- abs(ableitung) < 1
    points(q, q, pch = 21, bg = if (stabil) "black" else "white")
    cat(sprintf("a = %g, f^%d:  x = %.4f  %s  (Ableitung %.3f)\n", a, k, q, if (stabil) "stabil" else "instabil", ableitung))
  }
}
