# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something".
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  };

  # see :help nixCats.flake.outputs
  outputs = {
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      # allowUnfree = true;
    };
    # management of the system variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.
    # It gets resolved within the builder itself, and then passed to your
    # categoryDefinitions and packageDefinitions.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.

    # sometimes our overlays require a ${system} to access the overlay.
    # Your dependencyOverlays can either be lists
    # in a set of ${system}, or simply a list.
    # the nixCats builder function will accept either.
    # see :help nixCats.flake.outputs.overlays
    dependencyOverlays =
      (import ./overlays inputs)
      ++ [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      mkNvimPlugin,
      ...
    }: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          wget
          curl
          fd
          fzf
          lazygit
          ripgrep
          universal-ctags
          # core/editor
          yazi
          chafa
          # lsp & other utils
          ## lua
          lua-language-server
          stylua
          ## nix
          nixd
          alejandra
          deadnix
          statix
          ## python
          basedpyright
          ruff
          black
          isort
          ## c/c++/cuda + cmake
          clang-tools
          neocmakelsp
          cmake-format
          ## json & yaml
          vscode-langservers-extracted # for jsonls
          yaml-language-server
          ## bash
          bash-language-server
          shfmt
          shellharden
        ];

        extra =
          [
            # extra/editor
            lynx
            imagemagick
            ghostscript_headless
            # extra/languages
            ## go
            delve
            gotools
            gopls
            gofumpt
            gomodifytags
            impl
            ## harper
            harper
            ## latex
            texlab
            ## markdown
            marksman
            markdownlint-cli2
            ## rust
            rust-analyzer
            clippy
            ## typst
            tinymist
            websocat
            ## typescript
            vtsls
            ## frontend
            nodePackages.prettier
            eslint
            ## toml
            taplo
            ## astro
            astro-language-server
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [xdg-utils wsl-open]
          ++ lib.optionals pkgs.stdenv.isDarwin [coreutils-prefixed];
      };

      # NOTE: lazy doesnt care if these are in startupPlugins or optionalPlugins
      # also you dont have to download everything via nix if you dont want.
      # but you have the option, and that is demonstrated here.
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          lazy-nvim
          snacks-nvim
          plenary-nvim
          # core/coding
          ts-comments-nvim
          blink-cmp
          colorful-menu-nvim
          nvim-autopairs
          tabout-nvim
          rainbow-delimiters-nvim
          copilot-lua
          # core/editor
          trouble-nvim
          fzf-lua
          todo-comments-nvim
          which-key-nvim
          neo-tree-nvim
          flash-nvim
          yazi-nvim
          gitsigns-nvim
          undotree
          nvim-early-retirement
          hardtime-nvim
          # core/languages
          lazydev-nvim
          clangd_extensions-nvim
          cmake-tools-nvim
          SchemaStore-nvim
          # core/protocols
          nvim-lspconfig
          (nvim-treesitter.withPlugins (plugins:
            with plugins; [
              bash
              c
              cmake
              cpp
              cuda
              diff
              html
              javascript
              jsdoc
              json
              json5
              jsonc
              latex
              lua
              luadoc
              luap
              markdown
              markdown_inline
              ninja
              nix
              printf
              python
              query
              regex
              rst
              toml
              tsx
              typescript
              systemverilog
              vim
              vimdoc
              xml
              yaml
            ]))
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-treesitter-context
          (none-ls-nvim.overrideAttrs {name = "null-ls";})
          # core/ui
          incline-nvim
          nightfox-nvim
          smartcolumn-nvim
          mini-icons
          nui-nvim
          noice-nvim
          lualine-nvim
          persistence-nvim
        ];

        extra = [
          nvim-nio
          nvim-treesitter.withAllGrammars
          # extra/coding
          avante-nvim
          # extra/debug
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          # extra/editor
          grug-far-nvim
          nvim-highlight-colors
          codesnap-nvim
          # extra/external
          vim-wakatime
          (obsidian-nvim.overrideAttrs {
            # FIXME: remove once upstream updates
            version = "2025-06-23";
            src = pkgs.fetchFromGitHub {
              owner = "obsidian-nvim";
              repo = "obsidian.nvim";
              rev = "72412210d21c02351b9018f15be1a0bd0858b125";
              sha256 = "sha256-NQ6r0Eyd2NPjgFqGfMLzKuBhVvVOHVdC8AlFTWEXprA=";
            };
          })
          blink-compat
          (mkNvimPlugin (pkgs.fetchFromGitHub {
            owner = "keaising";
            repo = "im-select.nvim";
            rev = "6425bea7bbacbdde71538b6d9580c1f7b0a5a010";
            hash = "sha256-sE3ybP3Y+NcdUQWjaqpWSDRacUVbRkeV/fGYdPIjIqg=";
          }) "im-select.nvim")
          # extra/languages
          nvim-dap-python
          nvim-dap-go
          markdown-preview-nvim
          render-markdown-nvim
          rustaceanvim
          crates-nvim
          typst-vim
          typst-preview-nvim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      optionalPlugins = {};

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {general = [];};

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {test = {CATTESTVAR = "It worked!";};};

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [''--set CATTESTVAR2 "It worked again!"''];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {test = [(_: [])];};
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {test = [(_: [])];};
    };

    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = let
      # they contain a settings set defined above
      # see :help nixCats.flake.outputs.settings
      settings = {
        hosts = {
          python3.enable = true;
          node.enable = true;
          ruby.enable = true;
          perl.enable = true;
        };
        wrapRc = true;
        # IMPORTANT:
        # your alias may not conflict with your other packages.
        aliases = ["vim" "vi" "v"];
        # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      };
    in {
      # These are the names of your packages
      # you can include as many as you wish.
      nvim = {pkgs, ...}: {
        inherit settings;
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories =
          {
            general = true;
            extra = true;
            test = false;

            debugpy_python = with pkgs;
              lib.getExe (pkgs.python3.withPackages (ps: [ps.debugpy]));
            js_debug_server = "${pkgs.vscode-js-debug}/lib/node_modules/js-debug/src/dapDebugServer.js";
            codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
            astro_ts_plugin = "${pkgs.astro-language-server}/lib/astro-language-server/packages/ts-plugin";

            markdown_css = toString ./assets/terminal.css;
            highlight_css = toString ./assets/highlight.css;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
            skim = toString pkgs.skimpdf;
          };
        extra = {};
      };
      minivim = _: {
        settings = settings // {aliases = ["nvim" "vim" "vi" "v"];};
        categories = {
          general = true;
          extra = false;
          test = false;
        };
        extra = {};
      };
      # an extra test package with normal lua reload for fast edits
      # nix doesnt provide the config in this package, allowing you free rein to edit it.
      # then you can swap back to the normal pure package when done.
      testnvim = _: {
        settings = {
          wrapRc = false;
          unwrappedCfgPath = "/absolute/path/to/config";
        };
        categories = {
          general = true;
          test = false;
        };
        extra = {};
      };
    };
    # In this section, the main thing you will need to do is change the default package name
    # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nvim";
    # see :help nixCats.flake.outputs.exports
  in
    forEachSystem (system: let
      # the builder function that makes it all work
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs {inherit system;};
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = "";
        };
      };
    })
    // (let
      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModule = utils.mkNixosModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
