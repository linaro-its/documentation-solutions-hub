SPIRE CLI
=========

SPIRE is the technology behind Solutions Hub that manages the details for
organisations, users, subscriptions, seats, resources and permissions.

To help with the management of Solutions Hub while the web user interface is
being built, and to facilitate the use of SPIRE from a CI environment, a CLI
tool has been created.

As with the web user interface, the CLI tool is under active development and
the capabilities of the tool will be developed over time.

Please read the :ref:`installation instructions<cli-installation>` for
details on how to install the CLI tool.

In the following documentation, each of the CLI commands is explained.

.. note:: The CLI will only enable the commands that are possible with the permissions in the authorization token.

.. note:: The documented commands always reference ``spire``. This should be changed to ``dev-spire`` or ``staging-spire`` if required.

.. toctree::
   :maxdepth: 2

   auth
   org
   seat
   user

.. toctree::
   :hidden:

   installation
