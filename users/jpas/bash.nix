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
        export LEDGER_FILE="$HOME/documents/finance/current.journal"

        [[ -r "$XDG_CONFIG_HOME/bash/profile.local.bash" ]] && source "$XDG_CONFIG_HOME/bash/profile.local.bash"
      '';

      initExtra = ''
        [[ -r "$XDG_CONFIG_HOME/bash/rc.local.bash" ]] && source "$XDG_CONFIG_HOME/bash/rc.local.bash"
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
