# Fig. 4.15: Michaelis-Menten system in the ([S], [SE]) plane (book, Section 4.3, Eq. 4.13)
# solution with time marks and the curve d[SE]/dt = 0, i.e. [SE] = [E]tot [S]/([S] + k50); left [E]tot = 0.2 µM, right 0.02 µM
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

bilder = []
for (E0, T, marken) in [(0.2, 60, [2, 10, 30]), (0.02, 600, [5, 100, 300])]
    t = range(0, T, length = 4001)
    z = loese(mm, [S0, E0, 0, 0], t, abstol = 1e-14); S = z[1, :]; C = z[3, :]
    Sg = range(0, 0.52, length = 300)
    p = plot(Sg, E0 .* Sg ./ (Sg .+ k50), color = BL, lw = 2, label = "d[SE]/dt = 0", ylims = (0, E0), legend = :topleft,
             title = @sprintf("[E]tot = %g µM", E0), xlabel = "[S] (µM)", ylabel = "[SE] (µM)")
    plot!(p, S, C, color = R2, lw = 2, label = "Solution")
    for tm in marken
        i = idx(t, tm)
        scatter!(p, [S[i]], [C[i]], color = :black, label = ""); annotate!(p, S[i] + 0.01, C[i], text("$tm s", 9, :left))
        @printf("[E]tot = %g: t = %3d s: [S] = %.4f, [SE] = %.5f\n", E0, tm, S[i], C[i])
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
