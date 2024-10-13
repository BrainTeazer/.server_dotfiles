{ lib, pkgs, ... }:

{
  programs.neovim = {
	enable = true;
  	vimAlias = true;
	defaultEditor = true;

	extraConfig = builtins.concatStringSep "\n" [
		''
		lua << EOF
		${lib.strings.fileContents ./include/options.lua}
		${lib.strings.fileContents ./include/plugins-config.lua}
		EOF
		''
	];

	plugins = with pkgs.vimPlugins; [
		nightfox-nvim
		nvim-autopairs
	];
  };
}
