{ lib
, config
, ...
}:

with lib;

mkMerge [
  {
    programs.bash = {
      enable = true;

      # enableVteIntegration = true;
      historyFile = "/dev/null";

      sessionVariables = {
        LESSHIST = "/dev/null";
      };

      shellAliases = {
        v = "$VISUAL";
        e = "$EDITOR";
      };

      profileExtra = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      initExtra =
        let
          promptConfig = ''
            __prompt_generate() {
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

              if [[ -n "''${SSH_TTY}" ]]; then
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

            __prompt_hook() {
              local previous_exit_status=$?
              trap -- "" SIGINT
              PS1="$(__prompt_generate ''${previous_exit_status})"
              trap - SIGINT
              return ''${previous_exit_status}
            }

            PROMPT_COMMAND="''${PROMPT_COMMAND:+''${PROMPT_COMMAND};}__prompt_hook"
          '';
        in
        ''
          ${promptConfig}
        '';
    };
  }

  (mkIf config.programs.exa.enable {
    programs.bash.shellAliases = {
      ls = "exa";
      l = "exa --long";
      la = "exa --long --all";
      lt = "exa --tree";
    };
  })
]
