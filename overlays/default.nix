/*
This file imports overlays defined in the following format.
Plugins will still only be downloaded if included in a category.
You may copy paste this example into a new file and then import that file here.
*/
# Example overlay:
/*
importName: inputs: let
  overlay = self: super: {
    ${importName} = {
      # define your overlay derivations here
    };
  };
in
overlay
*/
inputs: let
  overlaySet = {
    # this is how you would add another overlay file
    # for if your customBuildsOverlay gets too long
    # the name here will be the name used when importing items from it in your flake.
    # i.e. these items will be accessed as pkgs.nixCatsBuilds.thenameofthepackage
    astro = import ./astro.nix;
  };
in
  # calls the functions from the overlay files to create the overlays,
  # then puts them in a list.
  builtins.attrValues (builtins.mapAttrs (name: value: (value name inputs)) overlaySet)
