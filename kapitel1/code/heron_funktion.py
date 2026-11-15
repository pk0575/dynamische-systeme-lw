# Abb. 1.7: Aktualisierungsfunktion des Heron-Verfahrens (Buch, Abschnitt 1.1, Gl. 1.4)
# f(x) = (x + 2/x)/2 und erster Schritt x_0 = 0.5 -> x_1 = f(x_0)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

f = lambda x: 0.5 * (x + 2 / x)
x0 = 0.5
x1 = f(x0)
print(f"x_0 = {x0},  x_1 = f(x_0) = {x1}")       # x_1 = 2.25

x = np.linspace(0.16, 4.3, 400)
plt.plot(x, f(x), color=(0, 0.447, 0.741), label="f(x) = (x + 2/x)/2")
plt.plot([x0, x0, 0], [0, x1, x1], "--", color=(0.64, 0.08, 0.18))   # hoch zur Kurve, dann zur y-Achse
plt.plot([x0, 0], [0, x1], "o", color=(0.64, 0.08, 0.18))
plt.xlim(0, 4.3); plt.ylim(0, 6.5)
plt.xlabel("x"); plt.ylabel("f(x)"); plt.legend()
plt.show()
