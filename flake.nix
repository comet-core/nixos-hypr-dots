{
  description = "Flake System - Omen 16";

  # 1. INPUTS: Where we download our software from
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # 2. OUTPUTS: How we build the system using the downloaded inputs
  outputs = { self, nixpkgs, noctalia, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # The name 'nixos' here MUST match your networking.hostName in configuration.nix
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # Passes the inputs down to the rest of your system
        specialArgs = { inherit inputs; };
        
        modules = [
          # System-level configurations
          ./hardware-configuration.nix
          ./configuration.nix
          
          # User-level configurations (Home Manager)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            
            # Tells Home Manager to read the home.nix file for your specific user
            home-manager.users.subhro = import ./home.nix;
          }
        ];
      };
    };
  };
}
