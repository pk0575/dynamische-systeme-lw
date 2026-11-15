# Abb. 4.3: Richtungsfeld des Räuber-Beute-Modells (Buch, Abschnitt 4.1, Gl. 4.2)
# Pfeile in Richtung (dx/dt, dy/dt), alle gleich lang; dazu die Lösung aus Abb. 4.2 und die stationären Zustände
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
r = 1; K = 10; c = 0.5; d = 0.2; e = 1
f(t, z) = [r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2]]
function feldpfeile(f)                   # Richtungsfeld: gleich lange Pfeile im Bild
    X = Float64[]; Y = Float64[]; U = Float64[]; W = Float64[]
    for x in range(0.4, 10.6, length = 18), y in range(0.15, 2.85, length = 10)
        u, w = f(0, [x, y]); u /= 11; w /= 3; L = hypot(u, w)
        push!(X, x); push!(Y, y); push!(U, u / L * 0.3); push!(W, w / L * 0.3 * 3 / 11)
    end
    return X, Y, U, W
end

X, Y, U, W = feldpfeile(f)
p = quiver(X, Y, quiver = (U, W), color = GR, legend = false, xlims = (0, 11), ylims = (0, 3), xlabel = "Beute x", ylabel = "Räuber y")
z = loese(f, [8, 0.5], range(0, 40, length = 2001))
plot!(p, z[1, :], z[2, :], color = R2, lw = 2)
scatter!(p, [0, 10], [0, 0], color = :white, msc = :black, ms = 7)    # instabil
scatter!(p, [5], [1], color = :black, ms = 7)                          # stabil
for (xs, ys) in [(0, 0), (10, 0), (5, 1)]
    u, w = f(0, [xs, ys])
    @printf("(%2d, %d): dx/dt = %g, dy/dt = %g\n", xs, ys, u, w)
end
display(p)
