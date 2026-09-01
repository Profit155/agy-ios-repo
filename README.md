# Private AGY APT source

Private flat APT repository for the rootless `iphoneos-arm64` AGY package.
It is intended for the `Profit155` account and is served directly from the
private GitHub repository over HTTPS.

## Add the source on the iPhone

GitHub deliberately returns `404` for this repository without authentication.
Create a fine-grained personal access token restricted to only
`Profit155/agy-ios-repo`, with **Contents: Read-only**. Do not reuse a broad
GitHub CLI or account token.

In NewTerm, store the token in APT's protected authentication file. The token
is entered without echo and is not included in the source URL:

```sh
printf 'GitHub token: '
stty -echo
IFS= read -r GH_TOKEN
stty echo
printf '\n'

printf 'machine raw.githubusercontent.com/Profit155/agy-ios-repo login Profit155 password %s\n' "$GH_TOKEN" > /tmp/agy-github.conf
unset GH_TOKEN
sudo mkdir -p /var/jb/etc/apt/auth.conf.d
sudo install -m 600 /tmp/agy-github.conf /var/jb/etc/apt/auth.conf.d/agy-github.conf
rm -f /tmp/agy-github.conf

printf '%s\n' 'deb [arch=iphoneos-arm64 trusted=yes] https://raw.githubusercontent.com/Profit155/agy-ios-repo/main/ ./' > /tmp/agy.list
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

The same source will appear in Sileo after its sources are refreshed. If the
fine-grained token expires, replace only
`/var/jb/etc/apt/auth.conf.d/agy-github.conf`.

## Publish a new package from Windows

Generate the patched DEB in `agy-ios-port`, then run:

```powershell
cd C:\Users\User\Desktop\jail\agy-ios-repo
.\Publish-Package.ps1 -DebPath '..\agy-ios-port\dist\agy_1.1.22-7_iphoneos-arm64.deb'
git add Packages Packages.gz Release debs
git commit -m 'Publish AGY 1.1.22-7'
git push
```

APT chooses the highest Debian package version listed in `Packages`, so later
revisions can coexist in `debs/`.
