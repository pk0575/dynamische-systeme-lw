# Abb. 1.3: Malaria-Parasiten nach n Tagen (Buch, Abschnitt 1.1, Gl. 1.2 und 1.3)
# Rekursionsvorschrift x_{n+1} = 8 x_n, x_0 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Plots

N = 4                              # Anzahl der Tage
x = zeros(Int, N + 1)
x[1] = 1                           # Startwert x_0 = 1 (Julia zählt ab 1: x[1] ist x_0)
for k in 1:N
    x[k + 1] = 8 * x[k]            # Rekursionsvorschrift
end

n = 0:N
println(x)                         # [1, 8, 64, 512, 4096]
println(8 .^ n .* x[1])            # Lösungsformel x_n = 8^n x_0 liefert dasselbe

rot = RGB(0.64, 0.08, 0.18)
p = plot(n, x, ls = :dash, marker = :circle, color = rot, legend = false, xticks = n,
         xlabel = "n (Tage)", ylabel = "Anzahl Parasiten x_n")
annotate!(p, [(n[k], x[k] + 250, text(string(x[k]), 8, rot)) for k in eachindex(n)])
display(p)
