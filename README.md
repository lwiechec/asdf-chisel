<div align="center">

# asdf-chisel [![Build](https://github.com/lwiechec/asdf-chisel/workflows/Build/badge.svg)](https://github.com/lwiechec/asdf-chisel/actions/workflows/build.yml) [![Lint](https://github.com/lwiechec/asdf-chisel/workflows/Lint/badge.svg)](https://github.com/lwiechec/asdf-chisel/actions/workflows/lint.yml)

[chisel](https://github.com/jpillora/chisel) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add chisel https://github.com/lwiechec/asdf-chisel.git
```

chisel:

```shell
# Show all installable versions
asdf list-all chisel

# Install specific version
asdf install chisel latest

# Set a version globally (on your ~/.tool-versions file)
asdf global chisel latest

# Now babashka commands are available
chisel --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/lwiechec/asdf-chisel/graphs/contributors)!

# Thanks

This repository is adapted from [adsf-babashka](https://github.com/fredZen/asdf-babashka) by
[Frederic Merizen](https://github.com/fredZen).

# License

Distributed under the [Eclipse Public License](LICENSE), the same as [adsf-babashka](https://github.com/fredZen/asdf-babashka).
© [Lukasz Wiechec](https://github.com/lwiechec/)
