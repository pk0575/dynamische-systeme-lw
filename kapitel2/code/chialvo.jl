# Abb. 2.19: Aktionspotentiale im Chialvo-Modell (Buch, Abschnitt 2.5, Gl. 2.33)
# y1_{n+1} = y1_n^2 exp(y2_n - y1_n) + k,  y2_{n+1} = a y2_n - b y1_n + c  mit a = 0.89, c = 0.28, k = 0.03
# links b = 0.26 (regelmäßig), rechts b = 0.18 (chaotisch, frühe Nachdepolarisationen); oben y1, unten y2
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra

a = 0.89; c = 0.28; k = 0.03; N = 150
bilder = []
for b in (0.26, 0.18)
    y1 = zeros(N + 1); y2 = zeros(N + 1)
    y1[1] = 0.2; y2[1] = c / (1 - a)
    for j in 1:N
        y1[j + 1] = y1[j]^2 * exp(y2[j] - y1[j]) + k
        y2[j + 1] = a * y2[j] - b * y1[j] + c
    end
    ap = sum((y1[2:end] .> 1) .& (y1[1:end-1] .<= 1))     # Anzahl der Ausschläge über 1
    @printf("b = %g: %d Aktionspotentiale in %d Schritten, max y1 = %.2f\n", b, ap, N, maximum(y1))
    push!(bilder, plot(0:N, y1, ls = :dash, marker = :circle, ms = 2, color = RGB(0.64, 0.08, 0.18), legend = false, title = "b = $b", ylabel = "y_1,n"))
    push!(bilder, plot(0:N, y2, ls = :dash, marker = :circle, ms = 2, color = RGB(0.89, 0.44, 0.49), legend = false, xlabel = "n", ylabel = "y_2,n"))
end
display(plot(bilder[[1, 3, 2, 4]]..., layout = (2, 2), size = (900, 600)))
