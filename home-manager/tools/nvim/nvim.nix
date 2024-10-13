{ lib, pkgs, ... }:

{
  programs.neovim = {
	enable = true;
  	vimAlias = true;
	viAlias = true;

	extraLuaConfig = builtins.concatStringsSep "\n" [
		''
		${lib.strings.fileContents ./include/options.lua}
		${lib.strings.fileContents ./include/plugins-config.lua}
		''
	];

	plugins = with pkgs.vimPlugins; [
		nightfox-nvim
		nvim-autopairs

		nvim-treesitter.withAllGrammars
	];
  };
}
