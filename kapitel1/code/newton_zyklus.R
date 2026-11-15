# Abb. 1.34: Newton-Verfahren ohne Konvergenz (Buch, Abschnitt 1.5, Gl. 1.44)
# g(x) = x^3 - 2x + 2 mit x_0 = 0: die Näherungen springen zwischen 0 und 1, die Nullstelle bei -1.769 wird nicht gefunden
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
g <- function(x) x^3 - 2 * x + 2
dg <- function(x) 3 * x^2 - 2

x <- numeric(7)
for (k in 1:6) x[k + 1] <- x[k] - g(x[k]) / dg(x[k])
cat("x_0 ... x_6 =", sprintf("%g", x), "\n")

xs <- -1                                 # mit einem besseren Startwert klappt es
for (k in 1:8) xs <- xs - g(xs) / dg(xs)
cat(sprintf("Start bei -1: Nullstelle x* = %.6f\n", xs))

xx <- seq(-2.2, 1.8, length.out = 400)
plot(xx, g(xx), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, ylim = c(-2.2, 4.5), xlab = "x", ylab = "")
abline(h = 0)
zz <- seq(-0.6, 1.6, length.out = 10)
for (a in c(0, 1)) lines(zz, g(a) + dg(a) * (zz - a))   # die beiden Tangenten
points(c(0, 1), c(0, 0), pch = 16, col = rgb(0.64, 0.08, 0.18))
points(xs, 0, pch = 16)
