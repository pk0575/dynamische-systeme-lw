# Abb. 3.22: Euler-Verfahren mit zu großer Schrittweite (Buch, Abschnitt 3.4, Gl. 3.27)
# T_{n+1} - 5 = (1 - k h)(T_n - 5): für h = 40 ist der Faktor -0.2 (gedämpfte Schwingung), für h = 70 ist er -1.1 (Aufschaukeln)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

k = 0.03; Tu = 5; T0 = 80
tt = range(0, 700, length = 400)
bilder = []
for h in (40, 70)
    N = ceil(Int, 700 / h)
    t = h .* (0:N); T = zeros(N + 1); T[1] = T0
    for n in 1:N
        T[n + 1] = T[n] + h * k * (Tu - T[n])
    end
    p = plot(tt, Tu .+ (T0 - Tu) .* exp.(-k .* tt), color = RGB(0.43, 0.04, 0.12), lw = 2, legend = false,
             title = @sprintf("h = %d: Faktor 1 - kh = %.1f", h, 1 - k * h), xlabel = "t (min)")
    plot!(p, t, T, ls = :dash, marker = :circle, ms = 3, color = RGB(0.89, 0.44, 0.49))
    hline!(p, [Tu], ls = :dot, color = :black)
    h == 70 && ylims!(p, (-250, 250))
    push!(bilder, p)
    println(@sprintf("h = %d: T_1 ... T_4 = ", h), join([@sprintf("%.2f", v) for v in T[2:5]], "  "))
end
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
