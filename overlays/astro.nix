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
          fetcherVersion = 2;
          hash = "sha256-26B2HCURyB57J6BqDgi1yBSUcILp0aEcx/qo9rkkbhc=";
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
