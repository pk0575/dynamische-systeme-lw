# Fig. 3.5: Direction field of cooling with some solutions (book, Section 3.1, Eq. 3.3)
# At each point (t, T) a short dash shows the slope dT/dt = 0.03 (5 - T); the solutions follow these slopes
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

k = 0.03; Tu = 5
p = plot(legend = false, xlims = (0, 184), ylims = (-3, 92), xlabel = "t (min)", ylabel = "T (°C)")
for t in range(5, 175, length = 18), T in range(2, 88, length = 12)
    S = k * (Tu - T)                     # slope dT/dt at the point (t, T)
    dt = 4 / sqrt(1 + (S * 180 / 90)^2)  # dashes of equal length in the plot
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
