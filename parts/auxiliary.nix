{self, ...}: {
  perSystem = {
    config,
    pkgs,
    inputs',
    self',
    system,
    ...
  }: {
    formatter = self.packages.${system}.alejandra;

    devShells.default = pkgs.mkShell {
      packages = builtins.attrValues {
        inherit (self'.packages) nil alejandra;
        inherit (inputs'.unstable.legacyPackages) rust-analyzer rustc cargo rustfmt clippy openssl pkg-config;
      };
    };
  };
}
