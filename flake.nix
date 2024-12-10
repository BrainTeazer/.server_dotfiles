{
  description = "Flake file for server :-)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs : 
  let
	system = "x86_64-linux";
  	pkgs = nixpkgs.legacyPackages.${system};
  in {
	nixosConfigurations.pandora = nixpkgs.lib.nixosSystem {
		specialArgs = { inherit inputs; };
		inherit system;
		modules = [
			./hosts/pandora/configuration.nix
			./hosts/common/modules/qbittorrent.nix
		];
	};

	homeConfigurations = {
		dr = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [ ./home-manager/home.nix ];
		};
	};
  };
}

