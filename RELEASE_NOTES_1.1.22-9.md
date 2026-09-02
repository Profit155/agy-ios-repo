## AGY for iOS Jailbreak

First fully device-verified public release of the experimental AGY 1.1.22
rootless port.

### Verified on

- iPhone X (`iPhone10,3`, A11)
- iOS 16.7.11
- Dopamine rootless jailbreak

### Highlights

- Runs AGY locally on the iPhone
- Fixes terminal-tool executable resolution on iOS
- Passes Python, shell, stderr/exit-code, cancellation, background, and
  20-process stress tests
- Supports file tools, web search, URL reading, subagents, JSON/stream-JSON,
  and image generation
- Adds signed APT metadata and token-free remote updates
- Makes unsupported `--sandbox` fail closed instead of retrying unsandboxed

### Installation

Add the repository to Sileo:

```text
https://profit155.github.io/agy-ios-repo/
```

Or download the attached DEB and install it with:

```sh
sudo dpkg -i agy_1.1.22-9_iphoneos-arm64.deb
sudo apt-get -f install
agy --version
```

### Integrity

DEB SHA-256:

```text
9b145b9cba8069e66131ee1413328af90d1e38fff77be808eef59c05118a49dd
```

Repository signing fingerprint:

```text
1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541
```

### Important limitations

- Unofficial experimental port; not affiliated with or supported by Google
- `--sandbox` is unavailable because iOS does not provide macOS
  `/usr/bin/sandbox-exec`
- Desktop browser/CDP and notebook tools are not available locally
- Use Sileo/APT for updates; the desktop self-updater is disabled

