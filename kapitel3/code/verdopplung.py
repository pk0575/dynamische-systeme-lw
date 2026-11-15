# Abb. 3.10: Wachstum von E. coli mit der Verdopplungszeit 20 Minuten (Buch, Abschnitt 3.2, Gl. 3.18)
# x(t) = 1000 · 2^(t/20) = 1000 e^(r t) mit r = ln(2)/20 pro Minute
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tV, x0 = 20, 1000
r = np.log(2) / tV
t = np.linspace(0, 120, 300)
plt.plot(t, x0 * np.exp(r * t), color=(0.64, 0.08, 0.18), lw=2.5)
for k in range(1, 7):
    plt.plot([tV * k, tV * k], [0, x0 * 2**k], ":", color="0.5"); plt.plot(tV * k, x0 * 2**k, "ko")
print(f"r = ln(2)/20 = {r:.5f} pro Minute;  x(120) = {x0 * np.exp(r * 120):.0f} Zellen")
plt.xlabel("t (min)"); plt.ylabel("Zellen"); plt.xticks(range(0, 121, 20))
plt.show()
