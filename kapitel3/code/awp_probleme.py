# Abb. 3.6: Anfangswertprobleme ohne eindeutige oder ohne globale Lösung (Buch, Abschnitt 3.1)
# links dx/dt = t/x, x(0) = 0: x(t) = t und x(t) = -t lösen beide;  rechts dx/dt = x^2, x(0) = 1: x(t) = 1/(1 - t) nur für t < 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
t = np.linspace(0, 2, 100)
axs[0].plot(t, t, color=(0.43, 0.04, 0.12), lw=2, label="x₁(t) = t")
axs[0].plot(t, -t, "--", color=(0.89, 0.44, 0.49), lw=2, label="x₂(t) = −t")
axs[0].plot(0, 0, "ko"); axs[0].set_title("dx/dt = t/x, x(0) = 0"); axs[0].legend(); axs[0].set_xlabel("t")
t = np.linspace(0, 0.95, 200)
axs[1].plot(t, 1 / (1 - t), color=(0.64, 0.08, 0.18), lw=2); axs[1].axvline(1, color="k", ls="--", lw=1)
axs[1].plot(0, 1, "ko"); axs[1].set_ylim(0, 20); axs[1].set_xlim(0, 1.2)
axs[1].set_title("dx/dt = x², x(0) = 1"); axs[1].set_xlabel("t")
for tt in [0.5, 0.9, 0.99]:
    print(f"x({tt}) = 1/(1 - {tt}) = {1 / (1 - tt):.0f}")
plt.tight_layout()
plt.show()
