# Abb. 3.9: kontinuierliches und diskretes exponentielles Wachstum (Buch, Abschnitt 3.2, Gl. 3.17)
# x(t) = e^(0.5 t) und x_n = a^n mit a = e^0.5: zu den Zeiten t = n stimmen beide überein
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
t = np.linspace(0, 6, 300); n = np.arange(7)
a = np.exp(0.5)
plt.plot(t, np.exp(0.5 * t), color=(0.43, 0.04, 0.12), lw=2, label="x(t) = e^(0.5t)")
plt.plot(n, a**n, "o", color=(0.89, 0.44, 0.49), ms=9, label=f"x_n = a^n, a = {a:.4f}")
print(f"a = e^0.5 = {a:.4f};  a^6 = {a**6:.4f},  e^3 = {np.exp(3):.4f}")
plt.xlabel("t bzw. n"); plt.ylabel("x"); plt.legend()
plt.show()
