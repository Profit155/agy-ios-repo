## AGY for iOS Jailbreak 1.1.24-1

Rebase of the physically verified rootless port onto Google's official AGY
1.1.24 Apple Silicon binary.

### Verified on

- iPhone X (`iPhone10,3`, A11)
- iOS 16.7.11
- Dopamine rootless jailbreak

### What changed

- Retains all rootless, A11, terminal-harness, adaptive-rendering, signing, and
  package-update patches from 1.1.22-11.
- Includes upstream 1.1.24 fixes for inaccessible startup directories and
  close-on-exec handling of preserved streams.
- Includes upstream MCP JSONC parsing and agent/UI state fixes.
- Extends the physical energy test helper to type UTF-8 probes.

### Physical-device results

| Workload | Result |
| --- | ---: |
| Authenticated idle, 30.27 s | 23.7 wakeups/s, 0.14% CPU |
| English typing, 20 characters | 946.1 wakeups/s, 89 ms p95 |
| Russian typing, 23 characters | 1,082.2 wakeups/s, 96 ms p95 |
| Complete generation, 45.26 s | 325.2 wakeups/s, 41.3% CPU |

Terminal execution, Python, and `read_url_content` passed after installing the
final package. Ten full AGY starts and 20 separate terminal-tool child-process
launches completed without `EMFILE`; no process or new iOS resource/crash report
was left behind.

The generation workload is heavier than the measured AGY 1.1.22-11 path
(246.2 wakeups/s), while idle behavior is unchanged or slightly better. Fast
typing remains an upstream `PromptModel.Update` hot path. A binary-only shortcut
was not shipped: it saved only 3.3% wakeups and risked incorrect complex-Unicode
cursor widths.

### Installation

Add the repository to Sileo:

```text
https://profit155.github.io/agy-ios-repo/
```

Or install the attached DEB:

```sh
sudo dpkg -i agy_1.1.24-1_iphoneos-arm64.deb
sudo apt-get -f install
agy --version
```

### Integrity

DEB SHA-256:

```text
876f5c6d8d10e15b6f98c6986d2b4c645c59a7a920dbd566f253a98679f2dbfe
```

Repository signing fingerprint:

```text
1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541
```

### Important limitations

- Unofficial experimental port; not affiliated with or supported by Google
- Continuous high-speed typing and back-to-back long generations can exceed
  iOS's instantaneous 150-wakeups/s guideline
- `--sandbox` is unavailable because iOS has no macOS `sandbox-exec`
- Desktop browser/CDP and notebook tools are not available locally
- Use Sileo/APT for updates; the desktop self-updater is disabled
