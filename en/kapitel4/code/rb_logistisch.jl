# Fig. 4.2: Continuous predator-prey model (book, Section 4.1, Eq. 4.2)
# dx/dt = r (1 - x/K) x - c x y,  dy/dt = d x y - e y  with r = 1, K = 10, c = 0.5, d = 0.2, e = 1, x(0) = 8, y(0) = 0.5
# left time courses, right the same solution in the phase plane
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
idx(t, tt) = findfirst(t .>= tt - 1e-9)    # first index with t >= tt
r = 1; K = 10; c = 0.5; d = 0.2; e = 1
f(t, z) = [r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2]]

t = range(0, 40, length = 2001)
z = loese(f, [8, 0.5], t); x = z[1, :]; y = z[2, :]
for tt in (10, 20, 40)
    i = idx(t, tt)
    @printf("t = %2d: x = %.3f,  y = %.3f\n", tt, x[i], y[i])
end
@printf("steady state (e/d, r/c (1 - e/(d K))) = (%g, %g)\n", e / d, r / c * (1 - e / (d * K)))
p1 = plot(t, x, color = R1, lw = 2, label = "Prey x(t)", xlabel = "t")
plot!(p1, t, y, color = R3, lw = 2, label = "Predators y(t)")
p2 = plot(x, y, color = R2, lw = 2, legend = false, xlabel = "Prey x", ylabel = "Predators y")
scatter!(p2, [8, 5], [0.5, 1], color = :black)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
