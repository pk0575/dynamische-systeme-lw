# Fig. 2.21: Second stimulation of cell 36 in the ring model (book, Section 2.5, Eq. 2.34)
# scenario a) n* = 37: signal dies out;  b) n* = 45: spreads in both directions;  c) n* = 41: circulates permanently
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a <- 0.89; b <- 0.6; c <- 0.28; k <- 0.02; d <- 0.4
f1 <- function(y1, y2) y1^2 * exp(y2 - y1) + k

# resting state: compute a single cell for 180 steps starting from (0.2, c/(1 - a))
y1r <- 0.2; y2r <- c / (1 - a)
for (j in 1:180) { y1neu <- f1(y1r, y2r); y2r <- a * y2r - b * y1r + c; y1r <- y1neu }

ring <- function(n_stoer = -1, Z = 50, schritte = 201) {
  # ring of Z cells; cell 1 starts excited (0.3), optionally a second stimulation of cell 36 after n_stoer steps
  Y1 <- matrix(y1r, schritte + 1, Z); Y2 <- matrix(y2r, schritte + 1, Z)   # row n+1 = time step n
  Y1[1, 1] <- 0.3
  rechts <- c(2:Z, 1); links <- c(Z, 1:(Z - 1))                          # neighbors on the ring
  for (n in 0:(schritte - 1)) {
    F <- f1(Y1[n + 1, ], Y2[n + 1, ])
    Y1[n + 2, ] <- (1 - d) * F + d / 2 * (F[rechts] + F[links])
    Y2[n + 2, ] <- a * Y2[n + 1, ] - b * Y1[n + 1, ] + c
    if (n + 1 == n_stoer) Y1[n + 2, 36] <- 0.3                         # second stimulation of cell 36
  }
  Y1
}
stamm <- function(werte, titel) {        # bars above the cells of the ring (3D view)
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
  cat(sprintf("Scenario %s) n* = %d: excited cells after 200 steps: [%s]\n", sz[[1]], sz[[2]], paste(which(Y1[201, ] > 1), collapse = ", ")))
  for (n in sz[[3]]) stamm(Y1[n + 1, ], sprintf("%s) n = %d", sz[[1]], n))
}
