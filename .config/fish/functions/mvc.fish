function mvc
   if not set -q argv[1] && not set -q argv[2]
      echo "Usage: mvc <old_path> <new_path>"
      return 1
   end

   mv $argv[1] $argv[2]
   cd $argv[2]
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
