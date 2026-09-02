## AGY for iOS Jailbreak 1.1.22-11

Adaptive rendering and streaming-efficiency update for the physically verified
AGY 1.1.22 rootless port.

### Verified on

- iPhone X (`iPhone10,3`, A11)
- iOS 16.7.11
- Dopamine rootless jailbreak

### What changed

- Uses a 4 FPS safety ticker while the TUI is idle.
- Coalesces event-driven redraws at about 11.4 FPS while typing, with measured
  21 ms median and 103 ms p95 character latency.
- Batches the 62.5 Hz desktop `textDrip` animation to one update per second,
  while preserving the original 750-unit/s reveal throughput.
- Defaults the Go scheduler to one P on A11; users can override `GOMAXPROCS`.
- Retains every terminal-harness, A11, sandbox, signing, and rootless fix from
  earlier revisions.

### Physical-device measurements

| Workload | Revision 10 / old path | Revision 11 |
| --- | ---: | ---: |
| Authenticated idle | 63.1 wakeups/s | 24.4 wakeups/s |
| Idle CPU, one-core basis | 0.42% | 0.12% |
| Complete 1,200-word response | old path reached 45,001 in 33 s | 11,143 in 45 s |

The full response finished displaying at the original aggregate reveal speed.
Fast continuous typing is still costly: a deliberately fast 20-character burst
used 1,927 wakeups (about 1,118/s for 1.72 seconds). This is transient and comes
from proprietary per-key Unicode wrapping in `PromptModel.Update`; it is not
hidden by the idle-FPS result.

Terminal-tool execution and `read_url_content` were retested successfully after
installing the final package. No new iOS resource report appeared during the
final idle, tool, web, and complete-generation tests.

### Installation

Add the repository to Sileo:

```text
https://profit155.github.io/agy-ios-repo/
```

Or install the attached DEB:

```sh
sudo dpkg -i agy_1.1.22-11_iphoneos-arm64.deb
sudo apt-get -f install
agy --version
```

### Integrity

DEB SHA-256:

```text
0b586ee455d08270871d59ebcb16e809cb760cb947f202a21efabb9fe5036c2f
```

Repository signing fingerprint:

```text
1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541
```

### Important limitations

- Unofficial experimental port; not affiliated with or supported by Google
- Continuous high-speed typing and back-to-back long generations can still
  exceed iOS's instantaneous 150-wakeups/s guideline
- `--sandbox` is unavailable because iOS has no macOS `sandbox-exec`
- Desktop browser/CDP and notebook tools are not available locally
- Use Sileo/APT for updates; the desktop self-updater is disabled
