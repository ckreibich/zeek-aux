# Verifies that update-changes correctly updates version strings in setup.py
# files to Python-style versions, when .update-changes.cfg instructs it.
#
# @TEST-EXEC: bash %INPUT
# @TEST-EXEC: btest-diff setup.py

@TEST-START-FILE .update-changes.cfg
function new_version_hook() {
    local version=$1
    replace_version_in_setup_py setup.py $version
}
@TEST-END-FILE

git init

cat >setup.py <<EOF
  version = "1.0",  # with comment
  version = "1.0.1-10",  # another comment
  version = "2.0.1.dev10",  # Python style
  version = "0.0.1.nope"   # should not change
EOF

git add setup.py
git commit -m 'init'
git tag v1.0.0

update-changes -I

echo ... >>setup.py
git add setup.py
git commit -m 'update'

# Suppress input prompts:
export EDITOR=cat
printf '\n' | update-changes
