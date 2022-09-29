# Directories {{{
#
# Development directories
abbr -a dev cd $HOME/Development
abbr -a zdev cd $HOME/Development/Zig
abbr -a cdev cd $HOME/Development/Clang
abbr -a edev cd $HOME/Development/Elixir
abbr -a pydev cd $HOME/Development/Python
abbr -a nodev cd $HOME/Development/Node
# abbr -a hskdev cd $HOME/Development/Haskell
abbr -a miscdev cd $HOME/Development/Misc
abbr -a nvimdev cd $HOME/Development/Nvim
# abbr -a rustdev cd $HOME/Development/Rust
# }}}

# Git {{{
#
# Clone
abbr -a gcl git clone

# Status
abbr -a gst git status

# Status short
abbr -a gsts git status --short

# Branch
abbr -a gb git branch

# Switch branch
abbr -a gsw git switch

# Switch branch and create it
abbr -a gswc git switch --create

# Checkout
abbr -a gco git checkout

# Checkout branch
abbr -a gcob git checkout -b

# Add
abbr -a ga git add

# Diff
abbr -a gd git diff

# Diff staged
abbr -a gds git diff --staged

# Commit
abbr -a gc git commit

# Pull
abbr -a gl git pull

# Push
abbr -a gp git push

# Restore
abbr -a gr git restore

# Restore staged
abbr -a grs git restore --staged

# Worktree add
abbr -a gwa git worktree add

# Worktree prune
abbr -a gwp git worktree prune
# }}}

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
