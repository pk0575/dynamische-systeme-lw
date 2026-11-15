# Abb. 4.15: Michaelis-Menten-System in der ([S], [SE])-Ebene (Buch, Abschnitt 4.3, Gl. 4.13)
# Lösung mit Zeitmarken und die Kurve d[SE]/dt = 0, also [SE] = [E]tot [S]/([S] + k50); links [E]tot = 0.2 µM, rechts 0.02 µM
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
idx(t, tt) = findfirst(t .>= tt - 1e-9)    # erster Index mit t >= tt
k1 = 1.0; k2 = 1e-4; k3 = 0.1             # Raten in 1/(µM s) bzw. 1/s
S0 = 0.5                                 # µM
k50 = (k2 + k3) / k1
function mm(t, z)
    S, E, C, P = z                       # Substrat, Enzym, Komplex SE, Produkt
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
    plot!(p, S, C, color = R2, lw = 2, label = "Lösung")
    for tm in marken
        i = idx(t, tm)
        scatter!(p, [S[i]], [C[i]], color = :black, label = ""); annotate!(p, S[i] + 0.01, C[i], text("$tm s", 9, :left))
        @printf("[E]tot = %g: t = %3d s: [S] = %.4f, [SE] = %.5f\n", E0, tm, S[i], C[i])
    end
    push!(bilder, p)
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
