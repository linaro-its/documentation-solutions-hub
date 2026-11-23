auth commands
=============

The CLI tool requires authentication before other commands can be used. The
tokens created after authenticating are cached and can be used until they
expire.

``spire auth login``
--------------------

Authenticate using web browser login.

``spire auth refresh``
----------------------

Force a refresh of the access token and the authorization token.

``spire auth status``
---------------------

Shows the current authentication status. An optional flag ``--decode`` will
produce a table showing the permissions in the authorization token.

``spire auth token``
--------------------

Authenticate using a :ref:`personal access token<cli-user-pats>`.

The email address and token can be given with flags or environment variables.
Environment variables avoid exposing the token in process listings and shell
history.

* ``--email`` or ``SPIRE_EMAIL``

  The email address of the account the token belongs to. For a
  :doc:`service account<service-account>` or an
  :doc:`M2M account<m2m-account>`, this is the account's email address.

* ``--pat`` or ``SPIRE_PAT``

  The personal access token.

The session can optionally be narrowed to a subscription and/or a service:

* ``--subscription`` or ``SPIRE_SUBSCRIPTION``

  The ID of the subscription.

* ``--service`` or ``SPIRE_SERVICE``

  The ID of the service.

If the token itself is restricted, its own scope is always applied, and
requesting a different subscription or service is refused.

For example:

.. code-block:: bash

   export SPIRE_EMAIL=user@example.com
   export SPIRE_PAT=<token>
   spire auth token

.. note:: A session obtained with ``spire auth token`` cannot create, list or delete personal access tokens. Use ``spire auth login`` for that.
