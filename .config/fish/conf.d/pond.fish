function __pond_install --on-event pond_install
    set -U pond_home $__fish_config_dir/pond
    set -U pond_message_prefix pond
    set -U pond_enable_on_create yes
    set -U pond_load_on_create yes
    set -U pond_autoload_suffix autoload
    set -U pond_autounload_suffix autounload

    set -l editors (command -s $EDITOR vim vi emacs nano)
    if test $status -eq 0
        set -U pond_editor $editors[1]
        echo "$pond_message_prefix: Using editor for interactive commands: $editors[1]"
    else
        echo "$pond_message_prefix: Unable to determine interactive editor; some commands may not" >&2
        echo "$pond_message_prefix: function (e.g. 'autoload', 'autounload'); configure an editor" >&2
        echo "$pond_message_prefix: after installation completes using: set -U pond_editor <path>" >&2
    end

    if test (mkdir -p $pond_home >/dev/null 2>&1) $status -ne 0
        echo "$pond_message_prefix: Failed to create directory: $pond_home" >&2
    end
end

function __pond_uninstall --on-event pond_uninstall
    read --prompt-str "$pond_message_prefix: Purge all pond data before uninstalling plugin? " answer
    if string length -q $answer; and string match -i -r '^(y|yes)$' -q $answer
        rm -rf $pond_home
        if test $status -eq 0
            echo "$pond_message_prefix: Removed all pond data"
        else
            echo "$pond_message_prefix: Unable to remove pond data" >&2
        end
    end

    for pond_path in $pond_function_path
        set -l fish_function_path_index (contains -i $pond_path $fish_function_path)
        if test -n "$fish_function_path_index"
            set -e fish_function_path[$fish_function_path_index]
        end
    end

    set -e pond_home
    set -e pond_message_prefix
    set -e pond_enable_on_create
    set -e pond_load_on_create
    set -e pond_editor
    set -e pond_autoload_suffix
    set -e pond_autounload_suffix

    set -e __pond_init
    set -e __pond_install
    set -e __pond_uninstall

    set -e pond_function_path
end

function __pond_init
    set -a fish_function_path $pond_function_path

    for pond_path in $pond_function_path
        set -l pond_autoload_function (string split -m1 -r '/' "$pond_path")[2]_$pond_autoload_suffix
        type -q $pond_autoload_function; and $pond_autoload_function
    end
end

__pond_init
