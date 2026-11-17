# Fig. 4.16: Full system and quasi-steady-state approximation (book, Section 4.3, Eq. 4.12 and 4.14)
# d[S]/dt = -kmax [S]/(k50 + [S]) with kmax = k3 [E]tot; left [E]tot = 0.2 µM, right 0.02 µM
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # package OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# solves dz/dt = f(t, z) and returns the solution at the times t (row i = component i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
k1 = 1.0; k2 = 1e-4; k3 = 0.1             # rates in 1/(µM s) and 1/s
S0 = 0.5                                 # µM
k50 = (k2 + k3) / k1
function mm(t, z)
    S, E, C, P = z                       # substrate, enzyme, complex SE, product
    r1 = k1 * S * E; r2 = k2 * C; r3 = k3 * C
    return [-r1 + r2, -r1 + r2 + r3, r1 - r2 - r3, r3]
end

bilder = []
for (E0, T) in [(0.2, 60), (0.02, 600)]
    t = range(0, T, length = 4001)
    voll = loese(mm, [S0, E0, 0, 0], t, abstol = 1e-14)[1, :]
    kmax = k3 * E0
    qss = loese((t, S) -> [-kmax * S[1] / (k50 + S[1])], [S0], t, abstol = 1e-13)[1, :]
    @printf("[E]tot = %g: largest deviation %.4f µM\n", E0, maximum(abs.(voll .- qss)))
    p = plot(t, voll, color = R1, lw = 2, label = "full system", title = @sprintf("[E]tot = %g µM", E0),
             xlabel = "t (s)", ylabel = "Substrate [S] (µM)")
    plot!(p, t, qss, color = R3, lw = 2, label = "quasi-steady state")
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
