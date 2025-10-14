_: _inputs: let
  overlay = _self: super: {
    astro-language-server = super.astro-language-server.overrideAttrs (
      finalAttrs: oldAttrs: {
        pnpmDeps = super.pnpm_9.fetchDeps {
          inherit
            (finalAttrs)
            pname
            version
            src
            pnpmWorkspaces
            prePnpmInstall
            ;
          fetcherVersion = 1;
          hash = "sha256-QMFtUCuH9g/5ywa1OdIWjH2Dldwzeuzuj5GDp8yA+og=";
        };
        pnpmWorkspaces = oldAttrs.pnpmWorkspaces ++ ["@astrojs/ts-plugin..."];

        buildPhase = ''
          runHook preBuild

          # Must build the "@astrojs/yaml2ts" package. Dependency is linked via workspace by "pnpm"
          # (https://github.com/withastro/language-tools/blob/%40astrojs/language-server%402.14.2/pnpm-lock.yaml#L78-L80)
          pnpm --filter "@astrojs/language-server..." --filter "@astrojs/ts-plugin..." build

          runHook postBuild
        '';
      }
    );
  };
in
  overlay
