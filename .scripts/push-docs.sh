#!/bin/bash
set -e

DOCS_DIR=docs

function add_docs {
    if test -d "${DOCS_DIR}"; then
        git add "${DOCS_DIR}/*"
    fi

    for d in $(ls modules/); do
        if test -d "modules/${d}/${DOCS_DIR}"; then
            git add "modules/${d}/${DOCS_DIR}/*"
        fi
    done
}

function commit_docs {
    git commit -m "docgen [skip ci]"
}

function push_docs {
    git push "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" HEAD:"${GITHUB_REF}"
}

add_docs
commit_docs
push_docs