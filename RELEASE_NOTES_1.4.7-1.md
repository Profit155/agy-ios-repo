# AGY 1.4.7-1 for rootless iOS

Unofficial compatibility port of [AGY 1.4.7](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.7), released upstream on 2026-10-24. Prepared for iPhone X (A11), iOS 16.7.11, Dopamine rootless on 2026-10-25.

## Port changes

- Rebased framework paths, shell descriptors, signing, launcher, and rootless packaging onto the hash-verified macOS arm64 binary.
- Rewrote 1,441 unsupported RCpc instructions and 57 SDOT/UDOT instructions for A11.
- Extended the executable-path fallback to eleven CBZ sites, including the new Go command runner and performance recorder. A near-header stub handles the larger binary's branch range.
- Compacted seven verified straight-line DOT blocks and used verified executable padding, without moving segments or changing model/renderer behavior.
- Fixed the previous single-vector scratch spill/restore encoding. Unicorn tests compare all vector/integer registers, stack balance, and flags against reference arithmetic: 432 DOT-block cases and 22 executable-path cases pass.
- Kept upstream rendering and streaming animation; no custom FPS throttle or text batching. Kept `GOMAXPROCS=1`, disabled desktop auto-updates, sandbox fail-closed checks, and signed APT updates.

## Device checks and power

- Installed `1.4.7-1`; version/help and authenticated model calls work.
- The agent fixed a failing Python test with `read_file`/`edit_file`; an independent rerun confirmed the real change. Cyrillic/spaces/`#`/`%` paths, stdout/stderr plus exit 7, six separate `printf` calls, and `search_web` passed. Repeated commands did not produce `EMFILE` or executable-path errors.
- `agy plugin list --json` returned an empty list; a local one-skill fixture passed JSON validation with zero findings. No plugin was installed or enabled.
- A short Russian answer streamed on a 50x21 TUI, displayed its end marker, and returned to input in 22.20 seconds.
- The auto-updater was confirmed disabled; no test AGY process or new AGY crash/wakeups report remained.
- Native `read_url_content` was not callable by the tested harness despite appearing in init. The broad test timed out while the model over-investigated it, so it is not a complete-suite success. A bounded recheck used exactly one terminal Python HTTPS call, validated TLS, returned HTTP 200 and the expected title, and completed with `WEB_147_RECHECK_OK`. Native URL reading is not claimed as working.

Same-day idle spot checks on the same iPhone/50x21 PTY with `GOMAXPROCS=1` and no terminal output: 1.3.3-1 used 245.8 wakeups/s and 1.28% of one core; 1.4.7-1 used 16.7/s and 0.10%. This is about 93% fewer idle wakeups, not a battery-life multiplier. No custom FPS/animation patch is enabled.

One 45.31-second active thinking/wait interval used 394.2 wakeups/s, 5.09% of one core, and 152.25 MB footprint. The 600-word answer was unfinished and was canceled by the probe; do not compare this to prior completed-response samples.

## Upstream changes since 1.3.3

- [1.3.5](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.3.5): Auto mode, manual `/compact`, syntax-highlighted and folding diffs. Auto mode depends on account/platform support; it is not established as usable on iOS.
- [1.4.3](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.3): fixes for Unicode/emoji cursor movement, clipped prompts, empty file creation, compaction/subagent bookkeeping, and Gemini 4 Argon discovery with API keys.
- [1.4.4](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.4): cached streamed Markdown/code rendering, fewer blank gaps around the prompt, plugin/MCP fixes, and improved diffs.
- [1.4.5](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.5): pauses screen refreshes when nothing changes, skips redundant streaming updates, and reduces startup/conversation CPU and text-input allocations. Upstream's idle CPU reduction is not an iPhone battery measurement.
- [1.4.6](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.6): Unicode cursor fixes, retained attachments after compaction, clearer model-retry status, plugin setup/validation, and fixes for oversized terminal arguments.
- [1.4.7](https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.7): lower headless `-p` CPU use, faster streaming/prompt/resize rendering, hook `lastUserInput`, fewer repeated compactions, and link/copy fixes. The seasonal theme remains opt-in and is not enabled by this port.

## Compatibility boundary

The sandbox requires macOS `sandbox-exec` and is still rejected with exit 78. Desktop browser/CDP, notebooks, voice, remote control, and third-party plugin/MCP dependencies are not newly validated as local iOS features. The tested account reports Auto mode unavailable and falls back to the default mode; no Auto-mode command execution is claimed.

DEB SHA-256: `de41ead6f707277dfa996dbe326191a6fef6049e8e5950a200439542594c8535`.
