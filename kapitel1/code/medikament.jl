# Abb. 1.16: Medikamentenspiegel mit täglicher Dosis (Buch, Abschnitt 1.2, Gl. 1.23)
# x_{n+1} = a x_n + b_n, b_n = d falls n durch 24 teilbar, sonst 0;  a = 0.99, d = 0.4, x_0 = 0, n in Stunden
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

a = 0.99; d = 0.4; x0 = 0.0
N = 504                                  # 21 Tage
x = zeros(N + 1)
x[1] = x0                                # x[1] ist x_0
for k in 1:N
    n = k - 1                            # Zeitschritt n
    b = n % 24 == 0 ? d : 0.0            # alle 24 Stunden eine Dosis
    x[k + 1] = a * x[k] + b
end

xmax = d / (1 - a^24)                    # Grenzwert der Spitzenwerte
@printf("x_max = %.4f\n", xmax)
@printf("Spitzenwert nach 20 Tagen: x_481 = %.4f\n", x[482])

rot = RGB(0.64, 0.08, 0.18)
bilder = [begin
    p = plot(0:ende - 1, x[1:ende], ls = :dash, marker = :circle, ms = 2, color = rot, legend = false,
             xlabel = "n (Stunden)", ylabel = "x_n")
    hline!(p, [xmax], color = :black)
end for ende in (73, N + 1)]
display(plot(bilder..., layout = (2, 1), size = (800, 600)))
