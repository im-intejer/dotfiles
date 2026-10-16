#!/usr/bin/env bash
commit_all() {
  git commit -a
  git push  
}

if [ -n "$(git status --porcelain)" ]; then
  echo "Uncommitted changes detected"
  while true; do
    # -p displays the prompt string, -r prevents backslash escaping
    read -p "Do you want to commit now? (y/n/FORCE) " yn -n 1 -r
    case $yn in
        [Yy]* )
          echo "Committing changes..."
          commit_all
          break
        ;;

        [Nn]* )
          echo "Exiting..."
          exit
        ;;

        FORCE )
          break
        ;;

        * )
          echo "Please answer yes or no."
        ;;
    esac
  done
 else
  echo "No change since last commit"
fi
echo "Recranking..."
# nix run .#activate
sudo nixos-rebuild switch --flake .#nixos

