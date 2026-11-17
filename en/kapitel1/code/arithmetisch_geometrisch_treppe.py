# Fig. 1.12: Update functions and staircase diagrams (book, Section 1.2)
# left: arithmetic sequence f(x) = x + 2 with x_0 = 20;  right: geometric sequence f(x) = a x with a = 1.2 and 0.5, x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

blau, rot = (0, 0.447, 0.741), (0.64, 0.08, 0.18)

def treppe(ax, f, x0, N, farbe):
    x = [x0]
    for _ in range(N):
        x.append(f(x[-1]))
    px, py = [x[0]], [0]
    for k in range(N):
        px += [x[k], x[k + 1]]; py += [x[k + 1], x[k + 1]]
    ax.plot(px, py, "--", color=farbe)
    return x

fig, axs = plt.subplots(1, 2, figsize=(10, 4.8))
ax = axs[0]
xx = np.array([18, 33])
ax.plot(xx, xx + 2, color=blau, label="f(x) = x + 2")
ax.plot(xx, xx, "k", lw=0.8, label="y = x")
x = treppe(ax, lambda v: v + 2, 20, 6, rot)
print("arithmetic:", "  ".join(str(v) for v in x))
ax.set_xlim(18, 33); ax.set_ylim(18, 33); ax.set_xlabel("x"); ax.set_ylabel("f(x)"); ax.legend()

ax = axs[1]
xx = np.array([0, 2.6])
for a, farbe, N in [(1.2, rot, 5), (0.5, (0.89, 0.44, 0.49), 4)]:
    ax.plot(xx, a * xx, color=blau if a > 1 else (0.45, 0.70, 0.90), label=f"f(x) = {a} x")
    x = treppe(ax, lambda v, a=a: a * v, 1.0, N, farbe)
    print(f"geometric a = {a}:", "  ".join(f"{v:.4f}" for v in x))
ax.plot(xx, xx, "k", lw=0.8, label="y = x")
ax.set_xlim(0, 2.6); ax.set_ylim(0, 2.6); ax.set_xlabel("x"); ax.set_ylabel("f(x)"); ax.legend()
plt.tight_layout()
plt.show()
