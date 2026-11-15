# Abb. 3.16: Fischbestand mit Ernte, stationäre Zustände in Abhängigkeit von der Ernterate (Buch, Abschnitt 3.3)
# dx/dt = r (1 - x/K) x - h x mit r = 0.5 pro Jahr, K = 100 (1000 t):  x_a* = 0 und x_b* = K (1 - h/r)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.5, 100
gruen = (0, 0.39, 0)
h = np.linspace(0, 1, 301)
li, re = h <= r, h >= r
plt.plot(h[li], 0 * h[li], "--", color=gruen, lw=2)                  # x_a* instabil für h < r
plt.plot(h[re], 0 * h[re], color=gruen, lw=3)                        # stabil für h > r
plt.plot(h[li], K * (1 - h[li] / r), color=gruen, lw=3)              # x_b* stabil für h < r
nah = (h >= r) & (h <= 0.62)
plt.plot(h[nah], K * (1 - h[nah] / r), "--", color=gruen, lw=2)
plt.axvline(r, color="k", ls=":", lw=1)
for hh in [0.1, 0.25, 0.4]:
    print(f"h = {hh}: x_b* = {K * (1 - hh / r):.0f},  Ertrag h x_b* = {hh * K * (1 - hh / r):.2f}")
plt.xlabel("Ernterate h (pro Jahr)"); plt.ylabel("x* (1000 t)"); plt.ylim(-30, 105)
plt.show()
