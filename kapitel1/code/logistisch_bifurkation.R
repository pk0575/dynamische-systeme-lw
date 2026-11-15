# Abb. 1.23: Bifurkationsdiagramm des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.28)
# y_{n+1} = a y_n (1 - y_n): für jeden Wert von a wird nach n_* = 10000 Schritten das Langzeitverhalten gezeichnet
# oben: 2.8 <= a <= 4;  unten: Ausschnitt 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (das Muster kehrt wieder)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
gruen <- rgb(0, 0.39, 0)
bereiche <- list(seq(2.8, 4.0, length.out = 2401), seq(3.8538, 3.8541, length.out = 1501))
behalten <- c(200, 6000)
fenster <- rbind(c(0, 1), c(0.494, 0.506))
par(mfrow = c(2, 1))
for (p in 1:2) {
  a <- bereiche[[p]]
  y <- rep(0.9, length(a))               # alle Parameterwerte gleichzeitig (Vektor)
  for (k in 1:10000) y <- a * y * (1 - y)          # Einschwingen
  A <- c(); Y <- c()
  for (k in 1:behalten[p]) {             # Langzeitverhalten sammeln
    y <- a * y * (1 - y)
    m <- y > fenster[p, 1] & y < fenster[p, 2]
    A <- c(A, a[m]); Y <- c(Y, y[m])
  }
  plot(A, Y, pch = ".", col = gruen, xlab = "a", ylab = "y_n für n > 10000")
}

a <- 3.2; y <- 0.9                       # Beispiel a = 3.2: zwei Werte wechseln sich ab (2-Zyklus)
for (k in 1:10000) y <- a * y * (1 - y)
cat(sprintf("a = 3.2:  2-Zyklus %.4f <-> %.4f\n", y, a * y * (1 - y)))
