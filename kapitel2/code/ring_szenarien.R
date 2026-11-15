# Abb. 2.21: zweite Anregung der Zelle 36 im Ringmodell (Buch, Abschnitt 2.5, Gl. 2.34)
# Szenario a) n* = 37: Signal erlischt;  b) n* = 45: breitet sich in beide Richtungen aus;  c) n* = 41: kreist dauerhaft
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a <- 0.89; b <- 0.6; c <- 0.28; k <- 0.02; d <- 0.4
f1 <- function(y1, y2) y1^2 * exp(y2 - y1) + k

# Ruhezustand: einzelne Zelle 180 Schritte lang ab (0.2, c/(1 - a)) rechnen
y1r <- 0.2; y2r <- c / (1 - a)
for (j in 1:180) { y1neu <- f1(y1r, y2r); y2r <- a * y2r - b * y1r + c; y1r <- y1neu }

ring <- function(n_stoer = -1, Z = 50, schritte = 201) {
  # Ring aus Z Zellen; Zelle 1 startet erregt (0.3), optional zweite Anregung der Zelle 36 nach n_stoer Schritten
  Y1 <- matrix(y1r, schritte + 1, Z); Y2 <- matrix(y2r, schritte + 1, Z)   # Zeile n+1 = Zeitschritt n
  Y1[1, 1] <- 0.3
  rechts <- c(2:Z, 1); links <- c(Z, 1:(Z - 1))                          # Nachbarn auf dem Ring
  for (n in 0:(schritte - 1)) {
    F <- f1(Y1[n + 1, ], Y2[n + 1, ])
    Y1[n + 2, ] <- (1 - d) * F + d / 2 * (F[rechts] + F[links])
    Y2[n + 2, ] <- a * Y2[n + 1, ] - b * Y1[n + 1, ] + c
    if (n + 1 == n_stoer) Y1[n + 2, 36] <- 0.3                         # zweite Anregung der Zelle 36
  }
  Y1
}
stamm <- function(werte, titel) {        # Säulen über den Zellen des Rings (räumliche Darstellung)
  w <- seq(0, 2 * pi, length.out = 51)[1:50]; cx <- cos(w); cy <- sin(w)
  pm <- persp(c(-1.1, 1.1), c(-1.1, 1.1), matrix(0, 2, 2), zlim = c(0, 4.5), theta = 20, phi = 25,
              border = NA, box = FALSE, main = titel)
  unten <- trans3d(cx, cy, 0, pm); oben <- trans3d(cx, cy, werte, pm)
  lines(trans3d(c(cx, cx[1]), c(cy, cy[1]), 0, pm), col = "grey70")
  segments(unten$x, unten$y, oben$x, oben$y, col = rgb(0.64, 0.08, 0.18))
  points(oben, pch = 16, cex = 0.6, col = rgb(0.64, 0.08, 0.18))
}

szenarien <- list(list("a", 37, c(37, 39, 41, 43)), list("b", 45, c(45, 52, 72, 81)), list("c", 41, c(41, 52, 75, 100)))
par(mfcol = c(4, 3), mar = c(0, 0, 2, 0))
for (sz in szenarien) {
  Y1 <- ring(sz[[2]])
  cat(sprintf("Szenario %s) n* = %d: erregte Zellen nach 200 Schritten: [%s]\n", sz[[1]], sz[[2]], paste(which(Y1[201, ] > 1), collapse = ", ")))
  for (n in sz[[3]]) stamm(Y1[n + 1, ], sprintf("%s) n = %d", sz[[1]], n))
}
