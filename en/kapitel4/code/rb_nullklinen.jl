# Fig. 4.17: Nullclines of the predator-prey model (book, Section 4.4, Eq. 4.2)
# x-nullclines: x = 0 and y = (r/c)(1 - x/K);  y-nullclines: y = 0 and x = e/d;  plus direction field and solution
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
using LinearAlgebra
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
p = quiver(X, Y, quiver = (U, W), color = GR, label = "", xlims = (0, 11), ylims = (0, 3), xlabel = "Prey x", ylabel = "Predators y",
           legend = :topright)
xs = range(0, 10, length = 50)
plot!(p, xs, r / c .* (1 .- xs ./ K), color = BL, lw = 3, label = "dx/dt = 0")
plot!(p, [0, 0], [0, 3], color = BL, lw = 3, label = "")
plot!(p, [e / d, e / d], [0, 3], color = HB, lw = 3, label = "dy/dt = 0")
plot!(p, [0, 11], [0, 0], color = HB, lw = 3, label = "")
z = loese(f, [8, 0.5], range(0, 40, length = 2001))
plot!(p, z[1, :], z[2, :], color = R2, lw = 2, label = "")
xs_ = e / d; ys_ = r / c * (1 - e / (d * K))
J = [r * (1 - 2xs_ / K) - c * ys_  -c * xs_; d * ys_  d * xs_ - e]
lam = sort(complex.(eigvals(J)), by = l -> (imag(l), real(l)))
@printf("coexistence (%g, %g): trace %g, det %g, eigenvalues ", xs_, ys_, tr(J), det(J))
println(join([@sprintf("%.3f%+.3fi", real(l), imag(l)) for l in lam], "  "))
scatter!(p, [0, 10], [0, 0], color = :white, msc = :black, ms = 7, label = ""); scatter!(p, [5], [1], color = :black, ms = 7, label = "")
display(p)
