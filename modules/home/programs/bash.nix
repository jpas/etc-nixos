{ ...
}:
{
  programs.bash = {
    enable = true;

    # enableVteIntegration = true;
    historyFile = "/dev/null";

    shellAliases = {
      v = "$VISUAL";
      e = "$EDITOR";

      l = "ls";
      ll = "l -l";
      la = "ll -a";
    };

    initExtra = let
      promptConfig = ''
        _prompt_generate() {
          local previous_exit_status=$1

          local RED="\[$(tput setaf 1)\]"
          local GREEN="\[$(tput setaf 2)\]"
          local YELLOW="\[$(tput setaf 3)\]"
          local BLUE="\[$(tput setaf 4)\]"
          local MAGENTA="\[$(tput setaf 5)\]"
          local CYAN="\[$(tput setaf 6)\]"
          local WHITE="\[$(tput setaf 6)\]"
          local RESET="\[$(tput sgr0)\]"

          local prompt=""

          if [[ -n "''${SSY_TTY}" ]]; then
            prompt+="''${BLUE}\u''${RESET} at ''${CYAN}\h''${RESET} in "
          fi

          prompt+="''${GREEN}\w''${RESET}\n"

          if (( "''${previous_exit_status}" != 0 )); then
            prompt+="''${RED}"
          else
            prompt+="''${MAGENTA}"
          fi

          prompt+="‡''${RESET} "

          printf "%s" "''${prompt}"
        }

        _prompt_hook() {
          local previous_exit_status=''$?
          trap -- "" SIGINT
          PS1="$(_prompt_generate ''${previous_exit_status})"
          trap - SIGINT
          return ''${previous_exit_status}
        }

        PROMPT_COMMAND="''${PROMPT_COMMAND:+''${PROMPT_COMMAND};}_prompt_hook"
      '';
    in ''
      ${promptConfig}
    '';
  };
}
