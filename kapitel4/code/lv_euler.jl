# Abb. 4.7: Euler-Verfahren für das Lotka-Volterra-Modell (Buch, Abschnitt 4.1, Gl. 4.7)
# x_{n+1} = x_n + h (r x_n - c x_n y_n),  y_{n+1} = y_n + h (d x_n y_n - e y_n)  mit h = 0.1; die exakte Bahn ist geschlossen
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
h = 0.1; N = 160
x = zeros(N + 1); y = zeros(N + 1); x[1] = 3; y[1] = 2
for n in 1:N
    x[n + 1] = x[n] + h * (r * x[n] - c * x[n] * y[n])
    y[n + 1] = y[n] + h * (d * x[n] * y[n] - e * y[n])
end
z = loese(f, [3, 2], range(0, 6.5, length = 651))
H(x, y) = d * x - e * log(x) + c * y - r * log(y)
@printf("H exakt (konstant): %.4f\n", H(3, 2))
println("H Euler nach 40, 80, 160 Schritten: ", join([@sprintf("%.4f", H(x[n + 1], y[n + 1])) for n in (40, 80, 160)], "  "))
p = plot(x, y, marker = :circle, ms = 2, color = R3, lw = 1, label = "Euler, h = 0.1", xlabel = "Beute x", ylabel = "Räuber y")
plot!(p, z[1, :], z[2, :], color = R1, lw = 2.5, label = "exakt")
scatter!(p, [3, 5], [2, 2], color = :black, label = "")
display(p)
