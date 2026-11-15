# Abb. 1.1: Fischlänge nach n Jahren (Buch, Abschnitt 1.1, Gl. 1.1)
# explizite Folge x_n = 60 n / (n + 2)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

n = np.arange(0, 11)            # n = 0, 1, ..., 10
x = 60 * n / (n + 2)            # Formel für das n-te Folgenglied

print("  ".join(f"{v:.1f}" for v in x))   # 0.0  20.0  30.0  36.0  40.0  42.9  45.0 ...

plt.plot(n, x, "o--", color=(0.64, 0.08, 0.18))
for k in n:
    plt.text(k, x[k] + 1.5, f"{x[k]:.1f}", ha="center", color=(0.64, 0.08, 0.18))
plt.xlabel("n (Jahre)")
plt.ylabel("Fischlänge $x_n$ (cm)")
plt.ylim(-3, 60)
plt.show()
