# Abb. 1.4: Fibonacci-Folge (Buch, Abschnitt 1.1, Gl. 1.5 und 1.6)
# x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Plots

N = 10                             # Anzahl der Monate
x = zeros(Int, N + 1)
x[1] = 1; x[2] = 1                 # zwei Startwerte x_0 und x_1 (Julia zählt ab 1)
for k in 2:N
    x[k + 1] = x[k] + x[k - 1]     # Rekursionsvorschrift
end

n = 0:N
phi = (1 + sqrt(5)) / 2; psi = (1 - sqrt(5)) / 2
formel = (phi .^ (n .+ 1) .- psi .^ (n .+ 1)) ./ sqrt(5)   # Lösungsformel (Gl. 1.6)
println(x)                         # [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
println(round.(Int, formel))       # Lösungsformel liefert dieselben Zahlen

rot = RGB(0.64, 0.08, 0.18)
p = plot(n, x, ls = :dash, marker = :circle, color = rot, legend = false, xticks = n,
         xlabel = "n (Monate)", ylabel = "Hasenpaare x_n")
annotate!(p, [(n[k], x[k] + 4, text(string(x[k]), 8, rot)) for k in eachindex(n)])
display(p)
