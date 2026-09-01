# AGY APT source

Flat APT repository for the rootless `iphoneos-arm64` AGY package, served
directly from GitHub over HTTPS.

## Add the source on the iPhone

No GitHub token is required. In NewTerm run:

```sh
printf '%s\n' 'deb [arch=iphoneos-arm64 trusted=yes] https://profit155.github.io/agy-ios-repo/ ./' > /tmp/agy.list
sudo install -m 644 /tmp/agy.list /var/jb/etc/apt/sources.list.d/agy.list
rm -f /tmp/agy.list

sudo apt update
sudo apt install com.google.antigravity-cli.rootless
```

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
.\Publish-Package.ps1 -DebPath '..\agy-ios-port\dist\agy_1.1.22-8_iphoneos-arm64.deb'
git add Packages Packages.gz Release debs
git commit -m 'Publish AGY 1.1.22-8'
git push
```

APT chooses the highest Debian package version listed in `Packages`, so later
revisions can coexist in `debs/`.
