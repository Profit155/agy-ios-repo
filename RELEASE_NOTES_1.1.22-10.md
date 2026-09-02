## AGY for iOS Jailbreak 1.1.22-10

Power-efficiency update for the physically verified AGY 1.1.22 rootless port.

### Verified on

- iPhone X (`iPhone10,3`, A11)
- iOS 16.7.11
- Dopamine rootless jailbreak

### What changed

- Reduces Bubble Tea's unconditional renderer ticker from the desktop default
  of 60 FPS to an iOS-specific 10 FPS (100 ms maximum frame interval).
- Drops steady authenticated-welcome-screen activity from about 479 to 63.1
  interrupt wakeups/s, below iOS's 150 wakeups/s resource limit.
- Drops steady CPU use to about 0.42% of one core in the measured interval.
- Keeps agent networking, terminal tools, model updates, and print mode at
  their original rates.
- Retains all `1.1.22-9` terminal-harness, A11, sandbox, signing, and rootless
  compatibility fixes.

The previous iOS resource reports recorded 594, 1,477 and 1,683 wakeups/s.
Their microstackshots converged on Bubble Tea rendering, `ConversationModel.View`
and Go garbage collection. A 90-second patched TUI test created no new
`wakeups_resource` report, and a live terminal-tool model call passed afterward.

### Installation

Add the repository to Sileo:

```text
https://profit155.github.io/agy-ios-repo/
```

Or install the attached DEB:

```sh
sudo dpkg -i agy_1.1.22-10_iphoneos-arm64.deb
sudo apt-get -f install
agy --version
```

### Integrity

DEB SHA-256:

```text
243e0d2e43396f83fe2681d453c5ba131b6cb9def1318e342e777fd11c3f12e3
```

Repository signing fingerprint:

```text
1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541
```

### Important limitations

- Unofficial experimental port; not affiliated with or supported by Google
- `--sandbox` is unavailable because iOS has no macOS `sandbox-exec`
- Desktop browser/CDP and notebook tools are not available locally
- Use Sileo/APT for updates; the desktop self-updater is disabled
