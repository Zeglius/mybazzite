#!/bin/bash
# Usage: IMAGES_TO_RETAG="ghcr.io/ublue-os/IMAGE1" INPUT_TAG="41.20250421" OUTPUT_TAGS="latest" ./retag.sh

set -euxo pipefail

# Error handling with GitHub Actions compatible error output
trap 'echo "::error file=${0},line=${LINENO}::Something went wrong"' ERR

if [[ " $* " == @(-h|--help) ]]; then
    echo "Usage: IMAGES_TO_RETAG=\"ghcr.io/ublue-os/IMAGE1\" INPUT_TAG=\"41.20250421\" OUTPUT_TAGS=\"latest\" FINAL_LATS ./${0##*/}"
    exit 0
fi

# Initialize a string, containing pairs of <input_tag> and <output_tag>,
# separated by newlines.
skopeo_params=""

for _src_img in $IMAGES_TO_RETAG; do
    for _tag in $OUTPUT_TAGS; do
        # Strip any existing tags or digests from the image reference and append the new tag
        _img="${INPUT_REF}"
        _img="${_img%%:*}"
        _img="${_img%%@*}"
        skopeo_params+="${_src_img}:${INPUT_TAG} ${_img}:${_tag}"
        skopeo_params+=$'\n'
    done
done

declare -p skopeo_params

summary_log=""

# Login into Github Container Registry in skopeo
echo "${GITHUB_TOKEN}" | sudo skopeo login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin

while read -r _src_img _dst_img; do
    # Check each img is valid
    for _img in $_src_img $_dst_img; do
        if [[ $(grep -o ':' <<<"$_img" | wc -l) -ne 1 ]]; then
            echo "::error::Invalid image reference: $_img"
            exit 1
        fi
    done

    if sudo skopeo copy docker://"$_src_img" docker://"$_dst_img"; then
        summary_log+="$_src_img -> $_dst_img"
        summary_log+=$'\n'
    fi
done <<<"$skopeo_params"

# Copy the input image to each of the final image references
echo "# Image retaggins" >>"${GITHUB_STEP_SUMMARY}"
while read -r _line; do
    {
        echo '```'
        echo "$_line"
        echo '```'
    } >>"${GITHUB_STEP_SUMMARY}"
done <<<"$summary_log"
