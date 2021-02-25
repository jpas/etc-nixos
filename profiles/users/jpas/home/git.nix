{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    # syntax highlighter for diffs and others
    delta.enable = true;

    extraConfig = {
      pull = { ff = "only"; };

      status = { submodulesummary = 1; };

      submodule = { recurse = true; };
    };
  };
}
