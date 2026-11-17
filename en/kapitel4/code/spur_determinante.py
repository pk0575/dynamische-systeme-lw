# Fig. 4.11: Trace-determinant plane (book, Section 4.2)
# The trace T and the determinant det A of a 2x2 matrix determine the type and stability of the origin; gray: stable
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
matrizen = {"Ex. 1": [[-2, 1], [1, -2]], "Ex. 2": [[-1, 2], [-2, -1]], "Ex. 3": [[0, -2], [2, 0]], "PK": [[-1, 0], [1, -0.2]]}
T = np.linspace(-5, 5, 400)
plt.fill_between([-5, 0], 0, 7.5, color="0.9", label="stable")
plt.plot(T, T**2 / 4, color=(0, 0.447, 0.741), lw=2.5, label="det A = T²/4")
plt.axhline(0, color="k", lw=1); plt.axvline(0, color="k", lw=1)
for name, A in matrizen.items():
    A = np.array(A); Sp, De = np.trace(A), np.linalg.det(A)
    if De < 0: typ = "saddle"
    elif Sp == 0: typ = "center"
    elif Sp**2 >= 4 * De: typ = "node"
    else: typ = "spiral"
    print(f"{name}: trace = {Sp:4.1f},  det A = {De:4.1f}  -> {typ}" + (", stable" if Sp < 0 and De > 0 else ""))
    plt.plot(Sp, De, "ko"); plt.text(Sp + 0.15, De + 0.2, name)
for x, y, txt in [(-3.3, 0.9, "stable node"), (-3.6, 6.2, "stable spiral"), (3.3, 0.9, "unstable node"),
                  (2.2, 5.6, "unstable spiral"), (2.2, -1.5, "saddle")]:
    plt.text(x, y, txt, ha="center")
plt.xlim(-5, 5); plt.ylim(-2.5, 7.5); plt.xlabel("trace T"); plt.ylabel("Determinant det A"); plt.legend(loc="lower left")
plt.show()
