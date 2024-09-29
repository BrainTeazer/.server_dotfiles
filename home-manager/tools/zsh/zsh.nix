{ lib, pkgs, ... }:

{
  programs.zsh = {
	enable = true;
	history = {
		size = 9999;
	};
	enableCompletion = true;
	completionInit = ''
		zstyle ':completion:*' matcher-list ''' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=** r:|=**'
		autoload -Uz compinit; compinit
		autoload -Uz vcs_info
		setopt globdots appendhistory completeinword promptsubst
		zstyle ':vcs_info:git:*' formats '%F{1}(%b)%f'\
	'';
	syntaxHighlighting.enable = true;
  };
}
