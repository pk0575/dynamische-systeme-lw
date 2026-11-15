# Abb. 1.8: Treppendiagramm des Heron-Verfahrens (Buch, Abschnitt 1.1, Gl. 1.4)
# x_{n+1} = (x_n + 2/x_n)/2 mit x_0 = 0.5; die Treppe läuft in den Schnittpunkt mit y = x bei sqrt(2)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
f <- function(x) 0.5 * (x + 2 / x)
x0 <- 0.5; N <- 4

x <- numeric(N + 1)
x[1] <- x0                               # R zählt ab 1: x[1] ist x_0
for (k in 1:N) x[k + 1] <- f(x[k])
for (k in 1:(N + 1)) cat(sprintf("x_%d = %.6f\n", k - 1, x[k]))
cat(sprintf("sqrt(2) = %.6f\n", sqrt(2)))

rot <- rgb(0.64, 0.08, 0.18); blau <- rgb(0, 0.447, 0.741)
xx <- seq(0.3, 3, length.out = 400)
par(mfrow = c(1, 2))
for (s in c(1, N)) {
  plot(xx, f(xx), type = "l", col = blau, lwd = 2, xlim = c(0, 3), ylim = c(0, 3),
       xlab = "x", ylab = "f(x)", main = sprintf("%d Schritt(e)", s))
  abline(0, 1)
  px <- x[1]; py <- 0                    # Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
  for (k in 1:s) { px <- c(px, x[k], x[k + 1]); py <- c(py, x[k + 1], x[k + 1]) }
  px <- c(px, x[s + 1]); py <- c(py, 0)  # Wert zurück auf die x-Achse
  lines(px, py, col = rot)
}
