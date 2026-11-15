# Abb. 1.32: stationärer Zustand von x_{n+1} = exp(-x_n) (Buch, Abschnitt 1.5)
# links: Schnittpunkt von f(x) = exp(-x) mit y = x;  rechts: gleichwertig die Nullstelle von g(x) = exp(-x) - x
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

x = 0.5
for n in range(100):                     # Fixpunktiteration x_{n+1} = exp(-x_n)
    x = np.exp(-x)
print(f"Fixpunktiteration nach 100 Schritten: x = {x:.10f}")
print(f"g(x) = exp(-x) - x = {np.exp(-x) - x:.1e}")

xx = np.linspace(0, 1, 200)
fig, axs = plt.subplots(1, 2, figsize=(10, 4.8))
axs[0].plot(xx, np.exp(-xx), color=(0, 0.447, 0.741), label="f(x) = exp(-x)")
axs[0].plot([0, 1], [0, 1], "k", lw=0.8, label="y = x")
axs[0].plot(x, x, "ko")
axs[1].plot(xx, np.exp(-xx) - xx, color=(0, 0.447, 0.741), label="g(x) = exp(-x) - x")
axs[1].axhline(0, color="k", lw=0.8)
axs[1].plot(x, 0, "ko")
for ax in axs:
    ax.set_xlabel("x"); ax.legend()
plt.show()
