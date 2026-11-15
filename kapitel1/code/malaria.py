# Abb. 1.3: Malaria-Parasiten nach n Tagen (Buch, Abschnitt 1.1, Gl. 1.2 und 1.3)
# Rekursionsvorschrift x_{n+1} = 8 x_n, x_0 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N = 4                           # Anzahl der Tage
x = np.zeros(N + 1)
x[0] = 1                        # Startwert: ein Parasit
for n in range(N):
    x[n + 1] = 8 * x[n]         # Rekursionsvorschrift

n = np.arange(N + 1)
print(x.astype(int))            # [1 8 64 512 4096]
print((8**n * x[0]).astype(int))  # Lösungsformel x_n = 8^n x_0 liefert dasselbe

plt.plot(n, x, "o--", color=(0.64, 0.08, 0.18))
for k in n:
    plt.text(k, x[k] + 100, f"{x[k]:.0f}", ha="center", color=(0.64, 0.08, 0.18))
plt.xlabel("n (Tage)")
plt.ylabel("Anzahl Parasiten $x_n$")
plt.xticks(n)
plt.show()
