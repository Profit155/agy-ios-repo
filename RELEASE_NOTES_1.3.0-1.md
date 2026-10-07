# AGY 1.3.0-1 for rootless iOS

Unofficial port of [upstream AGY 1.3.0](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.3.0), tested on iPhone X (A11), iOS 16.7.11, Dopamine rootless on 2026-10-07.

## Port changes

- Rebased framework paths, shell descriptors, signing, and rootless packaging onto the official macOS arm64 binary.
- Rewrote 1,447 unsupported RCpc instructions and 59 dot-product instructions for A11.
- Expanded the `os.Executable` path fallback to nine known direct/inlined reads, including command escaping and remote-control startup.
- Preserved upstream TUI and streaming-text animation, `GOMAXPROCS=1`, disabled desktop auto-updates, and signed APT updates.

## Verified on device

- `agy --version` returned `1.3.0`; package status is `install ok installed 1.3.0-1 iphoneos-arm64`.
- Print-mode help, authenticated model use, and stream-JSON output completed.
- AGY observed an intentionally failing Python test, read and edited `calc.py`, and reran the test successfully. An independent shell rerun confirmed the file actually changed.
- Terminal commands and search fallback worked in a project path containing Cyrillic text, spaces, `#`, and `%`.
- A command produced both stdout and stderr with an intentional exit code of 7. Six further separate terminal-tool calls succeeded; no `EMFILE` or executable-path error appeared.
- `read_url_content` and `search_web` completed through the actual agent.
- A complete long Russian answer streamed on a 50×21 SSH PTY and returned to the prompt.
- Requesting the unsupported macOS sandbox was rejected by the launcher with exit code 78.

Settled idle on the 50×21 terminal measured 250.1 wakeups/s, 0.82% of one core, and 119.19 MB footprint over 20.26 seconds, with zero terminal output. One 45.36-second streaming-answer sample (including model wait and the idle tail after completion) measured 445.8 wakeups/s, 18.99% of one core, and 177.27 MB physical footprint. This is not a controlled comparison with prior releases, and wakeups are not watts. No new AGY crash/wakeups report appeared during these checks, and the test processes exited.

## Upstream behavior changes

The default verbosity is now `medium`, which groups tool calls and thoughts. Choose `/config` → `Verbosity` → `high` to see all details. Upstream also fixes SSH/tmux scrolling and file paths with special characters, and changes `j`/`k` navigation in `/diff`.

Desktop browser/CDP, notebook tools, voice, and the remote-control service are not established as working locally on iOS. The path fallback alone does not provide the missing desktop components.

SHA-256 `agy_1.3.0-1_iphoneos-arm64.deb`: `3323f0a1a57e03b883684b1284ccce9eb5b636f994f234f35c2f83a5d3239415`.

APT signing key fingerprint: `1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541`.
