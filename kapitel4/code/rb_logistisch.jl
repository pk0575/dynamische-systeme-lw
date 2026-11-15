# Abb. 4.2: kontinuierliches Räuber-Beute-Modell (Buch, Abschnitt 4.1, Gl. 4.2)
# dx/dt = r (1 - x/K) x - c x y,  dy/dt = d x y - e y  mit r = 1, K = 10, c = 0.5, d = 0.2, e = 1, x(0) = 8, y(0) = 0.5
# links Zeitverläufe, rechts dieselbe Lösung in der Phasenebene
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
idx(t, tt) = findfirst(t .>= tt - 1e-9)    # erster Index mit t >= tt
r = 1; K = 10; c = 0.5; d = 0.2; e = 1
f(t, z) = [r * (1 - z[1] / K) * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2]]

t = range(0, 40, length = 2001)
z = loese(f, [8, 0.5], t); x = z[1, :]; y = z[2, :]
for tt in (10, 20, 40)
    i = idx(t, tt)
    @printf("t = %2d: x = %.3f,  y = %.3f\n", tt, x[i], y[i])
end
@printf("stationärer Zustand (e/d, r/c (1 - e/(d K))) = (%g, %g)\n", e / d, r / c * (1 - e / (d * K)))
p1 = plot(t, x, color = R1, lw = 2, label = "Beute x(t)", xlabel = "t")
plot!(p1, t, y, color = R3, lw = 2, label = "Räuber y(t)")
p2 = plot(x, y, color = R2, lw = 2, legend = false, xlabel = "Beute x", ylabel = "Räuber y")
scatter!(p2, [8, 5], [0.5, 1], color = :black)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
