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
            prePnpmInstall
            ;
          pnpm = super.pnpm_10;
          fetcherVersion = 3;
          hash = "sha256-u9k6+BiQOAPKfl0w2NlSzGIUJD/77xJChJojvbCaJeI=";
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
