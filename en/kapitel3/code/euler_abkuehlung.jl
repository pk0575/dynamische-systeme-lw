# Fig. 3.21: Euler's method for cooling with different step sizes (book, Section 3.4, Eq. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80; Euler with h = 10 and h = 5 compared with the exact solution
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

k = 0.03; Tu = 5; T0 = 80
exakt(t) = Tu + (T0 - Tu) * exp(-k * t)
tt = range(0, 120, length = 300)
p = plot(tt, exakt.(tt), color = RGB(0.43, 0.04, 0.12), lw = 2, label = "exact", xlabel = "t (min)", ylabel = "T (°C)")
for (h, farbe, zeichen) in [(10, RGB(0.64, 0.08, 0.18), :rect), (5, RGB(0.89, 0.44, 0.49), :diamond)]
    N = 120 ÷ h
    t = h .* (0:N); T = zeros(N + 1); T[1] = T0
    for n in 1:N
        T[n + 1] = T[n] + h * k * (Tu - T[n])
    end
    plot!(p, t, T, ls = :dash, marker = zeichen, color = farbe, label = "Euler, h = $h")
    @printf("h = %2d: T(60) ≈ %.3f,  error %.3f\n", h, T[60 ÷ h + 1], abs(T[60 ÷ h + 1] - exakt(60)))
end
display(p)
