#!/bin/bash
set -e

DOCS_DIR=docs

function setup {
    # use GH private email
    git config user.email "54330374+hc-team-tfe@users.noreply.github.com"
    git config user.name "tfe-docgen"
}

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
    git push
}

# setup
# add_docs
commit_docs
# push_docs