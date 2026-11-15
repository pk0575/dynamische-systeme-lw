# Abb. 1.23: Bifurkationsdiagramm des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.28)
# y_{n+1} = a y_n (1 - y_n): für jeden Wert von a wird nach n_* = 10000 Schritten das Langzeitverhalten gezeichnet
# oben: 2.8 <= a <= 4;  unten: Ausschnitt 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (das Muster kehrt wieder)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

def bifurkation(a, behalten, fenster=(0, 1)):
    y = np.full_like(a, 0.9)                 # alle Parameterwerte gleichzeitig (Vektor)
    for _ in range(10000):                   # Einschwingen
        y = a * y * (1 - y)
    A, Y = [], []
    for _ in range(behalten):                # Langzeitverhalten sammeln
        y = a * y * (1 - y)
        m = (y > fenster[0]) & (y < fenster[1])
        A.append(a[m]); Y.append(y[m])
    return np.concatenate(A), np.concatenate(Y)

fig, axs = plt.subplots(2, 1, figsize=(8, 8))
A, Y = bifurkation(np.linspace(2.8, 4.0, 2401), 200)
axs[0].plot(A, Y, ",", color=(0, 0.39, 0))
axs[0].set_xlabel("a"); axs[0].set_ylabel("y_n für n > 10000")

A, Y = bifurkation(np.linspace(3.8538, 3.8541, 1501), 6000, fenster=(0.494, 0.506))
axs[1].plot(A, Y, ",", color=(0, 0.39, 0))
axs[1].set_xlabel("a"); axs[1].set_ylabel("y_n für n > 10000")
axs[1].ticklabel_format(useOffset=False)
plt.tight_layout()

a = np.array([3.2]); y = np.array([0.9])         # Beispiel a = 3.2: zwei Werte wechseln sich ab (2-Zyklus)
for _ in range(10000):
    y = a * y * (1 - y)
print(f"a = 3.2:  2-Zyklus {y[0]:.4f} <-> {a[0] * y[0] * (1 - y[0]):.4f}")
plt.show()
