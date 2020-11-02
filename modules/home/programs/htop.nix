{ ... }:
{
  programs.htop = {
    enable = true;
    hideUserlandThreads = true;
    hideKernelThreads = true;
    treeView = true;
    showProgramPath = false;
  };
}
