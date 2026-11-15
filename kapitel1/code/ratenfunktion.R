# Abb. 1.18: Ratenfunktion des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.26)
# R(x) = r (1 - x/K): bei kleinem Bestand wächst er fast mit der Rate r, bei x = K kommt das Wachstum zum Erliegen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r <- 1; K <- 5
R <- function(x) r * (1 - x / K)
for (x in c(0, 1, 2.5, 5)) cat(sprintf("R(%g) = %.2f\n", x, R(x)))

x <- seq(0, K, length.out = 100)
plot(x, R(x), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, xaxt = "n", yaxt = "n", xlab = "x", ylab = "R(x)")
axis(1, at = c(0, K), labels = c("0", "K")); axis(2, at = c(0, r), labels = c("0", "r"))
