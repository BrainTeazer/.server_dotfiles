{
  description = "Flake file for server :-)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
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

