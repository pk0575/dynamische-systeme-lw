# Abb. 4.6: gedämpfter Oszillator (Buch, Abschnitt 4.1, Gl. 4.5 und 4.6)
# m x'' + mu x' + k x = 0 als System dx1/dt = x2, dx2/dt = -(k x1 + mu x2)/m  mit m = 1, mu = 0.4, k = 4, x1(0) = 1, x2(0) = 0
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
m, mu, k = 1, 0.4, 4
f = lambda t, z: [z[1], -(k * z[0] + mu * z[1]) / m]
t = np.linspace(0, 20, 2001)
s = solve_ivp(f, [0, 20], [1, 0], t_eval=t, rtol=1e-9, atol=1e-11)
x1, x2 = s.y
for tt in [5, 10, 20]:
    i = np.searchsorted(t, tt)
    print(f"t = {tt:2d}: x1 = {x1[i]:7.4f},  x2 = {x2[i]:7.4f}")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
axs[0].axhline(0, color="k", lw=1)
axs[0].plot(t, x1, color=(0.43, 0.04, 0.12), lw=2, label="Ort x1")
axs[0].plot(t, x2, color=(0.89, 0.44, 0.49), lw=2, label="Geschwindigkeit x2")
axs[0].set_xlabel("t"); axs[0].legend()
axs[1].plot(x1, x2, color=(0.64, 0.08, 0.18), lw=2); axs[1].plot([1, 0], [0, 0], "ko")
axs[1].set_xlabel("Ort x1"); axs[1].set_ylabel("Geschwindigkeit x2")
plt.tight_layout()
plt.show()
