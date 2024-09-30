Use the Derteministic nix installer:
https://zero-to-nix.com/concepts/nix-installer#:~:text=The%20Determinate%20Nix%20Installer%2C%20from,users%20to%20enable%20those%20features.
Git Clone:
git clone git@github.com:SamD2021/cluster-home-manager.git ~/.config/home-manager
Switch into it:
nix run home-manager/master -- switch -b backup
