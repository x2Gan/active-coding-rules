#!/usr/bin/env bash

set -euo pipefail

readonly SKILL_NAME="active-coding-rules"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SOURCE_DIR="${SCRIPT_DIR}/${SKILL_NAME}"

usage() {
	cat <<EOF
Usage: $(basename "$0") -path <skills_parent_dir>

Create a symlink named ${SKILL_NAME} under <skills_parent_dir>.

Example:
	$(basename "$0") -path /home/gangan/ZeppOS/.codex/skills
EOF
}

main() {
	if [[ $# -eq 1 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
		usage
		exit 0
	fi

	if [[ $# -ne 2 || "$1" != "-path" || -z "${2:-}" ]]; then
		usage
		exit 1
	fi

	if [[ ! -d "$SOURCE_DIR" ]]; then
		echo "Error: skill source directory not found: $SOURCE_DIR" >&2
		exit 1
	fi

	local parent_dir="$2"
	if [[ "$parent_dir" != "/" ]]; then
		parent_dir="${parent_dir%/}"
	fi

	mkdir -p "$parent_dir"

	local destination_link="${parent_dir}/${SKILL_NAME}"

	if [[ -L "$destination_link" ]]; then
		local resolved_link_target
		resolved_link_target="$(readlink -f "$destination_link")"
		if [[ "$resolved_link_target" == "$SOURCE_DIR" ]]; then
			echo "Skill already installed: $destination_link -> $SOURCE_DIR"
			exit 0
		fi

		echo "Error: destination symlink already points elsewhere: $destination_link -> $resolved_link_target" >&2
		exit 1
	fi

	if [[ -e "$destination_link" ]]; then
		echo "Error: destination already exists and is not a symlink: $destination_link" >&2
		exit 1
	fi

	ln -s "$SOURCE_DIR" "$destination_link"
	echo "Installed skill: $destination_link -> $SOURCE_DIR"
}

main "$@"
