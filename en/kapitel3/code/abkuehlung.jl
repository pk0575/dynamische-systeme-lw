# Fig. 3.4: Cooling of a dish in the refrigerator (book, Section 3.1, Eq. 3.3 and 3.12)
# dT/dt = k (T^u - T) with k = 0.03 per minute, T^u = 5 °C, T(0) = 80 °C:  T(t) = 75 e^(-0.03 t) + 5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

k = 0.03; Tu = 5; T0 = 80
t = range(0, 180, length = 400)
T = Tu .+ (T0 - Tu) .* exp.(-k .* t)
ts = log((T0 - Tu) / (10 - Tu)) / k      # time at which T = 10 °C is reached
@printf("T = 10 °C after t = ln(15)/k = %.1f min\n", ts)
p = plot(t, T, color = RGB(0.64, 0.08, 0.18), lw = 2.5, label = "T(t)", xlabel = "t (min)", ylabel = "T (°C)")
hline!(p, [Tu], ls = :dash, color = :black, label = "")
plot!(p, [ts, ts], [0, 10], ls = :dot, color = :gray, label = ""); scatter!(p, [ts], [10], color = :black, label = "")
display(p)
