# Fig. 2.13: Dominant eigenvalue of the Leslie model as a function of b_2 (book, Section 2.3, Eq. 2.19)
# b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; for R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, i.e. b_2 = 4.6, lambda_1 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

b2 = np.linspace(0, 10, 201)
lam = [max(abs(np.linalg.eigvals(np.array([[0, b, 9], [0.1, 0, 0], [0, 0.6, 0]])))) for b in b2]
R = 0.1 * b2 + 0.1 * 0.6 * 9                    # net reproductive number
print(f"b_2 with R = 1: {(1 - 0.54) / 0.1:.2f}")
print(f"lambda_1 at b_2 = 4.6: {max(abs(np.linalg.eigvals(np.array([[0, 4.6, 9], [0.1, 0, 0], [0, 0.6, 0]])))):.6f}")

plt.plot(b2, lam, color=(0, 0.447, 0.741))
plt.axhline(1, color="k", lw=0.8); plt.axvline(4.6, color="k", ls=":")
plt.xlabel("b_2"); plt.ylabel("λ_1")
plt.show()
