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

Authenticate using personal access token. The command requires two flags:
``--email`` followed by the email address and ``--pat`` followed by the
access token.
