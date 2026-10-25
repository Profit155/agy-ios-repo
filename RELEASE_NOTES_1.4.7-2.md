# AGY 1.4.7-2 for rootless iOS

Adds an optional **local MCP URL reader** to AGY 1.4.7. It executes on the
iPhone and is separate from Google's built-in reader, which remains
unavailable in the tested harness. Rendering, the main binary and performance
settings are unchanged from 1.4.7-1.

After updating, run once as your normal AGY user:

```sh
agy mcp add --type stdio ios-web /var/jb/usr/bin/python3 /var/jb/usr/share/agy/url_reader.py
```

Ask AGY to read a public URL using the `ios-web` MCP tool. It extracts static
HTML/text, supports gzip/deflate, verifies HTTPS certificates and follows up to
five redirects. JavaScript pages, PDFs and authenticated/private sites are not
supported. Requests have a 20-second budget and output is capped at 8,000 UTF-8
bytes. No background polling is added. Python 3 is now a package dependency.

Tested on iPhone X A11 / iOS 16.7.11 / Dopamine: direct HTTPS reads of
Example.com and Python.org; localhost rejection; actual AGY invocation of
`mcp_ios-web_read_url_content`, returning HTTP 200, `Example Domain` and
`local-ios-mcp`. Six host regression tests passed. Package version/help passed.
This is not a full rerun of every AGY feature.

Disable: `agy mcp disable ios-web`. Remove configuration: `agy mcp remove ios-web`.
Updating the package does not register a server or rewrite user settings.

DEB SHA-256:
`e715503d4eafe84af9443d14a7e64370942a2fdb50e7ee06cf7f80fb2a501831`.
