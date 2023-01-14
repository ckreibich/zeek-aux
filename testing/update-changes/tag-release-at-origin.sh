# Test update-changes -R when the repo is up to date with its origin. In that
# case, the release commit should become a new one.
#
# @TEST-EXEC: bash %INPUT
# @TEST-EXEC: cd clone && git describe --exact-match HEAD | grep -q v2.0.0
# @TEST-EXEC: cd clone && git log --format=%B -n 1 HEAD | grep -q 'Updating CHANGES and VERSION'
# @TEST-EXEC: cd clone && head -1 CHANGES | grep -q '^2.0.0'
# @TEST-EXEC: cd clone && test $(git rev-list --count HEAD) -eq 4

(
    mkdir origin && cd origin

    git init
    echo "Hello" >README
    git add README
    git commit -m 'init'
    git tag v1.0.0

    update-changes -I

    echo ... >>README
    git add README
    git commit -m 'readme update'
)

# We need an origin to control update-change's augment-vs-new-commit logic.
git clone origin clone

(
    cd clone

    # Suppress input prompts:
    export EDITOR=cat
    printf '\n' | update-changes -R v2.0.0
)
