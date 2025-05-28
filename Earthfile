VERSION --raw-output 0.8

ARG --global BASE_BOOTC_IMAGE=ghcr.io/ublue-os/bazzite-nvidia:latest
ARG --global TARGET_CTR_REGISTRY=ghcr.io/zeglius

FROM alpine:latest
RUN apk add \
    git sed coreutils \
    || :

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
    ARG default_tag="latest"
    LET build_date = $(date +%Y%m%d)
    LET major_ver = $(lsb_release -rs || :)

    SAVE IMAGE --push $img_name:$default_tag               # by tag
    SAVE IMAGE --push $img_name:$build_date                # by build date
    SAVE IMAGE --push $img_name:$major_ver                 # major_ver
    SAVE IMAGE --push $img_name:$major_ver-$default_tag    # major_ver + tag
    SAVE IMAGE --push $img_name:$major_ver.$build_date     # major_ver + date
    IF [ "$default_tag" = "latest" ]
        SAVE IMAGE --push $img_name:stable                 # 'stable'
        SAVE IMAGE --push $img_name:$major_ver-stable      # major_ver + 'stable'
    END
