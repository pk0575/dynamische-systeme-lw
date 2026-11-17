# Fig. 5.3: Conduction velocity and coupling (book, Section 5.2, Eq. 5.5)
# simulation of the cable equation for five values of D and the formula c = sqrt(D/(2 tin)) (1 - 3 vs)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tin, tout, topen, tclose, vgate = 0.3, 6.0, 100.0, 115.0, 0.13      # parameters in ms
hc = 4 * tin / tout
vs = (1 - np.sqrt(1 - hc)) / 2                                       # threshold for h = 1
formel = lambda D: np.sqrt(D / (2 * tin)) * (1 - 3 * vs)

def geschwindigkeit(D, dx=0.1, dt=0.01, L=60.0):
    """Fiber of length L, stimulus at the left end; c from the times at which v reaches 0.5 at 20 and 50 mm."""
    N = int(round(L / dx)) + 1; v = np.zeros(N); h = np.ones(N); reiz = dx * np.arange(N) <= 1.0
    i1, i2 = int(round(20 / dx)), int(round(50 / dx)); t1 = t2 = None; n = 0
    while t2 is None:
        lap = np.empty(N); lap[1:-1] = v[2:] - 2 * v[1:-1] + v[:-2]; lap[0] = v[1] - v[0]; lap[-1] = v[-2] - v[-1]
        dv = h * v**2 * (1 - v) / tin - v / tout + D * lap / dx**2
        if n * dt < 2.0: dv[reiz] += 0.2
        dh = np.where(v < vgate, (1 - h) / topen, -h / tclose)
        v = v + dt * dv; h = h + dt * dh; n += 1
        if t1 is None and v[i1] > 0.5: t1 = n * dt
        if t2 is None and v[i2] > 0.5: t2 = n * dt
    return 30.0 / (t2 - t1)

Ds = [0.025, 0.05, 0.1, 0.2, 0.4]
cs = [geschwindigkeit(D) for D in Ds]
for D, c in zip(Ds, cs):
    print(f"D = {D:5.3f}:  simulation c = {c:.4f},  formula c = {formel(D):.4f} mm/ms")
Dd = np.linspace(0, 0.45, 300)
plt.figure(figsize=(7, 4.5))
plt.plot(Dd, formel(Dd), color=(0, 0.447, 0.741), lw=2.5, label="formula")
plt.plot(Ds, cs, "o", color=(0.64, 0.08, 0.18), ms=8, label="simulation")
plt.xlabel("D (mm²/ms)"); plt.ylabel("c (mm/ms)"); plt.legend()
plt.show()
