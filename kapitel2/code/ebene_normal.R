# Abb. 2.23: Ausbreitung in der Ebene, reguläre Welle (Buch, Abschnitt 2.5, Gl. 2.35)
# 100 x 100 Zellen, Parameter wie beim Ring; der linke Rand wird angeregt, die Welle läuft nach rechts und verlässt das Gebiet
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a <- 0.89; b <- 0.6; c <- 0.28; k <- 0.02; d <- 0.4
f1 <- function(y1, y2) y1^2 * exp(y2 - y1) + k
y1r <- 0.2; y2r <- c / (1 - a)
for (j in 1:180) { y1neu <- f1(y1r, y2r); y2r <- a * y2r - b * y1r + c; y1r <- y1neu }   # Ruhezustand der einzelnen Zelle

ebene <- function(blockade, schritte, Z = 100) {
  # Z x Z Zellen, Rand ohne Fluss; linker Rand (i = 1) startet erregt. Liste der Zustände y1 für n = 0, 1, 2, ...
  Y1 <- matrix(y1r, Z, Z); Y2 <- matrix(y2r, Z, Z); Y1[1, ] <- 0.3
  vor <- c(2:Z, Z); zur <- c(1, 1:(Z - 1))   # Nachbarindizes, am Rand die Zelle selbst
  zustaende <- list(Y1)
  for (n in 1:schritte) {
    D <- matrix(d, Z, Z)
    if (blockade && n >= 50 && n <= 52) D[28:30, 1:50] <- 0   # Blockade im Gebiet [28, 30] x [1, 50]
    F <- f1(Y1, Y2)
    Y1neu <- (1 - D) * F + D / 4 * (F[vor, ] + F[zur, ] + F[, vor] + F[, zur])
    Y2 <- a * Y2 - b * Y1 + c
    Y1 <- Y1neu
    zustaende[[n + 1]] <- Y1
  }
  zustaende
}
weissrot <- colorRampPalette(c("white", rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18), rgb(0.43, 0.04, 0.12)))(64)

Y <- ebene(FALSE, 201)
par(mfrow = c(2, 3), mar = c(2, 2, 2, 1))
for (n in c(3, 36, 69, 102, 135, 168)) {
  image(1:100, 1:100, Y[[n + 1]], col = weissrot, zlim = c(0, 4), main = sprintf("n = %d", n), asp = 1)
  cat(sprintf("n = %3d: Wellenfront bei i = %d\n", n, which.max(apply(Y[[n + 1]], 1, max))))
}
