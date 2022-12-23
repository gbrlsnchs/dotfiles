# bindkey -v # This enables Vim mode.
bindkey -e

# History navigation.
bindkey "^P" up-line-or-history    # Ctrl-P
bindkey "^N" down-line-or-history  # Ctrl-N
bindkey "^[[A" up-line-or-search   # Arrow up
bindkey "^[[B" down-line-or-search # Arrow down
bindkey "^[[H" beginning-of-line   # Home
bindkey "^[[F" end-of-line         # End
bindkey "^[[3~" delete-char        # Delete
