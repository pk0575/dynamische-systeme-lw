# Abb. 2.13: dominanter Eigenwert des Leslie-Modells in Abhängigkeit von b_2 (Buch, Abschnitt 2.3, Gl. 2.19)
# b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; bei R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, also b_2 = 4.6, ist lambda_1 = 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

b2 = np.linspace(0, 10, 201)
lam = [max(abs(np.linalg.eigvals(np.array([[0, b, 9], [0.1, 0, 0], [0, 0.6, 0]])))) for b in b2]
R = 0.1 * b2 + 0.1 * 0.6 * 9                    # Nettoreproduktionszahl
print(f"b_2 mit R = 1: {(1 - 0.54) / 0.1:.2f}")
print(f"lambda_1 bei b_2 = 4.6: {max(abs(np.linalg.eigvals(np.array([[0, 4.6, 9], [0.1, 0, 0], [0, 0.6, 0]])))):.6f}")

plt.plot(b2, lam, color=(0, 0.447, 0.741))
plt.axhline(1, color="k", lw=0.8); plt.axvline(4.6, color="k", ls=":")
plt.xlabel("b_2"); plt.ylabel("λ_1")
plt.show()
