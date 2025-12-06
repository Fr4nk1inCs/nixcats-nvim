_: _inputs: let
  overlay = _self: super: {
    astro-language-server = super.astro-language-server.overrideAttrs (
      finalAttrs: oldAttrs: {
        pnpmDeps = super.pnpm_10.fetchDeps {
          inherit
            (finalAttrs)
            pname
            version
            src
            pnpmWorkspaces
            prePnpmInstall
            ;
          fetcherVersion = 2;
          hash = "sha256-OHpSV612ysxQ6j6wKFcoPqJBKOUyPE3BJuwbft0lIHY=";
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
