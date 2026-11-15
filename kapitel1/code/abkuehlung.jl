# Abb. 1.15: Newtonsches Abkühlungsgesetz (Buch, Abschnitt 1.2, Gl. 1.21)
# T_{n+1} = T_n + alpha (T^u - T_n) mit T_0 = 35 und T^u = 23
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

T0 = 35; Tu = 23; N = 20
n = 0:N
rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :diamond]
bilder = [plot(xlabel = "n", ylabel = "T_n") for _ in 1:4]
for (i, alpha) in enumerate([0.1, 0.2, 0.5, 1.9, 2.0, 2.1])
    T = zeros(N + 1)
    T[1] = T0
    for k in 1:N
        T[k + 1] = T[k] + alpha * (Tu - T[k])
    end
    if i <= 3                            # 0 < alpha < 1: monotone Annäherung an T^u, alle in einem Bild
        plot!(bilder[1], n, T, ls = :dash, marker = zeichen[i], color = rot[i], label = "α = $alpha")
    else                                 # 1 < alpha: Schwingungen
        plot!(bilder[i - 2], n, T, ls = :dash, marker = :circle, color = rot[2], label = "α = $alpha")
        @printf("alpha = %g:  T_19 = %.3f,  T_20 = %.3f\n", alpha, T[20], T[21])
    end
end
for b in bilder
    hline!(b, [Tu], color = :black, label = "")
end
display(plot(bilder..., layout = (2, 2), size = (900, 650)))
