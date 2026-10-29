# Fonts shared between NixOS (graphical) and darwin so terminals render identically.
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Custom fonts
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    # Coding fonts
    nerd-fonts.symbols-only
    fira-code
    victor-mono

    # Monochrome fallback for symbols and emoji that Fira Code lacks (unfree)
    symbola
  ];
}
