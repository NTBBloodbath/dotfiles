# Directories {{{
#
# Development directories
abbr -a dev cd $HOME/Develop
abbr -a zdev cd $HOME/Develop/Zig
abbr -a cdev cd $HOME/Develop/Clang
# abbr -a csdev cd $HOME/Develop/Csharp
abbr -a rsdev cd $HOME/Develop/Rust
abbr -a edev cd $HOME/Develop/Elixir
# abbr -a jldev cd $HOME/Develop/Julia
# abbr -a pydev cd $HOME/Develop/Python
abbr -a nodev cd $HOME/Develop/Node
# abbr -a asmdev cd $HOME/Develop/Assembly
# abbr -a hskdev cd $HOME/Develop/Haskell
abbr -a miscdev cd $HOME/Develop/Misc
abbr -a nvimdev cd $HOME/Develop/Nvim
# abbr -a workdev cd $HOME/Develop/Work

# Minecraft and Terraria servers
abbr -a mcservers cd $HOME/.local/minecraft/servers
abbr -a teservers cd $HOME/.local/share/Steam/steamapps/common/tModLoader
# }}}

# Git {{{
#
# Clone
abbr -a gcl git c

# Clone with submodules
abbr -a gcls git cs

# Status
abbr -a gst git s

# Branch
abbr -a gb git branch

# Switch branch
abbr -a gsw git sb

# Checkout
abbr -a gco git checkout

# List contributors
abbr -a gcon git contributors

# Add
abbr -a ga git add

# Add interactively
abbr -a gap git add -p

# List aliases
abbr -a gal git aliases

# Diff
abbr -a gd git --no-pager diff --stat

# Diff staged
abbr -a gds git diff --staged

# Diff with latest commit (detailed, like git diff)
abbr -a gdd git --paginate d

# Commit
abbr -a gc git commit

# Pull with submodules if necessary
abbr -a gl git ps

# Push
abbr -a gp git push

# Restore
abbr -a gr git restore

# Restore staged
abbr -a grs git restore --staged

# Find branches containing commit
abbr -a gfb git fb

# Find tags containing commit
abbr -a gft git ft

# Find commits by commit message
abbr -a gfb git fm

# Worktree add
abbr -a gwa git worktree add

# Worktree list
abbr -a gwl git worktree list

# Worktree prune
abbr -a gwp git worktree prune
# }}}

# Development {{{
#
# Zig
if command -qs zig
   abbr -a zb zig build --prominent-compile-errors --summary all
   abbr -a zr zig run
   abbr -a zt zig test
   abbr -a zfmt zig fmt
end
# }}}

# Gentoo environment {{{
#
# Gentoo's env-update is not compatible with fish so we are using bass to deal with it
abbr -a env_update "sudo env-update && bass source /etc/profile"

# Synchronize repositories
abbr -a esync "sudo emerge --sync"

# Search package from repositories
abbr -a esearch "sudo emerge --search --searchdesc"

# Search package from installed @world packages in Gentoo
abbr -a esearchinst --set-cursor=! "eix -c --world | sed \"s/\s(.*)//\" | rg \"!\""

# Install a new package
abbr -a einstall "sudo emerge --ask"

# Temporarily install a new package (do not add it to @world)
abbr -a einstalltmp "sudo emerge --ask --oneshot"

# Remove package
abbr -a eremove --set-cursor=! "sudo emerge --deselect ! && sudo emerge --ask --depclean"

# Update packages (new USE)
abbr -a eupnew "sudo emerge --ask --update --newuse --deep @world"

# Update packages (changed USE)
abbr -a eupch "sudo emerge --ask --quiet --update --changed-use --deep @world"

# Update system
abbr -a eup "sudo emerge --ask --update --newuse --deep @world"

# Get update ETA
abbr -a eupeta "sudo emerge --pretend --update --newuse --deep @world | sudo genlop -p"

# Get current packages compilation ETA
abbr -a ebuildeta "sudo genlop -c"
# }}}

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
