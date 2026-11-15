# Abb. 3.4: Abkühlung eines Gerichts im Kühlschrank (Buch, Abschnitt 3.1, Gl. 3.3 und 3.12)
# dT/dt = k (T^u - T) mit k = 0.03 pro Minute, T^u = 5 °C, T(0) = 80 °C:  T(t) = 75 e^(-0.03 t) + 5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

k = 0.03; Tu = 5; T0 = 80
t = range(0, 180, length = 400)
T = Tu .+ (T0 - Tu) .* exp.(-k .* t)
ts = log((T0 - Tu) / (10 - Tu)) / k      # Zeitpunkt, zu dem T = 10 °C erreicht ist
@printf("T = 10 °C nach t = ln(15)/k = %.1f min\n", ts)
p = plot(t, T, color = RGB(0.64, 0.08, 0.18), lw = 2.5, label = "T(t)", xlabel = "t (min)", ylabel = "T (°C)")
hline!(p, [Tu], ls = :dash, color = :black, label = "")
plot!(p, [ts, ts], [0, 10], ls = :dot, color = :gray, label = ""); scatter!(p, [ts], [10], color = :black, label = "")
display(p)
