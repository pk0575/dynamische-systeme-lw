# Abb. 3.8: exponentielles Wachstum und Abklingen (Buch, Abschnitt 3.2, Gl. 3.15 und 3.16)
# x(t) = e^(0.5 t) und x(t) = e^(-0.5 t); links lineare, rechts logarithmische Achse (dort werden beide zu Geraden)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
t = np.linspace(0, 6, 300)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for ax in axs:
    ax.plot(t, np.exp(0.5 * t), color=(0.43, 0.04, 0.12), lw=2, label="e^(0.5t) (Wachstum)")
    ax.plot(t, np.exp(-0.5 * t), "--", color=(0.89, 0.44, 0.49), lw=2, label="e^(-0.5t) (Abklingen)")
    ax.set_xlabel("t")
axs[0].set_title("lineare Achse"); axs[0].legend()
axs[1].set_yscale("log"); axs[1].set_title("logarithmische Achse: Geraden")
print(f"Verdopplungszeit ln(2)/0.5 = {np.log(2) / 0.5:.4f},  Halbwertszeit = {np.log(2) / 0.5:.4f}")
plt.tight_layout()
plt.show()
