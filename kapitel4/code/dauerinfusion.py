# Abb. 4.12: Dauerinfusion (Buch, Abschnitt 4.2, Gl. 4.11)
# dm/dt = -ka m,  db/dt = ka m - ke b + u  mit u = 1 mg pro Stunde, m(0) = b(0) = 0:  b(t) = (u/ke)(1 - e^(-ke t)), b* = u/ke = 5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
ke, u = 0.2, 1
t = np.linspace(0, 30, 600)
b = u / ke * (1 - np.exp(-ke * t))
for tt in [5, 10, 20, 30]:
    print(f"t = {tt:2d} h: b = {u / ke * (1 - np.exp(-ke * tt)):.3f} mg")
plt.axhline(u / ke, color="k", ls="--", lw=1)
plt.plot(t, b, color=(0.64, 0.08, 0.18), lw=2.5, label="Blut b(t)")
plt.xlabel("t (Stunden)"); plt.ylabel("Wirkstoff (mg)"); plt.ylim(0, 6); plt.legend(loc="lower right")
plt.show()
