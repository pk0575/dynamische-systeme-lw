# Fig. 4.20: Biomass and nutrient in the bioreactor (book, Section 4.4, Eq. 4.17)
# db/dt = K(n) b - D b,  dn/dt = -nu K(n) b - D n + D n_in  with K(n) = kmax n/(k50 + n), D = 0.2, n_in = 10, nu = 2, kmax = 1, k50 = 0.5
# start with b(0) = 0.1 g/l and n(0) = n_in; dashed the steady state n* = D k50/(kmax - D), b* = (n_in - n*)/nu
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

D = 0.2; nin = 10; nu = 2; kmax = 1.0; k50 = 0.5    # D in 1/h, concentrations in g/l
K(n) = kmax * n / (k50 + n)                         # Monod growth rate
f(t, z) = [K(z[2]) * z[1] - D * z[1], -nu * K(z[2]) * z[1] - D * z[2] + D * nin]
t = range(0, 20, length = 2001)
z = loese(f, [0.1, nin], t); b = z[1, :]; n = z[2, :]
ns = D * k50 / (kmax - D); bs = (nin - ns) / nu
@printf("steady state: n* = %.4f g/l,  b* = %.4f g/l\n", ns, bs)
@printf("b(20) = %.4f,  n(20) = %.4f;  largest biomass %.4f at t = %.2f h\n", b[end], n[end], maximum(b), t[argmax(b)])
p1 = hline([bs], color = :black, ls = :dash, legend = false, xlabel = "t (hours)", ylabel = "Biomass b (g/l)")
plot!(p1, t, b, color = R2, lw = 2)
p2 = hline([ns], color = :black, ls = :dash, legend = false, xlabel = "t (hours)", ylabel = "Nutrient n (g/l)")
plot!(p2, t, n, color = R2, lw = 2)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
