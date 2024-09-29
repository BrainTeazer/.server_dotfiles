
{ lib, pkgs, ... }:

{
  programs.git = {
	enable = true;
  	userName = "aybanj";
	userEmail = "ay.banj@proton.me";
	extraConfig = {
		init = {
			defaultBranch = "main";
		};
	};
  };
}
