# AGY 1.3.3-1 for rootless iOS

Unofficial port of [upstream AGY 1.3.3](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.3.3), prepared on iPhone X (A11), iOS 16.7.11, Dopamine rootless on 2026-10-11.

## Port changes

- Rebased framework paths, shell descriptors, executable-path fallback, signing, and rootless packaging onto the verified official macOS arm64 binary.
- Rewrote 1,441 unsupported RCpc instructions and 59 dot-product instructions for A11.
- Relocated and opcode-checked all nine error-producing direct/inlined `os.Executable` sites.
- Preserved upstream TUI and streaming-text animation; no custom FPS throttle or text batching is enabled.
- Preserved `GOMAXPROCS=1`, disabled desktop auto-updates, sandbox fail-closed behavior, and signed APT updates.
- Older packages remain available for rollback.

## Verified on device

- Installed package `1.3.3-1`; `agy --version` returned `1.3.3`; print help returned `SUCCESS`.
- Authenticated agent fixed and reran a failing Python test using file tools. An independent shell rerun confirmed the actual change.
- File and terminal tools handled Cyrillic, spaces, `#`, and `%` in paths; search fallback found the test marker.
- Ten terminal calls completed, including stdout/stderr with intentional exit 7 and six separate `printf` calls. No executable-path or `EMFILE` error appeared.
- Actual `read_url_content` and `search_web` calls completed. Stream-JSON returned `PORT_133_ALL_OK` with 14 completed tool steps.
- `agy plugin list` worked; a local plugin declaring a skill in `plugin.json` passed `agy plugin validate`. The fixture was not installed or enabled.
- A long Russian answer streamed on a 50x21 SSH PTY and returned to the input prompt.
- Unsupported `--sandbox` was rejected with exit 78.
- Auto-updater log confirmed it was disabled; no test AGY process or new AGY crash/wakeups report remained.

Settled idle measured 247.5 wakeups/s, 1.28% of one core, and 128.05 MB footprint over 20.30 seconds, with zero terminal output. A 45.31-second response interval measured 480.3 wakeups/s, 27.01% of one core, and 183.38 MB footprint, including model waiting. These are not controlled version comparisons, and wakeups are not watts. The port still has a high wakeup rate; the upstream timer/output fixes do not establish a major battery-efficiency gain for normal TUI use.

## Upstream changes since 1.3.0

[1.3.1](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.3.1) improves queued messages, MCP restarts, custom-agent paths, diff navigation, and narrow panels.

[1.3.2](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.3.2) adds the official plugin manager (`/plugin`, `agy plugin`), plugin configuration and persistent data, and plugin-provided MCP tools for subagents. It fixes a timer that could busy-loop on one CPU core and reduces repeated UTF-8 scanning when handling large command output. It also fixes a narrow-terminal `/resume` crash.

[1.3.3](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.3.3) adds the pinned prompt header in no-flicker mode, always-loaded MCP tool metadata, and root-level plugin `agents.json`. It fixes expired-auth refresh races, plugin skill discovery, `/add-dir` validation, subagent workspace isolation, pending approvals, and file-link anchors.

## Compatibility boundary

Desktop browser/CDP, notebook tools, voice, and remote control are not established as working locally on iOS. Plugin validation is not proof that every third-party plugin or its external dependencies runs on iOS. `--sandbox` remains unavailable and is rejected with exit code 78.

SHA-256 `agy_1.3.3-1_iphoneos-arm64.deb`: `5aa751e24bd4f3263449e0bf7022443043fbb66977398a87dd723d4f7eabdbcd`.

APT signing key fingerprint: `1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541`.
