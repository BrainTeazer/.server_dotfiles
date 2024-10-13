{ config, pkgs, ... }:

let 
	username = "dr";
in
{
  imports = [ 
	./tools/zsh/zsh.nix
	./tools/nvim/nvim.nix
	./tools/git/git.nix
  ];

  home = {
	inherit username;
	homeDirectory = "/home/${username}";
	stateVersion = "24.05";
  };

  programs = {
	# Enable home manager
    home-manager.enable = true;

	direnv = {
		enable = true;
		nix-direnv = {
			enable = true;
		};
	};
  };
}
