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

* ``--output``

  One of ``basic``, ``subs``, ``seats`` or ``perms``.
  
  ``basic`` (the default) displays the user's name, email address, ID and optional org ID.

  ``subs`` adds the details of any subscriptions that the user has access to.

  ``seats`` adds the details of any seats in those subscriptions.

  ``perms`` adds the details of any permissions in those seats.

.. note:: If ``--json`` is specified, the output level will be ``subs``.

``spire user list``
-------------------

If used in interactive mode, presents the user with a paginated list of users and selecting a user will display that user's details as if ``user describe --perms`` had been used.

If used in non-interactive mode or if ``--json`` is specified, the list of users is output in JSON format.

``spire user create-pat``
-------------------------

Creates a personal access token (PAT) for the authorised user. A user can only have one PAT at a time.

.. note:: An error will be generated if the PAT already exists.

``spire user get-pat``
----------------------

Retrieves the personal access token for the authorised user.

.. note:: An error will be generated if the PAT does not exist.

``spire user delete-pat``
-------------------------

Deletes the authorised user's personal access token if they have one.
