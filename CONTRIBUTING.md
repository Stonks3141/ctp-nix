# Contributing

## Adding a port

Create a file in `modules/<module>/` with the name of the port. Add the file to the
`imports` declaration in `modules/<module>/default.nix`. All ports should have the
`catppuccin.enable` and `catppuccin.flavour` options, and optionally the
`catppuccin.accent` option. `catppuccin.flavour` and `catppuccin.accent` should
default to `config.catppuccin.flavour` and `config.catppuccin.accent`, respectively.

[nvfetcher](https://github.com/berberman/nvfetcher) is used to track our upstream
sources to use in modules. This allows us to reduce [IFD](https://nixos.wiki/wiki/Import_From_Derivation)
and auto-update all themes. Most repositories can be specified like so:

```toml
[program_name]
src.git = "https://github.com/catppuccin/program_name.git"
fetch.github = "catppuccin/program_name"
```

After creating your module, add the options to enable it in `test.nix` under the
`nodes.machine` attrset. This will allow for your configuration to be tested along
with the other modules in a VM automatically.

<!-- This loooks the best with the changelog generator. -->
Commits that add ports should be of the format

```
feat(<nixos or home-manager>): add support for <port>
```

> **Note**
> Unofficial ports will not be accepted; all sources must be from the
> [Catppuccin](https://github.com/catppuccin) GitHub organization

## Commit messages

This repository uses [Conventional Commits](https://conventionalcommits.org).
Commit headers should be lowercase. Most commits should include a body that briefly
describes the motivation and content of the commit.

### Commit types

- `fix`: A bug fix that doesn't modify the public API
- `feat`: A code change that modifies the public API
- `refactor`: A code change that doesn't change behavior
- `style`: A style fix or change
- `docs`: Any change to documentation
- `ci`: Any change to CI files
- `revert`: A revert commit. The message should describe the reasoning and the
  commit should include the `Refs:` footer with the short hashes of the commits
  being reverted.
- `chore`: catch-all type

### Commit scopes

Available commit scopes are port names, `nixos`, `home-manager`, and `modules`. If
none of these apply, omit the scope.

### Breaking changes

All breaking changes should be documented in the commit footer in the format
described by Conventional Commits. Use the `<type>!` syntax in order to distinguish
breaking commits in the log, but include the footer to provide a better description
for the changelog generator.

```
feat(bar)!: foo the bars

BREAKING CHANGE: bars are now foo'ed
```

## For Maintainers

Use squash merges when reasonable. They don't pollute the log with merge commits, and
unlike rebase merges, list the author as the committer as well.
