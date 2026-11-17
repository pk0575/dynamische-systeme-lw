# Fig. 4.21: Washout in the bioreactor (book, Section 4.4, Eq. 4.17)
# steady-state biomass b* = (n_in - D k50/(kmax - D))/nu as a function of D; above D_c = K(n_in) the biomass is washed out
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
D <- 0.2; nin <- 10; nu <- 2; kmax <- 1; k50 <- 0.5    # D in 1/h, concentrations in g/l
K <- function(n) kmax * n / (k50 + n)                  # Monod growth rate

Dc <- K(nin)
bst <- function(D) (nin - D * k50 / (kmax - D)) / nu
gruen <- rgb(0, 0.39, 0)
Dg <- seq(0.001, 1.2, length.out = 600)
D1 <- Dg[Dg <= Dc]; D2 <- Dg[Dg >= Dc & Dg <= 0.985]
plot(D1, bst(D1), type = "l", col = gruen, lwd = 3, xlim = c(0, 1.2), ylim = c(-1.5, 5.5), xlab = "Dilution rate D (per hour)", ylab = "b* (g/l)")
lines(D2, bst(D2), lty = 2, col = gruen, lwd = 2)
lines(c(0, Dc), c(0, 0), lty = 2, col = gruen, lwd = 2); lines(c(Dc, 1.2), c(0, 0), col = gruen, lwd = 3)
abline(v = Dc, lty = 3, col = "grey50"); points(D, bst(D), pch = 16)
cat(sprintf("D_c = K(n_in) = %.4f per hour\n", Dc))
for (DD in c(0.2, 0.5, 0.9)) cat(sprintf("D = %g: b* = %.4f g/l,  yield D b* = %.4f g/(l h)\n", DD, bst(DD), DD * bst(DD)))
legend("bottomleft", legend = c("stable", "unstable"), col = gruen, lty = 1:2, lwd = c(3, 2))
