-----[[-----------------------------------]]-----
----                                         ----
---           FIELDS CONFIGURATIONS           ---
----                                         ----
-----]]-----------------------------------[[-----

-- Enabled information fields, the data that will be printed
-- Available (working) fields:
--   * "" (empty string) -> newline
--   * User (JohnDoe@myhost)
--   * Separator
--   * OS
--   * Kernel
--   * Uptime
--   * Packages
--   * WM
--   * Resolution
--   * Shell
--   * Terminal
--   * CPU
--   * Memory
--   * Colors
--
-- NOTE: fields are case-insensitive
options.enabled_fields = {
  "User",
  "Separator",
  "OS",
  "Kernel",
  "Uptime",
  "Packages",
  "",
  "WM",
  "Resolution",
  "",
  "Shell",
  "Terminal",
  "",
  "CPU",
  "Memory",
  "",
  "Colors",
}

----- DEFAULT FIELDS MESSAGES -------------------
-------------------------------------------------
options.os_message = " Distro"
options.kernel_message = " Kernel"
options.uptime_message = " Uptime"
options.packages_message = " Packages"
options.resolution_message = " Resolution"
options.wm_message = " WM"
options.shell_message = " Shell"
options.terminal_message = " Terminal"
options.cpu_message = " CPU"
options.memory_message = "ﳔ RAM"


-----[[-----------------------------------]]-----
----                                         ----
---          DISPLAY CONFIGURATIONS           ---
----                                         ----
-----]]-----------------------------------[[-----

-- The delimiter shown between the field message and the information, e.g.
-- OS: Fedora 34 (KDE Plasma) x86_64
--   ^
-- delimiter
--
-- NOTE: by default is ":", change it to "" for disabling it
options.delimiter = ":"

-- The separator shown between your USERNAME@HOSTNAME message
--
-- NOTE: default is "-"
options.separator = "-"

-- The terminal colors icon, this option overrides colors_style
-- in order to use your own icon for the color palette
--
-- NOTE: default is ""
options.colors_icon = ""

-- The terminal colors style
-- Available styles:
--   * classic
--   * circles
--   * ghosts (requires a patched font like nerd fonts)
--
-- NOTE: default is "classic"
options.colors_style = "ghosts"

-- Accent color for the fields
-- Available colors:
--   * black
--   * red
--   * green
--   * yellow
--   * blue
--   * purple
--   * cyan
--   * white
--
-- NOTE: by default is the ASCII distro accent color. Colors are case-insensitive
options.accent_color = ""

options.custom_ascii_logo = {
  --[[ "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
  "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
  "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
  "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
  "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
  "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
  "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
  " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
  " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
  "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
  "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ", ]]
}

-- ASCII distro logo to be printed
-- Available logos:
--   * tux
--   * arch
--   * nixos
--   * fedora
--   * gentoo
--   * debian
--   * ubuntu
--
-- NOTE: by default the ASCII distro logo is automatically detected
options.ascii_distro = ""

-- If the ASCII distro logo should be printed
--
-- NOTE: default is true
options.display_logo = true

-- The gap between the ASCII distro logo / terminal left border and the
-- information fields
--
-- NOTE: by default is 3
options.gap = 3

-- If the OS architecture should be shown at the right side of the OS name or not,
-- e.g. Fedora x86_64
--
-- NOTE: by default is true
options.show_arch = true

-- If the screen refresh rate should be shown when displaying the
-- screen resolution
--
-- NOTE: by default is false
options.display_refresh_rate = false

-- If the CPU information should be short or include extra information, e.g.
--   when true:
--     Intel i5 760 (4) @ 2.8Ghz
--   when false:
--     Intel(R) Core(TM) i5 760 (4) @ 2.8Ghz
--
-- NOTE: by default is true
options.short_cpu_info = true

-- If the memory should be printed as GiB instead of MiB
--
-- NOTE: by default is true
options.memory_in_gib = true
