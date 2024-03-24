function __mm_confirm --description 'Confirm' --argument prompt
    if test -z "$prompt"
        set prompt "Continue?"
    end 

    while true
        read -p 'echo -ne "$prompt ["; set_color green; echo -ne "y"; set_color normal; echo -ne "/"; set_color red; echo -ne "N"; set_color normal; echo -ne "]: "; ' -l confirm

        switch $confirm
            case Y y 
                return 0
            case '' N n 
                return 1
        end 
    end 
end

function __mm_echo --argument color --argument text --argument no_newline
    set_color $color;
    if test -n "$no_newline"
        echo -ne $text
    else
        echo $text
    end
    set_color normal;
end

function __mm_check_dependencies
    if type -q "fzf"
        return 0
    else
        return 1
    end
end


function __mm_install_dependencies
    if __mm_check_dependencies
        echo ""
        __mm_echo green "Dependencies already installed"
        echo ""
        return 0
    else
        echo ""
        echo "MakeMeFish is dependent of fzf - the command line fuzzy finder."
        if __mm_confirm "fzf is not installed. Would you like to install fzf?"
            switch (uname)
                case Linux Darwin
                    if type -q "brew"
                        if __mm_confirm "You are using brew - would you like to install fzf through brew?"
                            echo (brew install fzf)
                            return 0
                        end
                    end
                case FreeBSD NetBSD DragonFly
                        echo (pkg install fzf)
                        return 0
                case '*'
                        echo "Unknown OS"
            end
            __mm_echo red "Could not install automatically."
        end
            echo -ne "Go to "; __mm_echo blue "https://github.com/junegunn/fzf#installation" 1; echo -ne " and follow the instructions for your environment."
            return 1
    end
end

function __mm_dependencies
    if __mm_check_dependencies
        return 0
    else
        if __mm_install_dependencies true
            return 0
        else
            return 1
        end
    end
end