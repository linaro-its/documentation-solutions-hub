.. _cli-installation:

Installing the CLI
==================

The SPIRE CLI is available for Windows, MacOS and Linux, all for both Intel
and Arm processors. The CLI is distributed as a single binary file, which can
be downloaded from one of the following locations:

* Production: https://github.com/Linaro/SPIRE-CLI/releases
* Staging: https://github.com/Linaro/SPIRE-CLI-S-/releases
* Development: https://github.com/Linaro/SPIRE-CLI-D-/releases

.. note:: For most users, the production version is the correct version to use. Only use ``staging`` or ``development`` under direct instructions from Linaro.

Each of these URLs will take you to a list of available versions, with the
latest version at the top.

For each release, there are separate files for each operating system,
processor architecture and package format.

For Debian-based operating systems, there is a ``.deb`` file. This can be
installed using the following command:

```bash
sudo dpkg -i <file>.deb
```

After installation, you can run the CLI tool with ``spire``.

For Windows, Mac and other Linux distributions, there are ``.tar.gz`` or
``.zip`` files. These can be extracted to a directory of your choice. The CLI
tool can then be run from that directory with ``./spire`` or ``spire.exe``.
You may want to move the executable into a directory that is accessible
without needing to go into the directory first, e.g. a folder in ``$PATH``.
