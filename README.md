---
title: SubatomicERROR
emoji: 🏃
colorFrom: green
colorTo: indigo
sdk: docker
python_version: 3.10
sdk_version: latest
suggested_hardware: cpu-basic
suggested_storage: small
app_file: app.py
app_port: 7860
base_path: /
fullWidth: true
header: default
short_description: "A Quantum-AI-powered space by SubatomicERROR."
models:
  - openai-community/gpt2
datasets:
  - mozilla-foundation/common_voice_13_0
tags:
  - quantum-ai
  - machine-learning
  - docker
thumbnail: "https://your-thumbnail-url.com/thumbnail.png"
pinned: false
hf_oauth: false
disable_embedding: false
startup_duration_timeout: "30m"
custom_headers:
  cross-origin-embedder-policy: require-corp
  cross-origin-opener-policy: same-origin
  cross-origin-resource-policy: cross-origin
preload_from_hub:
  - openai-community/gpt2 config.json
---
