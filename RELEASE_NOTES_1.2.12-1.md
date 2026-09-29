# AGY 1.2.12-1 for rootless iOS

Unofficial compatibility port of upstream AGY 1.2.12, tested on iPhone X (A11), iOS 16.7.11, Dopamine rootless.

- Restores upstream Bubble Tea rendering and streaming-text animation. The earlier custom FPS and text batching patches are not applied.
- Retains iOS executable/framework compatibility, A11 instruction fixes, `/var/jb` launcher, and terminal executable-path fixes.
- Disables the desktop updater; use signed Sileo/APT updates instead.
- Verified on device: interactive 50×21 TUI with a complete long streaming answer, model terminal/Python tools, web search, URL reading, and `agy --version`.

Power tradeoff: measured 248.1 wakeups/s at idle and 289.1 wakeups/s during one 45.46-second model response. This idle rate is much higher than the prior optimized 1.1.24-1 package (23.7/s). Wakeups are not watts, and generation workloads were not identical.

SHA-256 `agy_1.2.12-1_iphoneos-arm64.deb`: `9afcee0fc6670565f2ea8be5eca9c123ff98ee6957b484a6e54f4488b76e88a2`.

APT signing key fingerprint: `1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541`.
