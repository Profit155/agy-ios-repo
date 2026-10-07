# AGY for iOS Jailbreak

Run the **Antigravity CLI (`agy`) locally on a rootless jailbroken iPhone**.

This is an unofficial, experimental compatibility port of AGY 1.3.0 for
`iphoneos-arm64`. The agent, terminal tools,
Python, file operations, and network requests execute from the iPhone.

## Verified device

| Component | Verified configuration |
| --- | --- |
| Device | iPhone X (`iPhone10,3`, A11) |
| iOS | 16.7.11 |
| Jailbreak | Dopamine, rootless |
| Package | `com.google.antigravity-cli.rootless` |
| Port revision | `1.3.0-1` |
| Architecture | `iphoneos-arm64` |

## What works

- Interactive TUI and Google-account authentication
- Gemini, Claude, and GPT-OSS model routes
- Terminal commands, Python, stdout/stderr, exit codes, and cancellation
- Background commands and repeated process execution
- File reading, writing, replacement, directory listing, and search fallbacks
- Unicode paths and filenames containing spaces
- DNS, HTTPS/TLS, `search_web`, and `read_url_content`
- JSON, stream-JSON, JSON Schema, conversation resume, and subagents
- Image generation
- Signed APT updates without a GitHub token
- Original upstream text animation and TUI rendering

The capability list includes checks from earlier port revisions. See the
[1.3.0-1 release notes](./RELEASE_NOTES_1.3.0-1.md) for the exact current checks.

## Install with Sileo

Add this source:

```text
https://profit155.github.io/agy-ios-repo/
```

Refresh sources, search for **AGY CLI**, and install
`com.google.antigravity-cli.rootless`.

For a first-time command-line bootstrap, an unsigned trust exception is needed
only until revision `1.1.22-9` installs the repository public key:

```sh
printf '%s\n' \
  'deb [arch=iphoneos-arm64 trusted=yes] https://profit155.github.io/agy-ios-repo/ ./' \
  >/tmp/agy.list
sudo install -m 644 /tmp/agy.list /var/jb/etc/apt/sources.list.d/agy.list
rm -f /tmp/agy.list

sudo apt update
sudo apt install com.google.antigravity-cli.rootless
```

After installing `1.1.22-9` or newer, remove `trusted=yes`. Future repository
metadata is authenticated using signed `InRelease` and the key installed at:

```text
/var/jb/etc/apt/trusted.gpg.d/agy-ios-repo.gpg
```

## Direct DEB installation

Download the package from the
[latest GitHub release](https://github.com/Profit155/agy-ios-repo/releases/latest),
copy it to the iPhone, then run:

```sh
sudo dpkg -i agy_1.3.0-1_iphoneos-arm64.deb
sudo apt-get -f install
agy --version
```

Expected version output:

```text
1.3.0
```

## Update remotely

After the source is installed, the phone no longer needs a USB connection:

```sh
sudo apt update
sudo apt install --only-upgrade com.google.antigravity-cli.rootless
```

The desktop self-updater is disabled because it would replace the patched and
signed iOS executable. Always update through Sileo/APT or a newer rootless DEB.

## Known limitations

- `--sandbox` deliberately fails closed with exit code 78. AGY's upstream
  sandbox requires macOS `/usr/bin/sandbox-exec`, which does not exist on iOS.
- Desktop browser/CDP and notebook tool families are unavailable locally.
  Cloud web search and URL reading still work.
- FSEvents is unavailable; AGY uses fallback file scanning.
- The bundled macOS ripgrep cannot run on iOS; in-process/`grep` fallbacks work.
- Voice capture and clipboard-media integration are not verified.
- The headless init event may advertise upstream desktop tools that are not
  registered in the active iOS agent environment.

## Power behavior

Revision `1.3.0-1` keeps the original upstream text animation and TUI rendering
restored in `1.2.12-1` after the earlier custom throttling produced delayed or
missing text. The Go scheduler defaults to one P. On a 50×21 SSH PTY on the
verified iPhone X, settled idle measured 250.1 wakeups/s (0.82% of one core),
with zero terminal output over 20.26 seconds. A 45.36-second response interval
measured 445.8 wakeups/s (18.99% of one core), including model wait and the idle
tail after completion. These are wakeups, not watts, and are not a controlled
comparison with the prior workload/model. The idle rate remains much higher
than the older throttled `1.1.24-1` package (23.7/s).

## Repository signing key

Fingerprint:

```text
1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541
```

Public key: [`agy-ios-repo-key.gpg`](./agy-ios-repo-key.gpg)

Checksums: [`SHA256SUMS`](./SHA256SUMS)
