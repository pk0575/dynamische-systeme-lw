# Abb. 3.14: Phasenlinie des logistischen Modells (Buch, Abschnitt 3.3, Gl. 3.22)
# f(x) = r (1 - x/K) x mit r = 0.55, K = 210; wo f > 0 ist, wächst x (Pfeil nach rechts), wo f < 0 ist, fällt x
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.55, 210
f = lambda x: r * (1 - x / K) * x
df = lambda x: r * (1 - 2 * x / K)                      # Ableitung f'(x)
x = np.linspace(-30, 280, 400)
plt.plot(x, f(x), color=(0, 0.447, 0.741), lw=2.5, label="f(x) = r (1 - x/K) x")
plt.axhline(0, color="k", lw=1)
for a, b in [(20, 185), (275, 225), (-8, -28)]:         # Phasenlinie: Bewegungsrichtung von x
    plt.annotate("", xy=(b, 0), xytext=(a, 0), arrowprops=dict(arrowstyle="-|>", color=(0.64, 0.08, 0.18), lw=2.5))
plt.plot(0, 0, "o", ms=11, mfc="w", mec="k", mew=2); plt.plot(K, 0, "ko", ms=11)
for xs in [0, K]:
    print(f"x* = {xs:3d}: f'(x*) = {df(xs):5.2f} ->", "stabil" if df(xs) < 0 else "instabil")
plt.xlabel("x"); plt.legend()
plt.show()
