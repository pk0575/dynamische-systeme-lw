# Abb. 3.20: das Euler-Verfahren folgt der Steigung des Richtungsfelds (Buch, Abschnitt 3.4, Gl. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80, Schrittweite h = 20:  T_{n+1} = T_n + h · 0.03 (5 - T_n)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

k = 0.03; Tu = 5; T0 = 80; h = 20
N = 6
t = h .* (0:N)
T = zeros(N + 1); T[1] = T0
for n in 1:N
    T[n + 1] = T[n] + h * k * (Tu - T[n])
end
tt = range(0, 120, length = 300)
p = plot(tt, Tu .+ (T0 - Tu) .* exp.(-k .* tt), color = RGB(0.43, 0.04, 0.12), lw = 2, label = "exakte Lösung T(t)",
         xticks = t, xlabel = "t (min)", ylabel = "T (°C)")
plot!(p, t, T, color = RGB(0.2, 0.6, 0.25), lw = 2, label = "Tangentenstücke")
scatter!(p, t, T, color = RGB(0.89, 0.44, 0.49), ms = 6, label = "Euler T_n, h = 20")
for n in 1:N + 1
    @printf("t = %5.0f: T_n = %6.2f,  exakt %6.2f\n", t[n], T[n], Tu + (T0 - Tu) * exp(-k * t[n]))
end
display(p)
