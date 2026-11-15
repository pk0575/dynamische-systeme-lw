# Abb. 1.38: Aktionspotentiale bei periodischer Anregung (Buch, Abschnitt 1.6)
# Mitchell-Schaeffer-Modell (zwei Ströme), Euler-Verfahren mit dt = 0.01 ms, Reiz alle PCL = 400 ms;
# gemessen wird die Zeit oberhalb des Referenzwerts 0.1 (Aktionspotentialdauer APD) und darunter (diastolisches Intervall DI)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # Zeitkonstanten in ms
PCL <- 400; T <- 2050; dt <- 0.01; vref <- 0.1

t <- (0:(round(T / dt) - 1)) * dt
v <- numeric(length(t))
vv <- 0; h <- 1
for (i in 2:length(t)) {
  J <- if (t[i] %% PCL < 2) 0.2 else 0  # Reiz: 2 ms lang
  dv <- h * vv^2 * (1 - vv) / tin - vv / tout + J
  dh <- if (vv < vgate) (1 - h) / topen else -h / tclose
  vv <- vv + dt * dv
  h <- h + dt * dh
  v[i] <- vv
}

s <- sign(v - vref)                      # Durchgänge durch den Referenzwert
kreuz <- t[which(diff(s) != 0)]
auf <- kreuz[seq(1, length(kreuz), 2)]; ab <- kreuz[seq(2, length(kreuz), 2)]
for (k in seq_along(ab)) {
  if (k < length(auf)) cat(sprintf("AP %d:  APD = %6.1f ms,  DI = %6.1f ms\n", k, ab[k] - auf[k], auf[k + 1] - ab[k]))
  else cat(sprintf("AP %d:  APD = %6.1f ms\n", k, ab[k] - auf[k]))
}

plot(t, v, type = "l", col = rgb(0.64, 0.08, 0.18), xlab = "t (ms)", ylab = "v (dimensionslos)")
abline(h = vref, lty = 3, col = "grey35")
