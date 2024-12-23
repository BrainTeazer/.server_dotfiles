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
	extraGroups = [ "wheel" "qbittorrent" ];

	# add user specific packages
	packages = with pkgs; [
		jellyfin
		jellyfin-web
		jellyfin-ffmpeg
		audiobookshelf

		qbittorrent-nox
		protonvpn-cli_2

		# utilities
		btop

        # load balancer and proxy
        #haproxy

        # DNS proxy and ad-blocker
        blocky
	];

	shell = pkgs.zsh;

	openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJI23I0Q25qXXN3hAYzYkxMisMo0ZIz32MR1FwW3aZs ayam.banjade@gmail.com"
	];
  };
    
  systemd.tmpfiles.rules =  [
    "A /data/media - - - - g:qbittorrent:rwx, g:jellyfin:rx, g:navidrome:rx"
  ];

  environment.systemPackages = with pkgs; [
	wget
	curl
  ];

  environment.variables = {
  	EDITOR = "nvim";
  };

  services = {
  	jellyfin = {
		enable = true;
		openFirewall = true;
	};

	audiobookshelf = {
		enable = true;
		openFirewall = true;
		port = 13378;
		host = "0.0.0.0";
	};

	qbittorrent = {
		enable = true;
		openFirewall = true;
		port = 58080;
	};
    
    #haproxy = {
    #    enable = false;
    #};

    blocky = {
        enable = true;
        settings = {

            ports.dns = 53; # Port for incoming DNS Queries.
            upstreams.groups.default = [
                "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
            ];

            # For initially solving DoH/DoT Requests when no system Resolver is available.
            bootstrapDns = {
                upstream = "https://one.one.one.one/dns-query";
                ips = [ "1.1.1.1" "1.0.0.1" ];
            };

            #Enable Blocking of certian domains.
            blocking = {
                blackLists = {
                    #Adblocking
                    ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
                    #Another filter for blocking adult sites
                    adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
                    #You can add additional categories
                };

                #Configure what block categories are used
                clientGroupsBlock = {
                    default = [ "ads" ];
                    kids-ipad = ["ads" "adult"];
                };
            };

            caching = {
                prefetching = true;
                minTime = "5m";
                maxTime = "30m";
            };
        };
    };
  };

  # ssh configuration
  services.openssh = {
  	enable = true;
	ports = [ 22 ];
	settings = {
		PasswordAuthentication = false;
		KbdInteractiveAuthentication = false;
		AllowUsers = null;	
		UseDns = true;
		X11Forwarding = true;
		PermitRootLogin = "no";
	};
  };

  system.stateVersion = "24.11"; # Did you read the comment? No.
}
