VERSION --raw-output 0.8

ARG --global BASE_BOOTC_IMAGE=ghcr.io/ublue-os/bazzite-nvidia:testing
ARG --global TARGET_CTR_REGISTRY=ghcr.io/zeglius

FROM alpine:latest
RUN apk add \
    git sed coreutils \
    || :

COPY ./. ./
ARG --global branch=$(git branch --show-current)
ARG --global commit_hash=$(git rev-parse --short HEAD)

INSTALL_PACKAGES:
    FUNCTION
    COPY ./packages/ananicy-cpp+build/out/. /
    COPY ./packages/ananicy-rules+build/out/. /
    COPY ./packages/nydus+build/out/. /
    # Run hooks
    RUN find /run/.posthooks -type f -name "*.sh" -print -executable -exec {} \; -exec rm {} \;
    RUN rm -rf /run/.posthooks

build:
    ARG BASE_IMAGE=${BASE_BOOTC_IMAGE}
    ARG TARGET_CTR_REGISTRY=$TARGET_CTR_REGISTRY
    FROM DOCKERFILE \
        -f Containerfile \
        --build-arg BASE_IMAGE=$BASE_IMAGE \
        .
    DO +INSTALL_PACKAGES
    DO +SAVE_IMAGE --img_name=${TARGET_CTR_REGISTRY}/mybazzite

SAVE_IMAGE:
    FUNCTION
    ARG img_name
    ARG default_tag=$(echo $branch | sed -E 's/(main|master)/latest/')
    LET build_date = $(date +%Y%m%d)
    LET major_ver = $(lsb_release -rs || :)
    LET tags = ${img_name:?}:$default_tag \
                ${img_name:?}:$build_date \
                ${img_name:?}:$major_ver \
                ${img_name:?}:$major_ver-$default_tag \
                ${img_name:?}:$major_ver.$build_date \
                ${img_name:?}:git-${commit_hash:?}
    IF [ "$default_tag" = "latest" ]
        SET tags = $tags \
            ${img_name:?}:stable \
            ${img_name:?}:$major_ver-stable
    END
    SET tags = $(echo $tags | sort -u)
    FOR img IN $tags
        SAVE IMAGE --push $img
    END
