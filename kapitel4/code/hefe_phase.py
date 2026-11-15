# Abb. 4.18: Konkurrenzmodell in der Phasenebene (Buch, Abschnitt 4.4, Gl. 4.4)
# Nullklinen y = (1 - x/K1)/g1 und y = K2 (1 - g2 x), stationäre Zustände (gefüllt: stabil, offen: instabil) und die Lösung aus Abb. 4.5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r1, K1, g1 = 0.0607, 5.8, 0.0757      # S. kephir
r2, K2, g2 = 0.2183, 13, 0.2423       # S. cerevisiae
f = lambda t, z: [r1 * (1 - z[0] / K1 - g1 * z[1]) * z[0], r2 * (1 - z[1] / K2 - g2 * z[0]) * z[1]]

xs = np.linspace(0, 6.5, 50)
plt.plot(xs, (1 - xs / K1) / g1, color=(0, 0.447, 0.741), lw=3, label="dx/dt = 0")
plt.plot(xs, K2 * (1 - g2 * xs), color=(0.45, 0.70, 0.90), lw=3, label="dy/dt = 0")
s = solve_ivp(f, [0, 400], [0.5, 0.5], t_eval=np.linspace(0, 400, 4001), rtol=1e-9, atol=1e-11)
plt.plot(s.y[0], s.y[1], color=(0.64, 0.08, 0.18), lw=2); plt.plot(0.5, 0.5, "o", color=(0.64, 0.08, 0.18))
for (x, y) in [(0, 0), (0, K2), (K1, 0)]:
    J = np.array([[r1 * (1 - 2 * x / K1 - g1 * y), -r1 * g1 * x], [-r2 * g2 * y, r2 * (1 - 2 * y / K2 - g2 * x)]])
    lam = np.linalg.eigvals(J); stabil = max(lam.real) < 0
    plt.plot(x, y, "o", color="k", mfc="k" if stabil else "w", ms=10, clip_on=False)
    print(f"({x:g}, {y:g}): Eigenwerte", "  ".join(f"{l:.4f}" for l in sorted(lam.real)), "->", "stabil" if stabil else "instabil")
plt.xlim(0, 6.5); plt.ylim(0, 15); plt.xlabel("S. kephir x"); plt.ylabel("S. cerevisiae y"); plt.legend()
plt.show()
