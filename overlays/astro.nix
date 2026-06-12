_: _inputs: let
  overlay = _self: super: {
    astro-language-server = super.astro-language-server.overrideAttrs (
      finalAttrs: oldAttrs: {
        pnpmDeps = super.fetchPnpmDeps {
          inherit
            (finalAttrs)
            pname
            version
            src
            pnpmWorkspaces
            ;
          pnpm = super.pnpm_11.override {nodejs-slim = super.nodejs-slim_22;};
          fetcherVersion = 4;
          hash = "sha256-dqqvN8FMLjEbTtgQRkkURD7clMJ/OL9Mbk6icc4KU60=";
        };
        pnpmWorkspaces = oldAttrs.pnpmWorkspaces ++ ["@astrojs/ts-plugin..."];

        buildPhase = ''
          runHook preBuild

          pnpm --filter "@astrojs/language-server..." --filter "@astrojs/ts-plugin..." build

          runHook postBuild
        '';

        installPhase =
          builtins.replaceStrings [
            ''--filter="@astrojs/language-server..."''
            "{language-server,yaml2ts}"
          ]
          [
            ''--filter="@astrojs/language-server..." --filter="@astrojs/ts-plugin..."''
            "{language-server,yaml2ts,ts-plugin}"
          ]
          oldAttrs.installPhase;
      }
    );
  };
in
  overlay
