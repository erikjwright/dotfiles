{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        python = pkgs.python312;
      in
      # pythonEnv = python.withPackages (p: [
      #   p.pyodbc
      # ]);
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            freetds
            gcc
            openssl
            openssl_1_1
            python
            # pythonEnv
            pyright
            ruff
            sqlcmd
            unixODBC
            unixODBCDrivers.msodbcsql17
            uv
          ];

          shellHook = ''
            export ODBCINI=/home/erik/odbcinst.ini
            export ODBCSYSINI=/home/erik
            export LD_LIBRARY_PATH=${pkgs.freetds}/lib:${pkgs.openssl}/lib:${pkgs.openssl_1_1}/lib:${pkgs.unixODBC}/lib:${pkgs.unixODBCDrivers.msodbcsql17}/lib:${pkgs.stdenv.cc.cc.lib}/lib
            export UV_PYTHON_PREFERENCE="only-system"
            export UV_PYTHON=${python}
            if [ ! -d ".venv" ]; then
              uv venv .venv
            fi
            source .venv/bin/activate
          '';
        };
      }
    );
}
