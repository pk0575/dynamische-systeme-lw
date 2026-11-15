# Abb. 3.14: Phasenlinie des logistischen Modells (Buch, Abschnitt 3.3, Gl. 3.22)
# f(x) = r (1 - x/K) x mit r = 0.55, K = 210; wo f > 0 ist, wächst x (Pfeil nach rechts), wo f < 0 ist, fällt x
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r <- 0.55; K <- 210
f <- function(x) r * (1 - x / K) * x
df <- function(x) r * (1 - 2 * x / K)    # Ableitung f'(x)
x <- seq(-30, 280, length.out = 400)
plot(x, f(x), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, xlab = "x", ylab = "")
abline(h = 0)
arrows(c(20, 275, -8), 0, c(185, 225, -28), 0, col = rgb(0.64, 0.08, 0.18), lwd = 2.5, length = 0.12)   # Phasenlinie
points(0, 0, pch = 21, bg = "white", cex = 1.5); points(K, 0, pch = 16, cex = 1.5)
for (xs in c(0, K)) cat(sprintf("x* = %3d: f'(x*) = %5.2f -> %s\n", xs, df(xs), if (df(xs) < 0) "stabil" else "instabil"))
legend("topright", legend = "f(x) = r (1 - x/K) x", col = rgb(0, 0.447, 0.741), lwd = 2.5)
