# Fig. 2.10: Quotient of consecutive Fibonacci numbers (book, Section 2.3, Eq. 2.15)
# system j_{n+1} = e_n, e_{n+1} = e_n + j_n; the quotient e_{n+1}/e_n tends to the dominant eigenvalue (golden ratio)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

A = np.array([[0, 1],
              [1, 1]])
x = np.array([1, 0])                     # (j_0, e_0): one young pair
e = [x[1]]
for n in range(16):
    x = A @ x
    e.append(x[1])
e = np.array(e, dtype=float)
q = e[2:] / e[1:-1]
lam = np.linalg.eigvals(A)
print("eigenvalues of A:", "  ".join(f"{x:.6f}" for x in sorted(np.real(lam))))
print("e_{n+1}/e_n:", "  ".join(f"{x:.6f}" for x in q[-4:]), "  golden ratio:", f"{(1 + 5**0.5) / 2:.6f}")

n = np.arange(1, len(q) + 1)
plt.plot(n, q, "o--", color=(0.64, 0.08, 0.18), label="e_{n+1}/e_n")
plt.axhline((1 + 5**0.5) / 2, color="k", ls="--", lw=0.8, label="λ_1 ≈ 1.618")
plt.xlabel("n"); plt.legend()
plt.show()
