function wgetae
   if not set -q argv[1]
      echo "Usage: wgetae <url>"
      return 1
   end

   set -l url $argv[1]
   set -l filename (string replace -r -a ".+/" "" $url)

   wget $url -O $filename
   extrr $filename
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
