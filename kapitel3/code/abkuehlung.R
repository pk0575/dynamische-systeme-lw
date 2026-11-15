# Abb. 3.4: Abkühlung eines Gerichts im Kühlschrank (Buch, Abschnitt 3.1, Gl. 3.3 und 3.12)
# dT/dt = k (T^u - T) mit k = 0.03 pro Minute, T^u = 5 °C, T(0) = 80 °C:  T(t) = 75 e^(-0.03 t) + 5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k <- 0.03; Tu <- 5; T0 <- 80
t <- seq(0, 180, length.out = 400)
T <- Tu + (T0 - Tu) * exp(-k * t)
ts <- log((T0 - Tu) / (10 - Tu)) / k     # Zeitpunkt, zu dem T = 10 °C erreicht ist
cat(sprintf("T = 10 °C nach t = ln(15)/k = %.1f min\n", ts))
plot(t, T, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2.5, xlab = "t (min)", ylab = "T (°C)")
abline(h = Tu, lty = 2)
lines(c(ts, ts), c(0, 10), lty = 3, col = "grey50"); points(ts, 10, pch = 16)
legend("topright", legend = "T(t)", col = rgb(0.64, 0.08, 0.18), lwd = 2.5)
