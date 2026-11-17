# Fig. 1.18: Rate function of the logistic growth model (book, Section 1.3, Eq. 1.26)
# R(x) = r (1 - x/K): a small stock grows almost at the rate r, at x = K growth comes to a halt
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

r = 1; K = 5
R(x) = r * (1 - x / K)
for x in (0, 1, 2.5, 5)
    @printf("R(%g) = %.2f\n", x, R(x))
end

x = range(0, K, length = 100)
display(plot(x, R.(x), color = RGB(0, 0.447, 0.741), lw = 2, legend = false, xlabel = "x", ylabel = "R(x)",
             xticks = ([0, K], ["0", "K"]), yticks = ([0, r], ["0", "r"])))
