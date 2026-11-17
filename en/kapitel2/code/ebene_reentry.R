# Fig. 2.24: Spiral wave after a brief block (book, Section 2.5, Eq. 2.35)
# as Fig. 2.23, but in steps 50 to 52 the coupling d is zero in the region [28, 30] x [1, 50]: the wave breaks and rotates
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a <- 0.89; b <- 0.6; c <- 0.28; k <- 0.02; d <- 0.4
f1 <- function(y1, y2) y1^2 * exp(y2 - y1) + k
y1r <- 0.2; y2r <- c / (1 - a)
for (j in 1:180) { y1neu <- f1(y1r, y2r); y2r <- a * y2r - b * y1r + c; y1r <- y1neu }   # resting state of a single cell

ebene <- function(blockade, schritte, Z = 100) {
  # Z x Z cells, no-flux boundary; left edge (i = 1) starts excited. List of the states y1 for n = 0, 1, 2, ...
  Y1 <- matrix(y1r, Z, Z); Y2 <- matrix(y2r, Z, Z); Y1[1, ] <- 0.3
  vor <- c(2:Z, Z); zur <- c(1, 1:(Z - 1))   # neighbor indices, at the boundary the cell itself
  zustaende <- list(Y1)
  for (n in 1:schritte) {
    D <- matrix(d, Z, Z)
    if (blockade && n >= 50 && n <= 52) D[28:30, 1:50] <- 0   # block in the region [28, 30] x [1, 50]
    F <- f1(Y1, Y2)
    Y1neu <- (1 - D) * F + D / 4 * (F[vor, ] + F[zur, ] + F[, vor] + F[, zur])
    Y2 <- a * Y2 - b * Y1 + c
    Y1 <- Y1neu
    zustaende[[n + 1]] <- Y1
  }
  zustaende
}
weissrot <- colorRampPalette(c("white", rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18), rgb(0.43, 0.04, 0.12)))(64)

Y <- ebene(TRUE, 301)
par(mfrow = c(3, 3), mar = c(2, 2, 2, 1))
for (n in seq(54, 214, 20)) image(1:100, 1:100, Y[[n + 1]], col = weissrot, zlim = c(0, 4), main = sprintf("n = %d", n), asp = 1)
erregt <- sapply(c(100, 200, 300), function(n) sum(Y[[n + 1]] > 1))
cat(sprintf("number of excited cells at n = 100, 200, 300: [%s]  -> the excitation does not stop\n", paste(erregt, collapse = ", ")))
