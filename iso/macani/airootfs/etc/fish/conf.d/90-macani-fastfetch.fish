# Print system information once in an interactive local shell. Never emit output
# in scripts, non-interactive SSH sessions, or nested shells.
if status --is-interactive; and not set -q MACANI_NO_FASTFETCH; and not set -q MACANI_FASTFETCH_SHOWN; and not set -q SSH_CONNECTION; and not set -q SSH_TTY; and type -q fastfetch
    set -gx MACANI_FASTFETCH_SHOWN 1
    if set -q KITTY_WINDOW_ID
        fastfetch --config /etc/fastfetch/macani-kitty.jsonc
    else
        fastfetch --config /etc/fastfetch/macani-fallback.jsonc
    end
end
