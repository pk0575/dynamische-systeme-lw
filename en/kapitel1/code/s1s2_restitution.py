# Fig. 1.39: S1-S2 protocol and restitution curve (book, Section 1.6, Eq. 1.48)
# left: periodic stimulation (S1, PCL = 400 ms) is followed by a stimulus S2 after a shorter or longer interval
# right: measured pairs (DI, APD) and restitution curve r(DI) = 220 - 180 exp(-DI/60)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

tin, tout, topen, tclose, vgate, vref = 0.3, 6.0, 100.0, 115.0, 0.13, 0.1
dt = 0.01

def simuliere(reize, T):
    t = np.arange(0, T, dt); v = np.zeros_like(t); vv, h = 0.0, 1.0
    for i in range(1, len(t)):
        J = 0.2 if any(s <= t[i] < s + 2.0 for s in reize) else 0.0
        dv = h * vv**2 * (1 - vv) / tin - vv / tout + J
        dh = (1 - h) / topen if vv < vgate else -h / tclose
        vv += dt * dv; h += dt * dh; v[i] = vv
    return t, v

fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for tS2, farbe in [(300.0, (0.43, 0.04, 0.12)), (430.0, (0.89, 0.44, 0.49))]:
    t, v = simuliere([0, 400, 800, 800 + tS2], 1600)
    m = t >= 760
    axs[0].plot(t[m] - 800, v[m], color=farbe, label=f"S2 at {tS2:.0f} ms")
    s = np.sign(v - vref); kreuz = t[np.where(np.diff(s) != 0)[0]] - 800
    ende_s1 = kreuz[(kreuz > 50) & (kreuz < tS2)][0]                  # end of the last S1 action potential
    ende_s2 = kreuz[kreuz > tS2 + 20][0]                               # end of the S2 action potential
    print(f"S2 at {tS2:.0f} ms:  DI = {tS2 - ende_s1:.1f} ms,  APD = {ende_s2 - tS2:.1f} ms")
axs[0].axhline(vref, color="0.35", ls=":")
axs[0].set_xlabel("t (ms)"); axs[0].set_ylabel("v"); axs[0].legend()

r = lambda DI: 220 - 180 * np.exp(-DI / 60)
daten = np.array([[60, 150], [80, 178], [100, 182], [120, 190], [140, 198], [160, 204], [180, 208],
                  [200, 214], [220, 214], [240, 219], [260, 212], [280, 223]])          # (DI, APD) in ms
DI = np.linspace(50, 300, 300)
axs[1].plot(DI, r(DI), color=(0, 0.447, 0.741), label="r(DI) = 220 - 180 exp(-DI/60)")
axs[1].plot(daten[:, 0], daten[:, 1], "ko", label="S1-S2 data")
axs[1].set_xlabel("DI (ms)"); axs[1].set_ylabel("APD (ms)"); axs[1].legend(loc="lower right")
plt.tight_layout()
plt.show()
