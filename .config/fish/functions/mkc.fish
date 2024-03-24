function mkc
   if not set -q argv[1]
      echo "Usage: mkc <path>"
      return 1
   end

   mkdir -pv $argv[1]
   cd $argv[1]
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
