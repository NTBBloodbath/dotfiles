# GNU LS arguments
if not set -q LS_CORE_ARGS
   # -v          : natural sort of (version) numbers within text
   # -p          : append '/' indicator to directories
   # -N          : print entry names without quoting
   # --file-type : append special indicators based on filetpe (exluding '*' for binaries/executables)
   set -Ux LS_CORE_ARGS --color=auto -vpN --file-type --group-directories-first
end

# Default l function runs GNU LS
function l
   ls $LS_CORE_ARGS $argv
end

# Eza arguments
if command -qs eza
   if not set -q EZA_CORE_ARGS
      set -Ux EZA_CORE_ARGS --group --header --icons --group-directories-first
   end

   function l
      eza $EZA_CORE_ARGS $argv
   end
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
