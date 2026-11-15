# Abb. 3.22: Euler-Verfahren mit zu großer Schrittweite (Buch, Abschnitt 3.4, Gl. 3.27)
# T_{n+1} - 5 = (1 - k h)(T_n - 5): für h = 40 ist der Faktor -0.2 (gedämpfte Schwingung), für h = 70 ist er -1.1 (Aufschaukeln)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
k, Tu, T0 = 0.03, 5, 80
tt = np.linspace(0, 700, 400)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for ax, h in zip(axs, [40, 70]):
    N = int(np.ceil(700 / h))
    t = h * np.arange(N + 1); T = np.zeros(N + 1); T[0] = T0
    for n in range(N):
        T[n + 1] = T[n] + h * k * (Tu - T[n])
    ax.plot(tt, Tu + (T0 - Tu) * np.exp(-k * tt), color=(0.43, 0.04, 0.12), lw=2)
    ax.plot(t, T, "--o", color=(0.89, 0.44, 0.49), ms=5, lw=1)
    ax.axhline(Tu, color="k", ls=":", lw=1)
    ax.set_title(f"h = {h}: Faktor 1 - kh = {1 - k * h:.1f}"); ax.set_xlabel("t (min)")
    print(f"h = {h}: T_1 ... T_4 =", "  ".join(f"{x:.2f}" for x in T[1:5]))
axs[1].set_ylim(-250, 250)
plt.tight_layout()
plt.show()
