#!/bin/sh
# Fluxmania Legacy — everything the worker image needs. The Dockerfile in your copy downloads this file
# from the original repo on every build, so fixes made there reach you with a rebuild.
set -eu
case "${CIVITAI_TOKEN:-}" in ""|PASTE_*) echo "ERROR: set CIVITAI_TOKEN at the top of the Dockerfile" >&2; exit 1;; esac

# file <dest> <url> <sha256>
file() {
  wget -q -O "$1" "$2"
  echo "$3  $1" | sha256sum -c - || { echo "ERROR: $1 changed upstream — wait for an update of the original repo, then rebuild" >&2; exit 1; }
}

# Civitai 778691 / version 1769925 (11.1 GB)
file /comfyui/models/diffusion_models/fluxmania_Legacy.safetensors \
  "https://civitai.com/api/download/models/1769925?fileId=1670846&token=${CIVITAI_TOKEN}" \
  d94dd45c94a5497f3b873f4195477652eb515624e0ed1878eddf0b0abeaed9b7

# comfyanonymous/flux_text_encoders (4.9 GB)
file /comfyui/models/text_encoders/t5xxl_fp8_e4m3fn.safetensors \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/6af2a98e3f615bdfa612fbd85da93d1ed5f69ef5/t5xxl_fp8_e4m3fn.safetensors" \
  7d330da4816157540d6bb7838bf63a0f02f573fc48ca4d8de34bb0cbfd514f09

# comfyanonymous/flux_text_encoders (0.2 GB)
file /comfyui/models/text_encoders/clip_l.safetensors \
  "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/6af2a98e3f615bdfa612fbd85da93d1ed5f69ef5/clip_l.safetensors" \
  660c6f5b1abae9dc498ac2d21e1347d2abdb0cf6c0c0c8576cd796491d9a6cdd

# Comfy-Org repack (FLUX VAE) (0.3 GB)
file /comfyui/models/vae/ae.safetensors \
  "https://huggingface.co/Comfy-Org/Lumina-Image-2/resolve/5b072540ef86570fecb8249c505f23d5bdeb88cd/split_files/vae/ae.safetensors" \
  afc8e28272cd15db3919bacdb6918ce9c1ed22e96cb12c4d5ed0fba823529e38
