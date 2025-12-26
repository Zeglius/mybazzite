VERSION --raw-output --wildcard-copy 0.8

ARG --global BASE_IMAGE=${BASE_IMAGE:-ghcr.io/ublue-os/bazzite-nvidia:latest}
ARG --global TARGET_CTR_REGISTRY=${TARGET_CTR_REGISTRY:-ghcr.io/zeglius}


INSTALL_PACKAGES:
    FUNCTION
    COPY ./packages/*+build/out/. /
    # Run hooks
    RUN find /run/.posthooks -type f -name "*.sh" -print -executable -exec {} \; -exec rm {} \; && \
        rm -rf /run/.posthooks


build:
    ARG branch
    ARG --required commit_hash
    ARG IMAGE_NAME
    IF [ "$IMAGE_NAME" = "" ]
        SET IMAGE_NAME = $(echo "$BASE_IMAGE" | sed -E -e 's|([^/]*/)*||' -e 's|:.*||')
    END
    FROM DOCKERFILE \
        -f Containerfile \
        --build-arg BASE_IMAGE=$BASE_IMAGE \
        .
    DO +INSTALL_PACKAGES
    DO +SAVE_IMAGE --img_name=${TARGET_CTR_REGISTRY}/${IMAGE_NAME} --branch=$branch --commit_hash=$commit_hash


SAVE_IMAGE:
    FUNCTION
    ARG img_name
    ARG branch
    ARG --required commit_hash

    ARG default_tag=$(echo ${branch:-git-$commit_hash} | sed -E 's/(main|master)/latest/')
    LET build_date = $(date +%Y%m%d)
    LET major_ver = $(lsb_release -rs)
    LET tags = ${img_name:?}:$default_tag \
                ${img_name}:$build_date \
                ${img_name}:$major_ver \
                ${img_name}:$major_ver-$default_tag \
                ${img_name}:$major_ver.$build_date \
                ${img_name}:git-${commit_hash:?}
    IF [ "$default_tag" = "latest" ]
        SET tags = $tags \
            ${img_name}:stable \
            ${img_name}:$major_ver-stable
    END
    SET tags = $(echo $tags | sort -u)
    FOR img IN $tags
        SAVE IMAGE --push $img
    END
