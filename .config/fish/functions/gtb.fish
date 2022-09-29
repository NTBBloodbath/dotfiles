function gtb
   for branch in $(git branch --all | grep "^\s*remotes" | egrep --invert-match "(:?HEAD|master|main)\$")
      git branch --track (string replace -r ".+\/.+\/" "" $branch) $branch
   end
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0