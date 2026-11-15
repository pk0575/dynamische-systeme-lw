# Abb. 3.1: vom zeitdiskreten zum kontinuierlichen Wachstum (Buch, Abschnitt 3.1, Gl. 3.1 und 3.2)
# x(t + dt) = (1 + r dt) x(t) mit r = 0.5, x(0) = 1 für dt = 1, 0.5, 0.1; für dt -> 0 entsteht x(t) = e^(r t)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r = 0.5
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, dt in enumerate([1, 0.5, 0.1]):
    n = np.arange(int(round(4 / dt)) + 1)
    x = (1 + r * dt)**n                                  # Lösung der Differenzengleichung
    plt.plot(n * dt, x, "os^"[i], color=rot[i], ms=[9, 7, 5][i], label=f"Δt = {dt}")
    print(f"dt = {dt}: x(4) = {x[-1]:.4f}")
t = np.linspace(0, 4, 300)
plt.plot(t, np.exp(r * t), color=rot[0], lw=2, label="x(t) = e^(rt)")
print(f"e^(0.5*4) = {np.exp(2):.4f}")
plt.xlabel("t"); plt.ylabel("x"); plt.legend()
plt.show()
