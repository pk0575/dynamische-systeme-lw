# Fig. 4.3: Direction field of the predator-prey model (book, Section 4.1, Eq. 4.2)
# arrows in the direction (dx/dt, dy/dt), all of equal length; plus the solution from Fig. 4.2 and the steady states
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
r = 1; K = 10; c = 0.5; d = 0.2; e = 1
f(t, z) = [r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2]]
function feldpfeile(f)                   # direction field: arrows of equal length in the plot
    X = Float64[]; Y = Float64[]; U = Float64[]; W = Float64[]
    for x in range(0.4, 10.6, length = 18), y in range(0.15, 2.85, length = 10)
        u, w = f(0, [x, y]); u /= 11; w /= 3; L = hypot(u, w)
        push!(X, x); push!(Y, y); push!(U, u / L * 0.3); push!(W, w / L * 0.3 * 3 / 11)
    end
    return X, Y, U, W
end

X, Y, U, W = feldpfeile(f)
p = quiver(X, Y, quiver = (U, W), color = GR, legend = false, xlims = (0, 11), ylims = (0, 3), xlabel = "Prey x", ylabel = "Predators y")
z = loese(f, [8, 0.5], range(0, 40, length = 2001))
plot!(p, z[1, :], z[2, :], color = R2, lw = 2)
scatter!(p, [0, 10], [0, 0], color = :white, msc = :black, ms = 7)    # unstable
scatter!(p, [5], [1], color = :black, ms = 7)                          # stable
for (xs, ys) in [(0, 0), (10, 0), (5, 1)]
    u, w = f(0, [xs, ys])
    @printf("(%2d, %d): dx/dt = %g, dy/dt = %g\n", xs, ys, u, w)
end
display(p)
