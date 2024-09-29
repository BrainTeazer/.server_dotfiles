# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
	loader.grub = {
		enable = true;
		efiSupport = true;
		zfsSupport = true;
		mirroredBoots = [
		  { devices = [ "nodev" ]; path = "/boot"; }
		];
	};

	loader.efi.canTouchEfiVariables = true;
	kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
	supportedFilesystems = [ "zfs" ];
	zfs.extraPools = [ "datapool" ];
	kernelParams = [ "nohibernate" ];
  };
  
  services.zfs.autoScrub.enable = true;

  # add flakes
  nix = {
  	settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
	};

	# weekly garbage collection
	gc = {
		automatic = true;
		dates = "weekly";
	};
  };

  networking = {
  	hostName = "pandora";
	hostId = "549a11a5";
  };

  # Enable sound (pipewire)
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
  	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	# for JACK applications, uncomment
	#jack.enable = true;
  };

  programs.zsh.enable = true;
  
  # Defining user account (dr). Set a new password with 'passwd'
  users.users.dr = {
  	initialPassword = "password";
  	isNormalUser = true;
	home = "/home/dr";
	extraGroups = [ "wheel" ];

	# add user specific packages
	packages = with pkgs; [
		jellyfin
		jellyfin-web
		jellyfin-ffmpeg
	];

	shell = pkgs.zsh;

	#openssh.authorizedKeys.keys = [
	#	ssh-public-key
	#];
  };

  programs.git = {
  	enable = true;
	config = {
		init = {
			defaultBranch = "main";
		};
		user= {
			name = "aybanj";
			email = "ay.banj@proton.me";
		};
	};
  };

  environment.systemPackages = with pkgs; [
	wget
	curl
  ];

  services = {
  	jellyfin = {
		enable = true;
		openFirewall = true;
	};

	audiobookshelf = {
		enable = true;
	};
  };

  # ssh configuration
  services.openssh = {
  	enable = true;
	ports = [ 22 ];
	settings = {
		#PasswordAuthentication = false;
		#KbdInteractiveAuthentication = false;
		AllowUsers = null;	
		UseDns = true;
		X11Forwarding = true;
		PermitRootLogin = "no";
	};
  };

  system.stateVersion = "24.05"; # Did you read the comment? No.
}
