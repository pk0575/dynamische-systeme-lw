# Abb. 4.17: Nullklinen des Räuber-Beute-Modells (Buch, Abschnitt 4.4, Gl. 4.2)
# x-Nullklinen: x = 0 und y = (r/c)(1 - x/K);  y-Nullklinen: y = 0 und x = e/d;  dazu Richtungsfeld und Lösung
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")
r <- 1; K <- 10; c <- 0.5; d <- 0.2; e <- 1
f <- function(t, z) c(r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2])
loese <- function(f, z0, t) ode(z0, t, function(t, z, p) list(f(t, z)), NULL, method = "lsoda", rtol = 1e-10, atol = 1e-12)
feld <- function(f, xl, yl, nx, ny, laenge = 0.3) {   # Richtungsfeld: gleich lange Pfeile (bezogen auf die Achsenlängen)
  g <- expand.grid(x = seq(xl[1], xl[2], length.out = nx), y = seq(yl[1], yl[2], length.out = ny))
  w <- t(apply(g, 1, function(p) f(0, p))); sx <- diff(xl); sy <- diff(yl)
  u <- w[, 1] / sx; v <- w[, 2] / sy; L <- sqrt(u^2 + v^2) + 1e-12
  arrows(g$x, g$y, g$x + u / L * laenge * sx / 11, g$y + v / L * laenge * sy / 11, length = 0.04, col = rgb(0.2, 0.6, 0.25))
}

plot(NULL, xlim = c(0, 11), ylim = c(0, 3), xlab = "Beute x", ylab = "Räuber y")
feld(f, c(0.4, 10.6), c(0.15, 2.85), 18, 10)
xs <- seq(0, 10, length.out = 50)
lines(xs, r / c * (1 - xs / K), col = rgb(0, 0.447, 0.741), lwd = 3); lines(c(0, 0), c(0, 3), col = rgb(0, 0.447, 0.741), lwd = 3)
lines(c(e / d, e / d), c(0, 3), col = rgb(0.45, 0.70, 0.90), lwd = 3); lines(c(0, 11), c(0, 0), col = rgb(0.45, 0.70, 0.90), lwd = 3)
x <- loese(f, c(8, 0.5), seq(0, 40, length.out = 2001))
lines(x[, 2], x[, 3], col = rgb(0.64, 0.08, 0.18), lwd = 2)
# Jacobi-Matrix im Koexistenzzustand (5, 1) und ihre Eigenwerte
xs_ <- e / d; ys_ <- r / c * (1 - e / (d * K))
J <- matrix(c(r * (1 - 2 * xs_ / K) - c * ys_, -c * xs_, d * ys_, d * xs_ - e), 2, byrow = TRUE)
lam <- eigen(J)$values; lam <- lam[order(Im(lam), Re(lam))]
cat(sprintf("Koexistenz (%g, %g): Spur %g, det %g, Eigenwerte ", xs_, ys_, sum(diag(J)), det(J)),
    paste(sprintf("%.3f%+.3fi", Re(lam), Im(lam)), collapse = "  "), "\n", sep = "")
points(c(0, 10), c(0, 0), pch = 21, bg = "white", cex = 1.3, xpd = TRUE); points(5, 1, pch = 16, cex = 1.3)
legend("topright", legend = c("dx/dt = 0", "dy/dt = 0"), col = c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90)), lwd = 3)
