# Abb. 1.36: Aktualisierungsfunktion des AV-Knoten-Modells (Buch, Abschnitt 1.6, Gl. 1.47)
# f(V) = c V falls c V > V_g, sonst c V + u;  V_g = 1, u = 1;  links c = 1/3, rechts zusätzlich c = 0.6
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

Vg, u = 1.0, 1.0
f = lambda V, c: np.where(c * V > Vg, c * V, c * V + u)

fig, axs = plt.subplots(1, 2, figsize=(10, 4.5))
for ax, cs in zip(axs, [(1 / 3,), (1 / 3, 0.6)]):
    for c, farbe in zip(cs, [(0, 0.447, 0.741), (0.45, 0.70, 0.90)]):
        s = Vg / c                                   # Sprungstelle: c V = V_g
        a = np.linspace(0, min(s, 4), 200); b = np.linspace(s, 4, 200)
        ax.plot(a, c * a + u, color=farbe, label=f"c = {c:.3g}")
        ax.plot(b, c * b, color=farbe)
        ax.plot(s, c * s + u, "o", color=farbe)     # an der Sprungstelle gilt der obere Zweig (c V <= V_g)
        if len(cs) == 2:
            print(f"c = {c:.3g}: Sprungstelle bei V = V_g/c = {s:.3f}")
    ax.set_xlim(0, 4); ax.set_ylim(0, 2.7)
    ax.set_xlabel("V"); ax.set_ylabel("f(V)"); ax.legend(loc="upper left")
plt.show()
