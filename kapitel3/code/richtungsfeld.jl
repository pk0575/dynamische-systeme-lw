# Abb. 3.5: Richtungsfeld der Abkühlung mit einigen Lösungen (Buch, Abschnitt 3.1, Gl. 3.3)
# In jedem Punkt (t, T) zeigt ein kurzer Strich die Steigung dT/dt = 0.03 (5 - T); die Lösungen folgen diesen Steigungen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

k = 0.03; Tu = 5
p = plot(legend = false, xlims = (0, 184), ylims = (-3, 92), xlabel = "t (min)", ylabel = "T (°C)")
for t in range(5, 175, length = 18), T in range(2, 88, length = 12)
    S = k * (Tu - T)                     # Steigung dT/dt im Punkt (t, T)
    dt = 4 / sqrt(1 + (S * 180 / 90)^2)  # Striche gleicher Länge im Bild
    plot!(p, [t - dt, t + dt], [T - S * dt, T + S * dt], color = RGB(0.2, 0.6, 0.25))
end
tt = range(0, 180, length = 300)
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]
for (i, T0) in enumerate([80, 40, 0])
    plot!(p, tt, Tu .+ (T0 - Tu) .* exp.(-k .* tt), color = rot[i], lw = 2)
    @printf("T(0) = %2d: T(60) = %.2f\n", T0, Tu + (T0 - Tu) * exp(-60k))
end
hline!(p, [Tu], ls = :dash, color = :black)
display(p)
