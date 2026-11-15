# Abb. 1.25: Treppendiagramm zu x_{n+1} = x_n + 0.5 (Buch, Abschnitt 1.4)
# x_0 = 0.25; links ein Schritt, rechts vier Schritte. Der Graph von f schneidet y = x nicht: kein stationärer Zustand.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

f = lambda x: x + 0.5
x = [0.25]
for _ in range(4):
    x.append(f(x[-1]))
print("x_0 ... x_4 =", "  ".join(f"{v:g}" for v in x))

fig, axs = plt.subplots(1, 2, figsize=(10, 5))
for ax, schritte in zip(axs, (1, 4)):
    ax.plot([0, 3], [f(0), f(3)], color=(0, 0.447, 0.741), label="f(x) = x + 0.5")
    ax.plot([0, 3], [0, 3], "k", lw=0.8, label="y = x")
    px, py = [x[0]], [0]
    for k in range(schritte):
        px += [x[k], x[k + 1]]; py += [x[k + 1], x[k + 1]]
    ax.plot(px, py, color=(0.64, 0.08, 0.18))
    ax.plot(x[:schritte], x[1:schritte + 1], "o", color=(0.64, 0.08, 0.18))    # Punkte (x_n, x_{n+1})
    ax.set_xlim(0, 3); ax.set_ylim(0, 3); ax.set_aspect("equal")
    ax.set_xlabel("x"); ax.set_ylabel("f(x)")
axs[0].legend(loc="lower right")
plt.show()
