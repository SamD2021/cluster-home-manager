{
  inputs,
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "root";
  home.homeDirectory = "/root";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.devenv
    inputs.nixvim.packages.${pkgs.system}.default
    # pkgs.mosh
    pkgs.ripgrep
    pkgs.distrobox
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/root/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  #   # EDITOR = "emacs";
  #   KUBECONFIG = "/root/kubeconfig.smartniccluster";
  # };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
      silent = true;
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        # Source global definitions
        if [ -f /etc/bashrc ]; then
                . /etc/bashrc
        fi

        # User specific environment
        if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
        then
            PATH="$HOME/.local/bin:$HOME/bin:$PATH"
        fi
        export PATH

        # Uncomment the following line if you don't like systemctl's auto-paging feature:
        # export SYSTEMD_PAGER=

        # User specific aliases and functions

        alias rm='rm -i'
        alias cp='cp -i'
        alias mv='mv -i'
        eval "$(direnv hook bash)"
      '';
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "vi-mode"
          "direnv"
          "oc"
          "podman"
          "kubectl"
          "dnf"
          "python"
        ];
      };
      initExtraFirst = ''
        # Ensure Zsh initialization
        # if [ -n "$BASH_VERSION" ]; then
        #   exec /bin/zsh
        # fi
      '';
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings =
        builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./.config/oh-my-posh/zen/config.json));
    };
  };
}
