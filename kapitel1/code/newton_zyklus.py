# Abb. 1.34: Newton-Verfahren ohne Konvergenz (Buch, Abschnitt 1.5, Gl. 1.44)
# g(x) = x^3 - 2x + 2 mit x_0 = 0: die Näherungen springen zwischen 0 und 1, die Nullstelle bei -1.769 wird nicht gefunden
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

g = lambda x: x**3 - 2 * x + 2
dg = lambda x: 3 * x**2 - 2

x = [0.0]
for n in range(6):
    x.append(x[-1] - g(x[-1]) / dg(x[-1]))
print("x_0 ... x_6 =", "  ".join(f"{v:g}" for v in x))

xs = -1.0                                # mit einem besseren Startwert klappt es
for n in range(8):
    xs = xs - g(xs) / dg(xs)
print(f"Start bei -1: Nullstelle x* = {xs:.6f}")

xx = np.linspace(-2.2, 1.8, 400)
plt.plot(xx, g(xx), color=(0, 0.447, 0.741), label="g(x) = x^3 - 2x + 2")
plt.axhline(0, color="k", lw=0.8)
zz = np.linspace(-0.6, 1.6, 10)
for a in (0, 1):                         # die beiden Tangenten
    plt.plot(zz, g(a) + dg(a) * (zz - a), "k", lw=1)
plt.plot([0, 1], [0, 0], "o", color=(0.64, 0.08, 0.18))
plt.plot(xs, 0, "ko")
plt.ylim(-2.2, 4.5); plt.xlabel("x"); plt.legend(loc="upper left")
plt.show()
