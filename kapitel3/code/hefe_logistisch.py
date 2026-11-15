# Abb. 3.12: logistisches Wachstum von Hefe (Buch, Abschnitt 3.2, Gl. 3.19 und 3.20)
# dx/dt = r (1 - x/K) x mit r = 0.55 pro Stunde, K = 210 (Millionen Zellen pro ml); Lösung x(t) = x0 K / (x0 + (K - x0) e^(-rt))
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.55, 210
x = lambda t, x0: x0 * K / (x0 + (K - x0) * np.exp(-r * t))
t = np.linspace(0, 20, 300)
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, x0 in enumerate([5, 50, 300]):
    plt.plot(t, x(t, x0), ["-", "--", "-."][i], color=rot[i], lw=2, label=f"x0 = {x0}")
    print(f"x0 = {x0:3d}: x(5) = {x(5, x0):6.2f},  x(20) = {x(20, x0):6.2f}")
plt.axhline(K, color="k", ls="--", lw=1)
plt.xlabel("t (h)"); plt.ylabel("x(t)"); plt.legend()
plt.show()
