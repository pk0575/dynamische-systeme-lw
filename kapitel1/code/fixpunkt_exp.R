# Abb. 1.32: stationärer Zustand von x_{n+1} = exp(-x_n) (Buch, Abschnitt 1.5)
# links: Schnittpunkt von f(x) = exp(-x) mit y = x;  rechts: gleichwertig die Nullstelle von g(x) = exp(-x) - x
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
x <- 0.5
for (n in 1:100) x <- exp(-x)            # Fixpunktiteration x_{n+1} = exp(-x_n)
cat(sprintf("Fixpunktiteration nach 100 Schritten: x = %.10f\n", x))
cat(sprintf("g(x) = exp(-x) - x = %.1e\n", exp(-x) - x))

blau <- rgb(0, 0.447, 0.741)
xx <- seq(0, 1, length.out = 200)
par(mfrow = c(1, 2))
plot(xx, exp(-xx), type = "l", col = blau, lwd = 2, xlab = "x", ylab = "")
abline(0, 1); points(x, x, pch = 16)
legend("topright", legend = c("f(x) = exp(-x)", "y = x"), col = c(blau, "black"), lwd = c(2, 1))
plot(xx, exp(-xx) - xx, type = "l", col = blau, lwd = 2, xlab = "x", ylab = "")
abline(h = 0); points(x, 0, pch = 16)
legend("topright", legend = "g(x) = exp(-x) - x", col = blau, lwd = 2)
