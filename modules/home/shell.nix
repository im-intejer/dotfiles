# Shells. zsh is the default on macOS, bash is kept for compatibility.
{ ... }:
{
  programs = {
    bash.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };
      # Add your own startup code with `initContent`, `envExtra` or `profileExtra`.
    };

    # Type `z <pattern>` to jump to a directory you have visited before.
    zoxide.enable = true;
  };
}
