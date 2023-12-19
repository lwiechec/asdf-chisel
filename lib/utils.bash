#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/jpillora/chisel"

fail() {
  echo -e "asdf-chisel: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if chisel is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' |
    grep -v 'dev[0-9]*' |
    cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version="$1"
  local filename="$2"

  case "$(uname -s)" in
    Linux*) platform=linux ;;
    Darwin*) platform=darwin ;;
  esac

  case "$(uname -m)" in
      x86_64) arch=amd64 ;;
      aarch64 | aarch64_be | armv8b | arm8vl) arch=arm64 ;;
  esac

  echo >&2 "* Downloading chisel release $version..."

  local url ext
  for ext in gz zip; do
      url="$GH_REPO/releases/download/$version/chisel_${version}_${platform}${arch}.${ext}"
      curl "${curl_opts[@]}" -o "$filename" -C - "$url" >&/dev/null && echo $ext && return
  done

  fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-chisel supports release installs only"
  fi

  local release_file="$install_path/bin/chisel-$version"
  (
    mkdir -p "$install_path/bin"
    local ext=$(download_release "$version" "$release_file")

    case "$ext" in
        gz) gzip -dc "$release_file.$ext" > "$install_path/bin" ;;
    esac

    rm "$release_file.$ext"

    local tool_cmd
    tool_cmd="chisel"
    chmod +x "$install_path/bin/$tool_cmd"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "chisel $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing chisel $version."
  )
}
