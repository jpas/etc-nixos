{ ... }:
{
  users.users.jpas = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # Generated with `mkpasswd -m sha-512`
    hashedPassword = "$6$IUhiVYbf1uNK2vC$WqRJsg80aoenjtn1EQ1reJivbZ2Yew5LzP1sWAlTvpF0iwqTET5BV6IJzGpB9QyFoGerlxSnQ/lCj1RCfh1Ax.";
  };
}

