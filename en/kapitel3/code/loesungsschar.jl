# Fig. 3.3: Family of solutions of a linear differential equation (book, Section 3.1, Eq. 3.6 and 3.7)
# dx/dt = a x + b with a = -0.5, b = 1; solutions x(t) = C e^(at) - b/a for different initial values, x* = -b/a = 2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

a = -0.5; b = 1
xs = -b / a                              # constant solution
t = range(0, 8, length = 400)
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]
p = plot(legend = false, xlabel = "t", ylabel = "x(t)", title = "black: x* = -b/a = 2")
for (i, x0) in enumerate([5, 3.5, 2.5, 1, 0])
    C = x0 - xs
    plot!(p, t, C .* exp.(a .* t) .+ xs, color = rot[(i - 1) % 3 + 1], lw = 2)
    @printf("x(0) = %g: C = %4.1f, x(8) = %.4f\n", x0, C, C * exp(8a) + xs)
end
hline!(p, [xs], color = :black, lw = 1.5)
display(p)
