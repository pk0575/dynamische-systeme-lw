# Abb. 4.4: klassisches Lotka-Volterra-Modell (Buch, Abschnitt 4.1, Gl. 4.3)
# dx/dt = r x - c x y,  dy/dt = d x y - e y  mit r = 1, c = 0.5, d = 0.2, e = 1
# links periodische Zeitverläufe für x(0) = 3, y(0) = 2, rechts geschlossene Bahnen für verschiedene Anfangswerte
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

r = 1; c = 0.5; d = 0.2; e = 1
f(t, z) = [r * z[1] - c * z[1] * z[2], d * z[1] * z[2] - e * z[2]]
H(x, y) = d * x - e * log(x) + c * y - r * log(y)    # bleibt längs jeder Lösung konstant
t = range(0, 25, length = 2501)
z = loese(f, [3, 2], t)
p1 = plot(t, z[1, :], color = R1, lw = 2, label = "Beute", xlabel = "t")
plot!(p1, t, z[2, :], color = R3, lw = 2, label = "Räuber")
p2 = plot(legend = false, xlabel = "Beute x", ylabel = "Räuber y")
for (i, x0) in enumerate([4, 3, 1.5])
    z = loese(f, [x0, 2], range(0, 12, length = 1201))
    plot!(p2, z[1, :], z[2, :], color = [R1, R2, R3][i], lw = 2)
    @printf("x(0) = %g: H am Anfang %.6f, am Ende %.6f\n", x0, H(x0, 2), H(z[1, end], z[2, end]))
end
scatter!(p2, [e / d], [r / c], color = :black)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
