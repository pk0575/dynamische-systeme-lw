# Abb. 4.23: Membranpotential im Noble-Modell (Buch, Abschnitt 4.4, Gl. 4.19)
# Cm dV/dt = -(400 m^3 h + 0.14)(V - 40) - (1.2 e^((-V-90)/50) + 0.015 e^((V+90)/60) + 1.2 n^4)(V + 100) - gL (V - VL) + I(t), Cm = 12
# links Schrittmacherzelle (gL = 0.075, VL = -60), rechts erregbare Zelle (gL = 0.3, VL = -85) mit Reizen alle 700 ms; Zeit in ms
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
library(deSolve)                         # Paket deSolve: install.packages("deSolve")

noble <- function(gL, VL, reiz) function(t, z, p) {
  V <- z[1]; m <- z[2]; h <- z[3]; n <- z[4]
  am <- 0.1 * (-V - 48) / (exp((-V - 48) / 15) - 1); bm <- 0.12 * (V + 8) / (exp((V + 8) / 5) - 1)
  ah <- 0.17 * exp((-V - 90) / 20); bh <- 1 / (1 + exp((-V - 42) / 10))
  an <- 0.0001 * (-V - 50) / (exp((-V - 50) / 10) - 1); bn <- 0.002 * exp((-V - 90) / 80)
  iNa <- (400 * m^3 * h + 0.14) * (V - 40)
  iK <- (1.2 * exp((-V - 90) / 50) + 0.015 * exp((V + 90) / 60) + 1.2 * n^4) * (V + 100)
  I <- if (reiz && t %% 700 < 2) 300 else 0   # Reiz: 2 ms lang alle 700 ms
  list(c((-(iNa + iK + gL * (V - VL)) + I) / 12, am * (1 - m) - bm * m, ah * (1 - h) - bh * h, an * (1 - n) - bn * n))
}
par(mfrow = c(1, 2))
for (fall in list(list("Schrittmacher", 0.075, -60, FALSE, 2000), list("gereizt", 0.3, -85, TRUE, 0))) {
  T0 <- fall[[5]]; T <- T0 + 2100
  x <- ode(c(-80, 0.02, 0.8, 0.05), seq(0, T, by = 0.1), noble(fall[[2]], fall[[3]], fall[[4]]), NULL,
           method = "lsoda", hmax = 0.25, rtol = 1e-8, atol = 1e-10)
  i <- x[, 1] >= T0; tt <- (x[i, 1] - T0) / 1000; V <- x[i, 2]
  hoch <- tt[which(V[-length(V)] < 0 & V[-1] >= 0) + 1]   # Zeitpunkte, an denen V von unten 0 mV erreicht
  txt <- sprintf("%s: V zwischen %.0f und %.0f mV, %d Aktionspotentiale in 2.1 s", fall[[1]], min(V), max(V), length(hoch))
  if (length(hoch) > 1) txt <- paste0(txt, sprintf(", Periode %.2f s", mean(diff(hoch))))
  cat(txt, "\n")
  plot(tt, V, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 2, ylim = c(-95, 50), xlab = "t (s)", ylab = "Membranpotential V (mV)", main = fall[[1]])
}
