# AGY APT source

Signed flat APT repository for the rootless `iphoneos-arm64` AGY package,
served directly from GitHub over HTTPS. The repository signing fingerprint is
`1DF0 6A15 2EC4 BE9D AF2D F318 0B80 5B0C 8D42 0541`.

## Add the source on the iPhone

No GitHub token is required. Package revision `1.1.22-9` and later installs the
repository public key automatically. For the initial bootstrap in NewTerm run:

```sh
printf '%s\n' 'deb [arch=iphoneos-arm64 trusted=yes] https://profit155.github.io/agy-ios-repo/ ./' > /tmp/agy.list
sudo install -m 644 /tmp/agy.list /var/jb/etc/apt/sources.list.d/agy.list
rm -f /tmp/agy.list

sudo apt update
sudo apt install com.google.antigravity-cli.rootless
```

After `1.1.22-9` is installed, remove `trusted=yes` from the source. Future
refreshes are authenticated by `InRelease` and the installed public key at
`/var/jb/etc/apt/trusted.gpg.d/agy-ios-repo.gpg`.

After this one-time setup, upgrades need no USB connection:

```sh
sudo apt update
sudo apt install --only-upgrade com.google.antigravity-cli.rootless
```

The same source will appear in Sileo after its sources are refreshed. It can
also be added there directly with this URL:

```text
https://profit155.github.io/agy-ios-repo/
```

## Publish a new package from Windows

Generate the patched DEB in `agy-ios-port`, then run:

```powershell
cd C:\Users\User\Desktop\jail\agy-ios-repo
.\Publish-Package.ps1 -DebPath '..\agy-ios-port\dist\agy_1.1.22-9_iphoneos-arm64.deb'
git add Packages Packages.gz Release InRelease Release.gpg agy-ios-repo-key.* debs
git commit -m 'Publish AGY 1.1.22-9'
git push
```

The signing script reads the private key only from
`%USERPROFILE%\.agy-ios-repo\gnupg` (or `AGY_REPO_GNUPGHOME`). Never add that
directory or an exported private key to this repository.

APT chooses the highest Debian package version listed in `Packages`, so later
revisions can coexist in `debs/`.
