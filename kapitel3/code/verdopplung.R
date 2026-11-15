# Abb. 3.10: Wachstum von E. coli mit der Verdopplungszeit 20 Minuten (Buch, Abschnitt 3.2, Gl. 3.18)
# x(t) = 1000 · 2^(t/20) = 1000 e^(r t) mit r = ln(2)/20 pro Minute
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tV <- 20; x0 <- 1000
r <- log(2) / tV
t <- seq(0, 120, length.out = 300)
plot(t, x0 * exp(r * t), type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2.5, xaxt = "n", xlab = "t (min)", ylab = "Zellen")
axis(1, at = seq(0, 120, 20))
for (k in 1:6) { lines(c(tV * k, tV * k), c(0, x0 * 2^k), lty = 3, col = "grey50"); points(tV * k, x0 * 2^k, pch = 16) }
cat(sprintf("r = ln(2)/20 = %.5f pro Minute;  x(120) = %.0f Zellen\n", r, x0 * exp(r * 120)))
