# Fig. 4.4: Classical Lotka-Volterra model (book, Section 4.1, Eq. 4.3)
# dx/dt = r x - c x y,  dy/dt = d x y - e y  with r = 1, c = 0.5, d = 0.2, e = 1
# left periodic time courses for x(0) = 3, y(0) = 2, right closed orbits for different initial values
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

r = 1; c = 0.5; d = 0.2; e = 1
f(t, z) = [r * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2]]
H(x, y) = d * x - e * log(x) + c * y - r * log(y)    # remains constant along every solution
t = range(0, 25, length = 2501)
z = loese(f, [3, 2], t)
p1 = plot(t, z[1, :], color = R1, lw = 2, label = "Prey", xlabel = "t")
plot!(p1, t, z[2, :], color = R3, lw = 2, label = "Predators")
p2 = plot(legend = false, xlabel = "Prey x", ylabel = "Predators y")
for (i, x0) in enumerate([4, 3, 1.5])
    z = loese(f, [x0, 2], range(0, 12, length = 1201))
    plot!(p2, z[1, :], z[2, :], color = [R1, R2, R3][i], lw = 2)
    @printf("x(0) = %g: H at the start %.6f, at the end %.6f\n", x0, H(x0, 2), H(z[1, end], z[2, end]))
end
scatter!(p2, [e / d], [r / c], color = :black)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
