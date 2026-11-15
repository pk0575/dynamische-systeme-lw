# Abb. 1.18: Ratenfunktion des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.26)
# R(x) = r (1 - x/K): bei kleinem Bestand wächst er fast mit der Rate r, bei x = K kommt das Wachstum zum Erliegen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

r, K = 1.0, 5.0
R = lambda x: r * (1 - x / K)
for x in [0, 1, 2.5, 5]:
    print(f"R({x}) = {R(x):.2f}")

x = np.linspace(0, K, 100)
plt.plot(x, R(x), color=(0, 0.447, 0.741))
plt.xticks([0, K], ["0", "K"]); plt.yticks([0, r], ["0", "r"])
plt.xlabel("x"); plt.ylabel("R(x)")
plt.show()
