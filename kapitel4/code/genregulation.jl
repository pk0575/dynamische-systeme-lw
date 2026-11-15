# Abb. 4.22: Genregulation mit Aktivator und Repressor (Buch, Abschnitt 4.4, Gl. 4.18)
# dA/dt = k A^2/(A^2 + 10 (1 + 5R)) - A + 0.4,  dR/dt = 0.3 A^2/(A^2 + 10 (1 + 5R)) - 0.2 R  mit A(0) = 3, R(0) = 0.2
# links k = 9.5: gedämpfte Schwingung; rechts k = 10.5: Grenzzyklus
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))

t = range(0, 400, length = 4001)
bilder = []
for k in (9.5, 10.5)
    f(t, z) = [k * z[1]^2 / (z[1]^2 + 10 * (1 + 5z[2])) - z[1] + 0.4,
               0.3 * z[1]^2 / (z[1]^2 + 10 * (1 + 5z[2])) - 0.2 * z[2]]
    A = loese(f, [3, 0.2], t)[1, :]
    push!(bilder, plot(t, A, color = RGB(0.64, 0.08, 0.18), lw = 2, legend = false, title = "k = $k", xlabel = "t (min)",
                       ylabel = k == 9.5 ? "Aktivator A" : ""))
    spaet = t .> 200                     # Maxima nach dem Einschwingen
    i = [j for j in 2:length(A) - 1 if A[j] > A[j - 1] && A[j] > A[j + 1] && spaet[j]]
    schwankung = maximum(A[spaet]) - minimum(A[spaet])
    if schwankung > 0.01
        @printf("k = %g: Schwankung von A für t > 200: %.3f, Periode %.1f min\n", k, schwankung, sum(diff(t[i])) / (length(i) - 1))
    else
        @printf("k = %g: Schwankung von A für t > 200: %.3f (stationärer Zustand)\n", k, schwankung)
    end
end
display(plot(bilder..., layout = (1, 2), link = :y, size = (900, 420)))
