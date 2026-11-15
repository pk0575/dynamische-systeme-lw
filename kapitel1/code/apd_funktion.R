# Abb. 1.40: Aktualisierungsfunktion des APD-Modells (Buch, Abschnitt 1.6, Gl. 1.49 und 1.50)
# f(APD) = r(m PCL - APD) mit m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
DImin <- 5
r <- function(DI) 220 - 180 * exp(-DI / 60)
f <- function(APD, PCL) r(ceiling((APD + DImin) / PCL) * PCL - APD)   # ceiling: nach wie vielen Perioden der nächste Reiz wirkt

APD <- seq(0, 800, length.out = 4001)
farben <- c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90))
par(mfrow = c(1, 2))
for (p in 1:2) {
  PCLs <- if (p == 1) 400 else c(400, 220)
  plot(NULL, xlim = c(0, 800), ylim = c(40, 225), xlab = "APD (ms)", ylab = "f(APD)")
  for (i in seq_along(PCLs)) {
    y <- f(APD, PCLs[i])
    y[c(FALSE, abs(diff(y)) > 20)] <- NA   # Sprungstellen nicht verbinden
    lines(APD, y, col = farben[i], lwd = 2)
  }
  legend("bottomleft", legend = sprintf("PCL = %d ms", PCLs), col = farben[seq_along(PCLs)], lwd = 2)
}
cat("Sprungstellen bei APD = k PCL - DI_min, z. B. 395 und 795 ms für PCL = 400 ms\n")
