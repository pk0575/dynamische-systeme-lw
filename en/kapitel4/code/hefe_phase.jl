# Fig. 4.18: Competition model in the phase plane (book, Section 4.4, Eq. 4.4)
# nullclines y = (1 - x/K1)/g1 and y = K2 (1 - g2 x), steady states (filled: stable, open: unstable), and the solution from Fig. 4.5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
using LinearAlgebra
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

r1 = 0.0607; K1 = 5.8; g1 = 0.0757     # S. kephir
r2 = 0.2183; K2 = 13; g2 = 0.2423      # S. cerevisiae
f(t, z) = [r1 * (1 - z[1] / K1 - g1 * z[2]) * z[1], r2 * (1 - z[2] / K2 - g2 * z[1]) * z[2]]
xs = range(0, 6.5, length = 50)
p = plot(xs, (1 .- xs ./ K1) ./ g1, color = BL, lw = 3, label = "dx/dt = 0", xlims = (0, 6.5), ylims = (0, 15),
         xlabel = "S. kephir x", ylabel = "S. cerevisiae y")
plot!(p, xs, K2 .* (1 .- g2 .* xs), color = HB, lw = 3, label = "dy/dt = 0")
z = loese(f, [0.5, 0.5], range(0, 400, length = 4001))
plot!(p, z[1, :], z[2, :], color = R2, lw = 2, label = ""); scatter!(p, [0.5], [0.5], color = R2, label = "")
for (x, y) in [(0, 0), (0, K2), (K1, 0)]
    J = [r1 * (1 - 2x / K1 - g1 * y)  -r1 * g1 * x; -r2 * g2 * y  r2 * (1 - 2y / K2 - g2 * x)]
    lam = sort(real.(eigvals(J))); stabil = maximum(lam) < 0
    scatter!(p, [x], [y], color = stabil ? :black : :white, msc = :black, ms = 8, label = "")
    @printf("(%g, %g): eigenvalues %s -> %s\n", x, y, join([@sprintf("%.4f", l) for l in lam], "  "), stabil ? "stable" : "unstable")
end
display(p)
