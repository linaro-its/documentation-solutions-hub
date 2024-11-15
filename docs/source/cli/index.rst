SPIRE CLI
=========

SPIRE is the technology behind Solutions Hub that manages the details for organisations, users, subscriptions, seats, resources and permissions.

To help with the management of Solutions Hub while the web user interface is being built, and to facilitate the use of SPIRE from a CI environment, a CLI tool has been created.

The tool is available for Windows, MacOS and Linux, all for both Intel and Arm processors.

As with the web user interface, the CLI tool is under active development and the capabilities of the tool will be developed over time.

There are separate distributions for the CLI tool, depending on which SPIRE deployment you are interacting with:

* Development: https://github.com/Linaro/SPIRE-CLI-D-/releases/tag/0.2.0-alpha%2B010
* Staging: https://github.com/Linaro/SPIRE-CLI-S-/releases/tag/0.2.0-alpha%2B010
* Production: https://github.com/Linaro/SPIRE-CLI/releases/tag/0.2.0-alpha%2B010

In the following documentation, each of the CLI commands is explained.

.. note:: The CLI will only enable the commands that are possible with the permissions in the authorization token.

.. note:: The documented commands always reference ``spire``. This should be changed to ``dev-spire`` or ``staging-spire`` if required.

.. toctree::
   :maxdepth: 2

   auth
   org
   seat
   user
