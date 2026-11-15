# Abb. 1.30: Iterierte f^2 und f^3 des logistischen Modells (Buch, Abschnitt 1.4, Gl. 1.38)
# links: f^2 mit a = 3.1 (stabiler 2-Zyklus);  rechts: f^3 mit a = 3.835 (stabiler 3-Zyklus)
# Fixpunkte von f^k: schwarz gefüllt = stabil (|(f^k)'| < 1), weiß = instabil
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

def fk(x, a, k):                         # k-fache Anwendung von f(y) = a y (1 - y)
    for _ in range(k):
        x = a * x * (1 - x)
    return x

def fixpunkte(a, k):                     # Vorzeichenwechsel von f^k(x) - x suchen, dann halbieren
    x = np.linspace(0, 1, 200001)
    g = fk(x, a, k) - x
    pts = [0.0]
    for i in np.where(np.sign(g[:-1]) != np.sign(g[1:]))[0]:
        lo, hi = x[i], x[i + 1]
        for _ in range(60):
            m = (lo + hi) / 2
            if np.sign(fk(lo, a, k) - lo) == np.sign(fk(m, a, k) - m): lo = m
            else: hi = m
        pts.append((lo + hi) / 2)
    return sorted(set(np.round(pts, 10)))

fig, axs = plt.subplots(1, 2, figsize=(10, 5))
x = np.linspace(0, 1, 2000)
for ax, (a, k) in zip(axs, [(3.1, 2), (3.835, 3)]):
    ax.plot(x, fk(x, a, k), color=(0, 0.447, 0.741), label=f"f^{k}(x), a = {a}")
    ax.plot([0, 1], [0, 1], "k", lw=0.8)
    for p in fixpunkte(a, k):
        e = 1e-7
        ableitung = (fk(p + e, a, k) - fk(p - e, a, k)) / (2 * e)
        stabil = abs(ableitung) < 1
        ax.plot(p, p, "o", mec="k", mfc="k" if stabil else "w", ms=8)
        print(f"a = {a}, f^{k}:  x = {p:.4f}  {'stabil' if stabil else 'instabil'}  (Ableitung {ableitung:.3f})")
    ax.set_xlim(0, 1); ax.set_ylim(0, 1); ax.set_aspect("equal")
    ax.set_xlabel("x"); ax.set_ylabel(f"f^{k}(x)"); ax.legend(loc="upper left")
plt.show()
