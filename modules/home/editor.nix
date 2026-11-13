{ config, ... }: {

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      # theme = "gruvbox-material";
      theme = "noctalia";

      keys.normal.space.i = ":toggle lsp.display-inlay-hints";

      editor = {
        bufferline = "always";
        completion-timeout = 5;
        completion-replace = true;
        completion-trigger-len = 1;
        color-modes = true;

        cursor-shape.insert = "bar";

        lsp = {
          display-inlay-hints = true;
          inlay-hints-length-limit = 12;
          display-progress-messages = true;
        };

        inline-diagnostics.cursor-line = "hint";

        soft-wrap = {
          enable = true;
          max-indent-retain = 0;
          wrap-indicator = "";
        };
      };
    };

    languages = {
      language-server.rust-analyzer.config.check.command = "clippy";

      rust = [
        {
          config = {
            inlayHints = {
              bindingModeHints.enable = false;
              closingBraceHints.minLines = 10;
              closureReturnTypeHints.enable = "with_block";
              discriminantHints.enable = "fieldless";
              lifetimeElisionHints.enable = "skip_trivial";
              typeHints.hideClosureInitialization = false;
            };
          };
        }
      ];

      language = [
        {
          name = "flare";
          scope = "source.flare";
          grammar = "flare";
          injection-regex = "flare";
          file-types = [
            "flare"
            "flr"
          ];
          comment-tokens = "#";
          indent = {
            tab-width = 4;
            unit = "   ";
          };
        }
      ];

      grammar = [
        {
          name = "flare";
          source = {
            git = "https://github.com/UPWRD1/tree-sitter-flare.git";
            rev = "1b464a4159bdd2f7578aa7fc76742fc476870591";
          };
        }
      ];
    };
  };
}
