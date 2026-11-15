# Abb. 1.36: Aktualisierungsfunktion des AV-Knoten-Modells (Buch, Abschnitt 1.6, Gl. 1.47)
# f(V) = c V falls c V > V_g, sonst c V + u;  V_g = 1, u = 1;  links c = 1/3, rechts zusätzlich c = 0.6
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
Vg <- 1; u <- 1
farben <- c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90))
par(mfrow = c(1, 2))
for (p in 1:2) {
  cs <- if (p == 1) 1/3 else c(1/3, 0.6)
  plot(NULL, xlim = c(0, 4), ylim = c(0, 2.7), xlab = "V", ylab = "f(V)")
  for (i in seq_along(cs)) {
    c <- cs[i]
    s <- Vg / c                          # Sprungstelle: c V = V_g
    a <- seq(0, min(s, 4), length.out = 200); b <- seq(s, 4, length.out = 200)
    lines(a, c * a + u, col = farben[i], lwd = 2)
    lines(b, c * b, col = farben[i], lwd = 2)
    points(s, c * s + u, pch = 16, col = farben[i])
    if (p == 2) cat(sprintf("c = %.3g: Sprungstelle bei V = V_g/c = %.3f\n", c, s))
  }
  legend("topleft", legend = sprintf("c = %.3g", cs), col = farben[seq_along(cs)], lwd = 2)
}
