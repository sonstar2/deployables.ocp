#!/usr/bin/env bash
set -euo pipefail

echo "Creating tmux sessions, and initiating agent ISO build"
tmux new-session -d -s openshift-deploy
tmux split-window

echo "Starting OpenShift installation for Sled 1"
tmux send-keys -t openshift-deploy:0.0 'deploy-snoa' ENTER

echo "Starting OpenShift installation for Sled 2"
tmux send-keys -t openshift-deploy:0.1 'deploy-snob' ENTER

tmux a -t openshift-deploy;