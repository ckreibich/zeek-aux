# Verifies that update-changes correctly updates version strings in
# shell/Python/etc scripts, when .update-changes.cfg instructs it.
#
# @TEST-EXEC: bash %INPUT
# @TEST-EXEC: btest-diff test.pl

@TEST-START-FILE .update-changes.cfg
function new_version_hook() {
    local version=$1
    replace_version_in_script test.sh $version
}
@TEST-END-FILE

git init

cat >test.pl <<EOF
VERSION="1.0.0"
VERSION = "2.0.0"  # with some comment
EOF

git add test.pl
git commit -m 'init'
git tag v1.0.0

update-changes -I

echo ... >>test.pl
git add test.pl
git commit -m 'update'

# Suppress input prompts:
export EDITOR=cat
printf '\n' | update-changes
