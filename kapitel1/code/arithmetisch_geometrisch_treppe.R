# Abb. 1.12: Aktualisierungsfunktionen und Treppendiagramme (Buch, Abschnitt 1.2)
# links: arithmetische Folge f(x) = x + 2 mit x_0 = 20;  rechts: geometrische Folge f(x) = a x mit a = 1.2 und 0.5, x_0 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
blau <- rgb(0, 0.447, 0.741); hellblau <- rgb(0.45, 0.70, 0.90)
rot <- rgb(0.64, 0.08, 0.18); hellrot <- rgb(0.89, 0.44, 0.49)
treppe <- function(x) {                  # Punkte der Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
  px <- x[1]; py <- 0
  for (k in 1:(length(x) - 1)) { px <- c(px, x[k], x[k + 1]); py <- c(py, x[k + 1], x[k + 1]) }
  list(px = px, py = py)
}
par(mfrow = c(1, 2))

plot(c(18, 33), c(20, 35), type = "l", col = blau, lwd = 2, xlim = c(18, 33), ylim = c(18, 33), xlab = "x", ylab = "f(x)")
abline(0, 1)
x <- numeric(7); x[1] <- 20
for (k in 1:6) x[k + 1] <- x[k] + 2
t <- treppe(x); lines(t$px, t$py, lty = 2, col = rot)
cat("arithmetisch:", sprintf("%g", x), "\n")
legend("bottomright", legend = c("f(x) = x + 2", "y = x"), col = c(blau, "black"), lwd = c(2, 1))

plot(NULL, xlim = c(0, 2.6), ylim = c(0, 2.6), xlab = "x", ylab = "f(x)")
abline(0, 1)
as <- c(1.2, 0.5); schritte <- c(5, 4); farbeF <- c(blau, hellblau); farbeT <- c(rot, hellrot)
for (i in 1:2) {
  a <- as[i]; N <- schritte[i]
  lines(c(0, 2.6), c(0, a * 2.6), col = farbeF[i], lwd = 2)
  x <- numeric(N + 1); x[1] <- 1
  for (k in 1:N) x[k + 1] <- a * x[k]
  t <- treppe(x); lines(t$px, t$py, lty = 2, col = farbeT[i])
  cat(sprintf("geometrisch a = %g:", a), sprintf("%.4f", x), "\n")
}
