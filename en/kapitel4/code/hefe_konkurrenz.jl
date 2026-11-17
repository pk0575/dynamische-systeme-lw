# Fig. 4.5: Competition between two yeast species (book, Section 4.1, Eq. 4.4)
# dx/dt = r1 (1 - x/K1 - g1 y) x,  dy/dt = r2 (1 - y/K2 - g2 x) y  with the parameters after Gause, x(0) = y(0) = 0.5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
idx(t, tt) = findfirst(t .>= tt - 1e-9)    # first index with t >= tt

r1 = 0.0607; K1 = 5.8; g1 = 0.0757     # S. kephir
r2 = 0.2183; K2 = 13; g2 = 0.2423      # S. cerevisiae
f(t, z) = [r1 * (1 - z[1] / K1 - g1 * z[2]) * z[1], r2 * (1 - z[2] / K2 - g2 * z[1]) * z[2]]
t = range(0, 300, length = 3001)
z = loese(f, [0.5, 0.5], t); x = z[1, :]; y = z[2, :]
for tt in (50, 100, 300)
    i = idx(t, tt)
    @printf("t = %3d h: x = %.3f,  y = %.3f\n", tt, x[i], y[i])
end
@printf("y reaches its maximum %.3f at t = %.1f h\n", maximum(y), t[argmax(y)])
p = plot(t, x, color = R1, lw = 2, label = "S. kephir x(t)", xlabel = "t (hours)", ylabel = "Yeast volume")
plot!(p, t, y, color = R3, lw = 2, label = "S. cerevisiae y(t)")
display(p)
