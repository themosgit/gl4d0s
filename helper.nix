{ pkgs }:
pkgs.writeShellScriptBin "ergatis" ''
  ${pkgs.bubblewrap}/bin/bwrap \
    --ro-bind /nix /nix \
    --ro-bind /run/current-system /run/current-system \
    --ro-bind /etc/resolv.conf /etc/resolv.conf \
    --ro-bind /etc/ssl /etc/ssl \
    --ro-bind /etc/hosts /etc/hosts \
    --ro-bind /etc/passwd /etc/passwd \
    --ro-bind /etc/group /etc/group \
    --bind "$PWD" "$PWD" \
    --tmpfs "$HOME/.config" \
    --chdir "$PWD" \
    --proc /proc \
    --dev /dev \
    --tmpfs /tmp \
    --share-net \
    --die-with-parent \
    ${pkgs.claude-code}/bin/claude "$@"
''
