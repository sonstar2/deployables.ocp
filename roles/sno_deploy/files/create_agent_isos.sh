#!/usr/bin/env bash
set -euo pipefail

echo "Creating tmux sessions, and initiating agent ISO build"
tmux new-session -d -s openshift-deploy
tmux split-window
tmux send-keys -t openshift-deploy:0.0 'openshift-install --dir /home/ansible/sno-a/ agent create image' ENTER
tmux send-keys -t openshift-deploy:0.1 'openshift-install --dir /home/ansible/sno-b/ agent create image' ENTER
tmux a -t openshift-deploy;