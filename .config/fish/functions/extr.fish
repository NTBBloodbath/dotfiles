function extr
   if not set -q argv[1]
      echo "Usage: extr <path/file_name>.<zip|rar|bz1|gz|tar|tbz|tbz2|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
      return 1
   end

   switch $argv[1]
      case "*.tar.bz2"
         tar xvjf $argv[1]
      case "*.tar.gz"
         tar xvzf $argv[1]
      case "*.tar.xz"
         tar xvJf $argv[1]
      case "*.lzma"
         unlzma $argv[1]
      case "*.bz2"
         bunzip2 $argv[1]
      case "*.rar"
         unrar x -ad $argv[1]
      case "*.gz"
         gunzip $argv[1]
      case "*.tar"
         tar xvf $argv[1]
      case "*.tbz"
         tar xvjf $argv[1]
      case "*.tbz2"
         tar xvjf $argv[1]
      case "*.tgz"
         tar xvzf $argv[1]
      case "*.zip"
         unzip $argv[1]
      case "*.Z"
         uncompress $argv[1]
      case "*.7z"
         7z x $argv[1]
      case "*.xz"
         unxz $argv[1]
      case "*.exe"
         cabextract $argv[1]
      case "*"
         echo "extr: '$argv[1]' - unknown archive method"
   end
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
