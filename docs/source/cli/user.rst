user commands
=============

``spire user create``
---------------------

Create a new user.

Flags:

* ``--email``

  The user's email address.

* ``--name``

  The user's first name.

* ``--surname``

  The user's surname.

* ``--displayname``

  The user's display name. If not specified, will be set automatically to be the first name and surname combined.

* ``--organisation``

  The ID of the organisation for this user.

.. note:: If the command is run in an interactive terminal and no flags have been specified, the user will be prompted to provide values. Only the email address is a required value.

``spire user describe``
-----------------------

Displays details of the authorised user or an alternative user if ``--user`` is specified with a user ID and the authorised user has permission to retrieve the details of that user.

Flags:

* ``-u`` or ``--user``

  The ID of the user to display. Only available if the authorised user has permission to read other users.

* ``--output``

  One of ``basic``, ``subs``, ``seats`` or ``perms``.
  
  ``basic`` (the default) displays the user's name, email address, ID and optional org ID.

  ``subs`` adds the details of any subscriptions that the user has access to.

  ``seats`` adds the details of any seats in those subscriptions.

  ``perms`` adds the details of any permissions in those seats.

The flag ``--json`` can be used to return the information in a JSON structure.

.. note:: If ``--json`` is specified, the output level will be ``subs``.

``spire user list``
-------------------

Lists the users in an organisation.

If used in interactive mode, presents the user with a paginated list of users and selecting a user will display that user's details as if ``user describe --output perms`` had been used.

If used in non-interactive mode, the details of every user are displayed. If ``--json`` is specified, the list of users is output in JSON format.

Flags:

* ``-o`` or ``--organisation``

  The ID of the organisation whose users are listed.

.. _cli-user-pats:

Personal access tokens
----------------------

Personal access tokens (PATs) let scripts and CI pipelines sign in with
``spire auth token`` instead of a web browser login.

* You can hold up to 15 unexpired tokens.
* Each token has a name that is unique among your tokens, and expires no more
  than 12 months after it is created.
* A token can optionally be restricted to one subscription and/or one service.
  Sessions created with a restricted token are limited to that scope.

.. note:: PATs can only be created, listed or deleted after signing in with ``spire auth login``. A session obtained with ``spire auth token`` cannot manage PATs.

``spire user create-pat``
-------------------------

Creates a personal access token for the authorised user.

The token value is shown **once**, in the output of this command, and cannot
be retrieved later. Store it somewhere safe straight away. Only the token
value is written to standard output, so it can be captured directly, for
example ``TOKEN=$(spire user create-pat --name ci --expires 6m)``. Details of
the token are written to standard error.

Flags:

* ``--name`` (required)

  A name for the token, unique among your tokens.

* ``--expires`` (required)

  When the token expires, at most 12 months from now. This can be a duration
  from now (``30d``, ``8w``, ``6m``, ``1y``), a date (``YYYY-MM-DD``, meaning
  00:00 UTC on that day) or an RFC 3339 timestamp.

* ``-s`` or ``--subscription``

  Restrict the token to this subscription ID.

* ``--service``

  Restrict the token to this service ID.

* ``--json``

  Output the token together with its details in a JSON structure.

.. note:: An error will be generated if you already have a token with the same name, or already hold 15 unexpired tokens.

``spire user list-pats``
------------------------

Lists the authorised user's personal access tokens, newest first, showing each
token's ID, name, hint (the first characters of the token), expiry, status and
scope. Token values are never shown.

Tokens marked ``legacy`` were created before multiple tokens were supported.

The flag ``--json`` can be used to return the information in a JSON structure.

``spire user delete-pat``
-------------------------

Deletes one of the authorised user's personal access tokens, identified by its
ID, for example ``spire user delete-pat pat:<uuid>``. Run ``spire user
list-pats`` to see the IDs.

Deleting a token also ends any sessions that were created with it.

``spire user get-pat``
----------------------

This command has been retired. Token values are no longer stored in a form
that can be retrieved, so a token is only shown when it is created.
