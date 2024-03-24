function pond -a command -d "A fish shell environment manager"
    set -g pond_version 2.5.0

    function __pond_usage
        echo "\
Pond $pond_version

Usage:
    pond [options]
    pond <command> [command-options] ...

Help Options:
    -h, --help            Show this help message
    <command> -h, --help  Show command help

Application Options:
    -v, --version         Print the version string

Commands:
    create     Create new pond
    autoload   Create or edit pond autoload function
    autounload Create or edit pond autounload function
    remove     Remove a pond and associated data
    list       List ponds
    check      Check pond functions for syntax issues
    enable     Enable a pond for new shell sessions
    disable    Disable a pond for new shell sessions
    load       Load pond into current shell session
    unload     Unload pond from current shell session
    status     View pond status
    drain      Drain all data from pond
    dir        Change current working directory to pond
    config     Show configuration settings" >&2
        echo
    end

    function __pond_create_command_usage
        echo "\
Usage:
    pond create ponds...

Arguments:
    ponds  The name of one or more ponds to create; a pond name
           must begin with an alphanumeric character followed by
           any number of additional alphanumeric characters,
           underscores or dashes" >&2
        echo
    end

    function __pond_autoload_command_usage
        echo "\
Usage:
    pond autoload <name>

Arguments:
    name  The name of the pond for which an autoload function
          will be opened in an editor and optionally created if
          it does not already exist" >&2
        echo
    end

    function __pond_autounload_command_usage
        echo "\
Usage:
    pond autounload <name>

Arguments:
    name  The name of the pond for which an autounload function
          will be opened in an editor and optionally created if
          it does not already exist" >&2
        echo
    end

    function __pond_remove_command_usage
        echo "\
Usage:
    pond remove [options] ponds...

Options:
    -y, --yes  Automatically accept confirmation prompts

Arguments:
    ponds  The name of one or more ponds to remove" >&2
        echo
    end

    function __pond_list_command_usage
        echo "\
Usage:
    pond list [options]

Options:
    -e, --enabled   List enabled ponds
    -d, --disabled  List disabled ponds
    -l, --loaded    List loaded ponds
    -u, --unloaded  List unloaded ponds" >&2
        echo
    end

    function __pond_enable_command_usage
        echo "\
Usage:
    pond enable ponds...

Arguments:
    ponds  The name of one or more ponds to enable" >&2
        echo
    end

    function __pond_disable_command_usage
        echo "\
Usage:
    pond disable ponds...

Arguments:
    ponds  The name of one or more ponds to disable" >&2
        echo
    end

    function __pond_load_command_usage
        echo "\
Usage:
    pond load ponds...

Arguments:
    ponds  The name of one or more ponds to load" >&2
        echo
    end

    function __pond_unload_command_usage
        echo "\
Usage:
    pond unload ponds...

Arguments:
    ponds  The name of one or more ponds to unload" >&2
        echo
    end

    function __pond_status_command_usage
        echo "\
Usage:
    pond status [ponds...]

Arguments:
    ponds  The name of one or more ponds" >&2
        echo
    end

    function __pond_check_command_usage
        echo "\
Usage:
    pond check ponds...

Arguments:
    ponds  The name of one or more ponds to check" >&2
        echo
    end

    function __pond_drain_command_usage
        echo "\
Usage:
    pond drain [options] ponds...

Options:
    -y, --yes  Automatically accept confirmation prompts

Arguments:
    ponds  The name of one or more ponds to drain" >&2
        echo
    end

    function __pond_dir_command_usage
        echo "\
Usage:
    pond dir <name>

Arguments:
    name  The name of the pond to change directory to" >&2
        echo
    end

    function __pond_config_command_usage
        echo "\
Usage:
    pond config" >&2
        echo
    end

    function __pond_show_error -a message
        echo (set_color red; and echo -n "Error: "; and set_color normal; and echo "$message") >&2
    end

    function __pond_create_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if test (mkdir -m 0755 -p $pond_path >/dev/null 2>&1) $status -ne 0
            __pond_show_error "Failed to create pond directory: $pond_path"; and return 1
        end

        if test "$pond_enable_on_create" = yes
            set -U -a pond_function_path $pond_path
        end

        if test "$pond_load_on_create" = yes
            set -a fish_function_path $pond_path
        end

        echo "Created empty pond: $pond_name"
        emit pond_created $pond_name $pond_path
    end

    function __pond_autoload_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_autoload_file $pond_path/{$pond_name}_{$pond_autoload_suffix}.fish

        if ! test -f $pond_autoload_file
            if test (echo -e "function "{$pond_name}_{$pond_autoload_suffix}"\n\nend" >> $pond_autoload_file) $status -ne 0
                __pond_show_error "Unable to create autoload function: $pond_autoload_file"; and return 1
            else
                echo "Created autoload function: $pond_autoload_file"
            end
        end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            __pond_show_error "Editor not found: '$pond_editor'"; and return 1
        end

        $pond_editor $pond_autoload_file
    end

    function __pond_autounload_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_autounload_file $pond_path/{$pond_name}_{$pond_autounload_suffix}.fish

        if ! test -f $pond_autounload_file
            if test (echo -e "function "{$pond_name}_{$pond_autounload_suffix}"\n\nend" >> $pond_autounload_file) $status -ne 0
                __pond_show_error "Unable to create autounload function: $pond_autounload_file"; and return 1
            else
                echo "Created autounload function: $pond_autounload_file"
            end
        end

        if test -z "$__pond_under_test"
            and test (command -s $pond_editor >/dev/null 2>&1) $status -ne 0
            __pond_show_error "Editor not found: '$pond_editor'"; and return 1
        end

        $pond_editor $pond_autounload_file
    end

    function __pond_remove_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if test "$pond_auto_accept" != yes
            read --prompt-str "Remove pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0
            end
        end

        set -l pond_function_path_index (contains -i $pond_path $pond_function_path)
        if test -n "$pond_function_path_index"
            set -e pond_function_path[$pond_function_path_index]
        end

        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end

        if test (rm -rf $pond_path >/dev/null 2>&1) $status -ne 0
            __pond_show_error "Unable to remove pond: $pond_name"; and return 1
        end

        echo "Removed pond: $pond_name"
        emit pond_removed $pond_name $pond_path
    end

    function __pond_list_operation -a pond_list_enabled pond_list_disabled pond_list_loaded pond_list_unloaded
        set -l pond_count 0
        set -l pond_matches

        for pond_path in $pond_home/*
            set -l pond_short_name (path basename $pond_path)

            if test "$pond_list_enabled" = yes
                if contains $pond_path $pond_function_path
                    set -a pond_matches $pond_short_name
                    set pond_count (math $pond_count + 1)
                    continue
                end
            end

            if test "$pond_list_disabled" = yes
                if not contains $pond_path $pond_function_path
                    set -a pond_matches $pond_short_name
                    set pond_count (math $pond_count + 1)
                    continue
                end
            end

            if test "$pond_list_loaded" = yes
                if contains $pond_path $fish_function_path
                    set -a pond_matches $pond_short_name
                    set pond_count (math $pond_count + 1)
                    continue
                end
            end

            if test "$pond_list_unloaded" = yes
                if not contains $pond_path $fish_function_path
                    set -a pond_matches $pond_short_name
                    set pond_count (math $pond_count + 1)
                    continue
                end
            end
        end

        for pond_match in $pond_matches
            echo $pond_match
        end

        if test $pond_count -eq 0
            __pond_show_error "No matching ponds"; and return 1
        end
    end

    function __pond_enable_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if contains $pond_path $pond_function_path
            __pond_show_error "Pond already enabled: $pond_name"; and return 1
        else
            set -U -a pond_function_path $pond_path

            echo "Enabled pond: $pond_name"
            emit pond_enabled $pond_name $pond_path
        end
    end

    function __pond_disable_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if not contains $pond_path $pond_function_path
            __pond_show_error "Pond already disabled: $pond_name"; and return 1
        else
            set -l pond_function_path_index (contains -i $pond_path $pond_function_path)
            if test -n "$pond_function_path_index"
                set -e pond_function_path[$pond_function_path_index]
            end

            echo "Disabled pond: $pond_name"
            emit pond_disabled $pond_name $pond_path
        end
    end

    function __pond_load_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_autoload_function {$pond_name}_{$pond_autoload_suffix}

        if not contains $pond_path $fish_function_path
            set -a fish_function_path $pond_path
        end

        type -q $pond_autoload_function; and $pond_autoload_function

        echo "Loaded pond: $pond_name"
        emit pond_loaded $pond_name $pond_path
    end

    function __pond_unload_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pond_autounload_function {$pond_name}_{$pond_autounload_suffix}

        type -q $pond_autounload_function; and $pond_autounload_function

        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end

        echo "Unloaded pond: $pond_name"
        emit pond_unloaded $pond_name $pond_path
    end

    function __pond_global_status_operation
        set -l pad_width 12
        set -l pond_count (count $pond_home/*/)

        set -l pond_health_indicator (set_color green)"●"(set_color normal)
        set -l pond_health (set_color green)"good"(set_color normal)
        for pond_function in $pond_home/**.fish
            if test (fish --no-execute $pond_function 2>/dev/null 1>&2) $status -ne 0
                set pond_health_indicator (set_color red)"●"(set_color normal)
                set pond_health (set_color red)"poor"(set_color normal)" (syntax issues detected)"
                break
            end
        end

        echo -e "$pond_health_indicator pond $pond_version"

        set -l pond_enabled_count (count (string match -r "$pond_home/.*" -- $pond_function_path))
        set -l pond_loaded_count (count (string match -r "$pond_home/.*" -- $fish_function_path))

        echo -e (string pad -w $pad_width "Health:") $pond_health
        echo (string pad -w $pad_width "Ponds:") "$pond_count ($pond_enabled_count enabled; $pond_loaded_count loaded)"
        echo -e (string pad -w $pad_width "Loaded:") $pond_home

        set -l pond_load_indicator "•"
        set -l pond_load_padding (string pad -w (math $pad_width + 1) "")

        set -l pond_dirs $pond_home/*/
        if test (count $pond_dirs) -gt 0
            for pond_dir in $pond_dirs[..-2]
                if contains (string sub -e -1 $pond_dir) $fish_function_path
                    echo $pond_load_padding├─(set_color green)$pond_load_indicator(set_color normal) (path basename $pond_dir)
                else
                    echo $pond_load_padding├─(set_color 8a8a8a brblack)$pond_load_indicator (path basename $pond_dir)(set_color normal)
                end
            end

            for pond_dir in $pond_dirs[-1]
                if contains (string sub -e -1 $pond_dirs[-1]) $fish_function_path
                    echo $pond_load_padding└─(set_color green)$pond_load_indicator(set_color normal) (path basename $pond_dirs[-1])
                else
                    echo $pond_load_padding└─(set_color 8a8a8a brblack)$pond_load_indicator (path basename $pond_dirs[-1])(set_color normal)
                end
            end
        else
            echo $pond_load_padding└─(set_color 8a8a8a brblack)$pond_load_indicator none(set_color normal)
        end
    end

    function __pond_status_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l pad_width 12

        if __pond_is_loaded $pond_path
            echo -e (set_color green)"●"(set_color normal)" $pond_name ($pond_path)"
        else
            echo -e "● $pond_name ($pond_path)"
        end

        echo (string pad -w $pad_width "Status:") \
            (__pond_is_loaded $pond_path; and echo "loaded"; or echo "unloaded"), \
            (__pond_is_enabled $pond_path; and echo "enabled"; or echo "disabled")

        set -l pond_health good
        for pond_function in $pond_path/**.fish
            if test (fish --no-execute $pond_function 2>/dev/null 1>&2) $status -ne 0
                set pond_health (set_color red)"poor"(set_color normal)" (syntax issues detected)"
                break
            end
        end

        echo (string pad -w $pad_width "Health:") $pond_health
        echo (string pad -w $pad_width "Autoload:") (test -f $pond_path/{$pond_name}_{$pond_autoload_suffix}.fish; and echo "present"; or echo "absent")
        echo (string pad -w $pad_width "Autounload:") (test -f $pond_path/{$pond_name}_{$pond_autounload_suffix}.fish; and echo "present"; or echo "absent")
        echo (string pad -w $pad_width "Functions:") (count $pond_path/**.fish)
        echo (string pad -w $pad_width "Size:") (string trim (du -sh $pond_path | cut -f 1))
    end

    function __pond_check_operation -a pond_name
        set -l pond_path $pond_home/$pond_name
        set -l passes 0
        set -l failures 0

        echo "Checking pond '$pond_name' for syntax issues.."

        for pond_function in $pond_path/**.fish
            echo -n "  "
            if test (fish --no-execute $pond_function 2>/dev/null 1>&2) $status -eq 0
                set_color green; and echo -n "✔"; and set_color normal
                set passes (math $passes + 1)
            else
                set_color red; and echo -n "✖"; and set_color normal
                set failures (math $failures + 1)
            end

            echo " "(path basename $pond_function)
        end

        set -l total (math $passes + $failures)

        set_color green; and echo -n "passed: $passes"; and set_color normal
        echo -n "  "
        set_color red; and echo -n "failed: $failures"; and set_color normal
        echo "  of $total functions"

        if test $failures -ne 0
            return 1
        end
    end

    function __pond_drain_operation -a pond_name
        set -l pond_path $pond_home/$pond_name

        if test "$pond_auto_accept" != yes
            read --prompt-str "Drain pond: $pond_name? " answer
            if ! string length -q $answer; or ! string match -i -r '^(y|yes)$' -q $answer
                return 0
            end
        end

        if test (count $pond_path/*) -ne 0
            if test (rm -rf $pond_path/* >/dev/null 2>&1) $status -ne 0
                __pond_show_error "Unable to drain pond: $pond_name"; and return 1
            end
        end

        echo "Drained pond: $pond_name"
        emit pond_drained $pond_name $pond_path
    end

    function __pond_dir_operation -a pond_name
        cd $pond_home/$pond_name
    end

    function __pond_config_operation
        echo "Pond home: $pond_home"
        echo "Enable ponds on creation: $pond_enable_on_create"
        echo "Load ponds on creation: $pond_load_on_create"
        echo "Pond editor command: $pond_editor"
    end

    function __pond_show_exists_error -a pond_name
        __pond_show_error "Pond already exists: $pond_name"
    end

    function __pond_show_not_exists_error -a pond_name
        __pond_show_error "Pond does not exist: $pond_name"
    end

    function __pond_exists -a pond_name
        if ! test -d $pond_home/$pond_name
            return 1
        end
    end

    function __pond_name_is_valid -a pond_name
        return (string match -r '^([A-Za-z0-9]{1}[A-Za-z0-9-_]*)$' -q -- $pond_name)
    end

    function __pond_is_enabled -a pond_path
        return (contains $pond_path $pond_function_path)
    end

    function __pond_is_loaded -a pond_path
        return (contains $pond_path $fish_function_path)
    end

    function __pond_cleanup
        functions -e __pond_cleanup

        for command in create remove list enable disable load unload status check drain dir config
            functions -e "__pond_"(echo $command)"_command_usage"
            functions -e "__pond_"(echo $command)"_operation"
        end

        functions -e __pond_usage
        functions -e __pond_show_exists_error
        functions -e __pond_show_not_exists_error
        functions -e __pond_exists
        functions -e __pond_name_is_valid
        functions -e __pond_is_enabled
        functions -e __pond_name_is_valid
        functions -e __pond_global_status_operation
        set -e pond_auto_accept
        set -e pond_version
    end

    if isatty
        set -g pond_auto_accept no
    else
        read --local --null --array stdin; and set --append argv $stdin
        set command $argv[1]
        set -g pond_auto_accept yes
    end

    set argv $argv[2..-1]

    switch $command
        case -v --version
            if test (count $argv) -ne 0
                __pond_usage; and __pond_cleanup; and return 1
            end
            echo "pond $pond_version ("(uname -s) (uname -m)")"
        case '' -h --help
            __pond_usage
        case create
            if test (count $argv) -eq 0
                __pond_create_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_create_command_usage
                    __pond_cleanup
                    return 1
                else if __pond_exists $pond_name
                    __pond_show_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_create_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case remove
            if ! argparse y/yes >/dev/null 2>&1 -- $argv
                __pond_remove_command_usage
                __pond_cleanup; and return 1
            end

            set -q _flag_yes; and set pond_auto_accept yes

            if test (count $argv) -eq 0
                __pond_remove_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_remove_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_remove_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case list
            set -l pond_list_enabled yes
            set -l pond_list_disabled yes
            set -l pond_list_loaded yes
            set -l pond_list_unloaded yes

            if test (count $argv) -gt 0
                if ! argparse e/enabled d/disabled l/loaded u/unloaded >/dev/null 2>&1 -- $argv
                    __pond_list_command_usage
                    __pond_cleanup; and return 1
                end

                if test (count $argv) -ne 0
                    __pond_list_command_usage; and __pond_cleanup; and return 1
                end

                if set -q _flag_enabled; or set -q _flag_disabled; or set -q _flag_loaded; or set -q _flag_unloaded
                    set -q _flag_enabled; and set pond_list_enabled yes; or set pond_list_enabled no
                    set -q _flag_disabled; and set pond_list_disabled yes; or set pond_list_disabled no
                    set -q _flag_loaded; and set pond_list_loaded yes; or set pond_list_loaded no
                    set -q _flag_unloaded; and set pond_list_unloaded yes; or set pond_list_unloaded no
                end
            end

            __pond_list_operation $pond_list_enabled $pond_list_disabled $pond_list_loaded $pond_list_unloaded
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case enable
            if test (count $argv) -eq 0
                __pond_enable_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_enable_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_enable_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case disable
            if test (count $argv) -eq 0
                __pond_disable_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_disable_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_disable_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case load
            if test (count $argv) -eq 0
                __pond_load_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_load_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_load_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case unload
            if test (count $argv) -eq 0
                __pond_unload_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_unload_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_unload_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case status
            if test (count $argv) -eq 0
                __pond_global_status_operation
                set -l exit_code $status
                __pond_cleanup; and return $exit_code
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_status_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_status_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case check
            if test (count $argv) -eq 0
                __pond_check_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_check_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_check_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case drain
            if ! argparse y/yes >/dev/null 2>&1 -- $argv
                __pond_drain_command_usage
                __pond_cleanup; and return 1
            end

            set -q _flag_yes; and set pond_auto_accept yes

            if test (count $argv) -eq 0
                __pond_drain_command_usage; and __pond_cleanup; and return 1
            end

            for pond_name in $argv
                if ! __pond_name_is_valid "$pond_name"
                    __pond_drain_command_usage
                    __pond_cleanup
                    return 1
                else if ! __pond_exists $pond_name
                    __pond_show_not_exists_error $pond_name
                    __pond_cleanup
                    return 1
                end

                __pond_drain_operation $pond_name
                set -l exit_code $status
                if test $exit_code -gt 0
                    __pond_cleanup; and return $exit_code
                end
            end
        case autoload
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_autoload_command_usage
                __pond_cleanup; and return 1
            end

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_autoload_command_usage; and __pond_cleanup; and return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name; and __pond_cleanup; and return 1
            end

            __pond_autoload_operation $pond_name
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case autounload
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"
                __pond_autounload_command_usage
                __pond_cleanup; and return 1
            end

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_autounload_command_usage; and __pond_cleanup; and return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name; and __pond_cleanup; and return 1
            end

            __pond_autounload_operation $pond_name
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case dir
            set -l pond_name $argv[-1]
            set argv $argv[1..-2]

            if test -z "$pond_name"; or ! __pond_name_is_valid "$pond_name"; or test (count $argv) -ne 0
                __pond_dir_command_usage; and __pond_cleanup; and return 1
            else if ! __pond_exists $pond_name
                __pond_show_not_exists_error $pond_name; and __pond_cleanup; and return 1
            end

            __pond_dir_operation $pond_name
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case config
            if test (count $argv) -ne 0
                __pond_config_command_usage; and __pond_cleanup; and return 1
            end

            __pond_config_operation
            set -l exit_code $status
            __pond_cleanup; and return $exit_code
        case '*'
            __pond_show_error "Unknown command: $command"; and __pond_cleanup; and return 1
    end

    __pond_cleanup
end
