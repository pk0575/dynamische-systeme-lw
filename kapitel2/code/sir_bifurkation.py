# Abb. 2.17: stationäre Werte I* des SIR-Modells in Abhängigkeit von R_0 (Buch, Abschnitt 2.4, Gl. 2.30)
# x_a*: I* = 0, stabil für R_0 < 1;  x_b*: I* = alpha N (1 - 1/R_0)/(gamma + alpha), stabil für R_0 > 1 (alpha = gamma = 0.1)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N, alpha, gamma = 100000, 0.1, 0.1
R0 = np.linspace(0.01, 5, 500)
Ib = alpha * N * (1 - 1 / R0) / (gamma + alpha)
gruen = (0, 0.39, 0)

plt.plot(R0[R0 <= 1], 0 * R0[R0 <= 1], color=gruen, lw=3)                    # stabil
plt.plot(R0[R0 >= 1], 0 * R0[R0 >= 1], "--", color=gruen, lw=2)              # instabil
plt.plot(R0[R0 >= 1], Ib[R0 >= 1], color=gruen, lw=3)
plt.plot(R0[(R0 > 0.85) & (R0 <= 1)], Ib[(R0 > 0.85) & (R0 <= 1)], "--", color=gruen, lw=2)
for r, name in [(0.6, "A"), (3.8, "B")]:
    i = 0 if r < 1 else alpha * N * (1 - 1 / r) / (gamma + alpha)
    plt.plot(r, i, "ko"); plt.text(r, i + 2000, name, ha="center")
    print(f"Szenario {name}: R_0 = {r},  I* = {i:.0f}")
plt.axvline(1, color="k", ls=":")
plt.ylim(-6000, 52000); plt.xlabel("R_0"); plt.ylabel("I*")
plt.show()
