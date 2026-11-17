# Fig. 3.20: Euler's method follows the slope of the direction field (book, Section 3.4, Eq. 3.26)
# dT/dt = 0.03 (5 - T), T(0) = 80, step size h = 20:  T_{n+1} = T_n + h · 0.03 (5 - T_n)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

k = 0.03; Tu = 5; T0 = 80; h = 20
N = 6
t = h .* (0:N)
T = zeros(N + 1); T[1] = T0
for n in 1:N
    T[n + 1] = T[n] + h * k * (Tu - T[n])
end
tt = range(0, 120, length = 300)
p = plot(tt, Tu .+ (T0 - Tu) .* exp.(-k .* tt), color = RGB(0.43, 0.04, 0.12), lw = 2, label = "exact solution T(t)",
         xticks = t, xlabel = "t (min)", ylabel = "T (°C)")
plot!(p, t, T, color = RGB(0.2, 0.6, 0.25), lw = 2, label = "Tangent segments")
scatter!(p, t, T, color = RGB(0.89, 0.44, 0.49), ms = 6, label = "Euler T_n, h = 20")
for n in 1:N + 1
    @printf("t = %5.0f: T_n = %6.2f,  exact %6.2f\n", t[n], T[n], Tu + (T0 - Tu) * exp(-k * t[n]))
end
display(p)
