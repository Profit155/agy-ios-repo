# AGY for iOS Jailbreak

Run the **Antigravity CLI (`agy`) locally on a rootless jailbroken iPhone**.

This is an unofficial, experimental compatibility port of AGY 1.4.7 for
`iphoneos-arm64`. The agent, terminal tools,
Python, file operations, and network requests execute from the iPhone.

## Verified device

| Component | Verified configuration |
| --- | --- |
| Device | iPhone X (`iPhone10,3`, A11) |
| iOS | 16.7.11 |
| Jailbreak | Dopamine, rootless |
| Package | `com.google.antigravity-cli.rootless` |
| Port revision | `1.4.7-2` |
| Architecture | `iphoneos-arm64` |

## What works

- Interactive TUI and Google-account authentication
- Gemini, Claude, and GPT-OSS model routes
- Terminal commands, Python, stdout/stderr, exit codes, and cancellation
- Background commands and repeated process execution
- File reading, writing, replacement, directory listing, and search fallbacks
- Unicode paths and filenames containing spaces
- DNS, HTTPS/TLS, `search_web`, and optional local MCP URL reading
- JSON, stream-JSON, JSON Schema, conversation resume, and subagents
- Image generation
- Signed APT updates without a GitHub token
- Original upstream text animation and TUI rendering

The capability list includes checks from earlier port revisions. See the
[1.4.7-2 release notes](./RELEASE_NOTES_1.4.7-2.md) for the current URL-reader checks
and [1.4.7-1](./RELEASE_NOTES_1.4.7-1.md) for the underlying port validation.

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
sudo dpkg -i agy_1.4.7-2_iphoneos-arm64.deb
sudo apt-get -f install
agy --version
```

Expected version output:

```text
1.4.7
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
  Cloud web search and terminal HTTPS still work.
- Native `read_url_content` is advertised in init but was not callable by the
  tested 1.4.7 harness. Revision 1.4.7-2 bundles an optional local MCP replacement;
  enable it with `agy mcp add --type stdio ios-web /var/jb/usr/bin/python3 /var/jb/usr/share/agy/url_reader.py`.
  This is a separate tool, not a repair of the built-in reader.
- FSEvents is unavailable; AGY uses fallback file scanning.
- The bundled macOS ripgrep cannot run on iOS; in-process/`grep` fallbacks work.
- Voice capture and clipboard-media integration are not verified.
- The headless init event may advertise upstream desktop tools that are not
  registered in the active iOS agent environment.

## Power behavior

Revision `1.4.7-1` keeps the original upstream text animation and TUI rendering;
custom FPS/text batching remains disabled. The Go scheduler defaults to one P.
Same-day settled-idle spot checks on the verified iPhone X, using a 50x21 SSH
PTY and zero terminal output, measured:

| Version | Wakeups/s | CPU, one core | Sample |
| --- | ---: | ---: | ---: |
| 1.3.3-1, before upgrade | 245.8 | 1.28% | 20.31 s |
| 1.4.7-1 | 16.7 | 0.10% | 20.28 s |

Idle wakeups decreased by about 93% in these samples. This is consistent with
upstream's idle rendering changes, but is not a battery-life multiplier or a
controlled response-generation benchmark. Wakeups are not watts.

An active 45.31-second thinking/wait interval measured 394.2 wakeups/s and
5.09% of one core. The long answer was still in progress and the probe canceled
it; this is not a completed-response comparison. A separate short Russian
answer streamed completely and returned to input on the same terminal.

## Repository signing key

Fingerprint:

```text
1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541
```

Public key: [`agy-ios-repo-key.gpg`](./agy-ios-repo-key.gpg)

Checksums: [`SHA256SUMS`](./SHA256SUMS)
