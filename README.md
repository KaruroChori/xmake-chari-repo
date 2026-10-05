Just to avoid duplication of these package definitions in 10s of projects.  
Not meant for general consumption, PRs and Issues are left open but they will generally not be accepted.

## Releasing a new version

`tools/bump-version.sh <package> <version> <sha>` adds or updates an
`add_versions("vX.Y.Z", "<sha>")` entry in that package's `xmake.lua` (newest
first). It is idempotent and validates both the version and the SHA. Run it
locally, or drive it from CI.

### From a package repo (Forgejo Actions)

On a tag push, a package repo can ask the registry to bump itself:

```sh
version="${GITHUB_REF_NAME#v}"
sha=$(git rev-parse HEAD)
curl -fsS -X POST \
  -H "Authorization: token $CHARI_REPO_TOKEN" \
  -H "Content-Type: application/json" \
  "https://git.chatomari.work/api/v1/repos/lazy-eggplant/xmake-chari-repo/actions/workflows/bump-version.yml/dispatches" \
  -d "{\"ref\":\"master\",\"inputs\":{\"package\":\"kd3\",\"version\":\"$version\",\"sha\":\"$sha\"}}"
```

`CHARI_REPO_TOKEN` is a repo/org secret with Actions write access on
`lazy-eggplant/xmake-chari-repo`. The `bump-version` workflow then commits the
change straight to `master`.

Requires a Forgejo Actions runner with the `ubuntu-latest` label registered for
this repository.
