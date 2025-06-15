set unstable := true

@_default:
    if test -t 0; then \
        just --choose 2>/dev/null || just --list; \
    else \
        just --list; \
    fi

fmt:
    just --fmt

build target="+build":
    earthly --ci {{ target }}
