# Fig. 4.13: Michaelis-Menten system with all four concentrations (book, Section 4.3, Eq. 4.12)
# k1 = 1, k2 = 1e-4, k3 = 0.1, [S]0 = 0.5 µM, [E]0 = 0.2 µM, [SE]0 = [P]0 = 0
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
idx(t, tt) = findfirst(t .>= tt - 1e-9)    # first index with t >= tt
k1 = 1.0; k2 = 1e-4; k3 = 0.1             # rates in 1/(µM s) and 1/s
S0 = 0.5                                 # µM
k50 = (k2 + k3) / k1
function mm(t, z)
    S, E, C, P = z                       # substrate, enzyme, complex SE, product
    r1 = k1 * S * E; r2 = k2 * C; r3 = k3 * C
    return [-r1 + r2, -r1 + r2 + r3, r1 - r2 - r3, r3]
end

E0 = 0.2
t = range(0, 60, length = 3001)
z = loese(mm, [S0, E0, 0, 0], t, abstol = 1e-13); S, E, C, P = eachrow(z)
println("conservation [E] + [SE] = E0 up to rounding errors (< 1e-12): ", maximum(abs.(E .+ C .- E0)) < 1e-12 ? "yes" : "no")
for tt in (5, 20, 60)
    i = idx(t, tt)
    @printf("t = %2d s: [S] = %.4f, [E] = %.4f, [SE] = %.4f, [P] = %.4f\n", tt, S[i], E[i], C[i], P[i])
end
farben = [R1, R2, R3, RGB(0.95, 0.70, 0.73)]
p = plot(xlabel = "t (s)", ylabel = "Concentration (µM)", legend_columns = 2)
for (y, name, fa, m) in zip([S, E, C, P], ["Substrate [S]", "Enzyme [E]", "Complex [SE]", "Product [P]"], farben, [:circle, :rect, :diamond, :utriangle])
    plot!(p, t, y, color = fa, lw = 2, label = name)
    scatter!(p, t[1:250:end], y[1:250:end], color = fa, marker = m, label = "")
end
display(p)
