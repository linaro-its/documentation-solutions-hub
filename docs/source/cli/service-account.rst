service-account commands
========================

A service account is a non-human user that an organisation administrator
creates in their organisation. It signs in with
:ref:`personal access tokens<cli-user-pats>` (PATs), and its own rights come
from the seats it holds, like any other user.

* **Organisation administrators** create, change and delete service accounts.
* **Managers** are the users and groups that an organisation administrator
  assigns to the account with the *Service Account Manager* seat. Managers
  create and delete the account's PATs and change its notification settings.

An organisation administrator who needs to manage a service account's PATs
assigns the Service Account Manager seat to themselves first.

Every command that acts on one account takes it with ``-a`` or ``--account``,
followed by the account's ID (``user:<uuid>``). Most commands accept
``--json`` to return the information in a JSON structure.

``spire service-account create``
--------------------------------

Creates a service account in an organisation where you are an organisation
administrator.

Flags:

* ``-o`` or ``--organisation`` (required)

  The ID of the organisation for the account.

* ``--displayname`` (required)

  The account's display name.

* ``--name``

  The account's first name.

* ``--surname``

  The account's surname.

* ``--email``

  A real mailbox for the account, if it should receive notification emails.
  If not specified, SPIRE generates an address that can't receive mail.

* ``--description``

  What the account is for, where its tokens are used, and who owns the client.
  At most 1,000 characters of plain text. Never put a token, password or other
  secret in a description.

.. note:: The account's email address is its username for ``spire auth token``, whether you give one or SPIRE generates it.

``spire service-account list``
------------------------------

Lists the service accounts you can see. Organisation administrators see their
organisation's accounts, managers see the accounts they manage, and super
admins see every account.

Descriptions are cut short. Use ``spire service-account describe`` to see one
in full.

Flags:

* ``-o`` or ``--organisation``

  Only list accounts in this organisation.

``spire service-account describe``
----------------------------------

Shows a service account, with its full description and the subscriptions it
holds seats in. A PAT for the account can only be restricted to one of those
subscriptions.

``spire service-account update``
--------------------------------

Changes a service account's names, email address or description. Only
organisation administrators of the account's organisation can do this. Fields
that aren't specified are unchanged.

Flags:

* ``--displayname``

  The new display name.

* ``--name``

  The new first name. ``--name ""`` clears it.

* ``--surname``

  The new surname. ``--surname ""`` clears it.

* ``--email``

  A new real mailbox. ``--email ""`` replaces a real mailbox with a generated
  address.

* ``--description``

  The new description. ``--description ""`` clears it.

.. warning:: The email address is the account's username for ``spire auth token``. Changing it doesn't affect existing tokens, but every client must then sign in with the new address. Tell the account's managers first.

``spire service-account delete``
--------------------------------

Deletes a service account. Only organisation administrators of the account's
organisation can do this, and it can't be undone. Deleting the account deletes
its PATs, ends its sessions and removes its managers' rights on it.

You are asked to type the account's display name to confirm.

Flags:

* ``-y`` or ``--yes``

  Delete without asking for confirmation, for example in a script.

.. note:: If the command isn't run in an interactive terminal, ``--yes`` is required.

``spire service-account managers``
----------------------------------

Lists the users and groups that manage a service account, each with the ID of
the seat that makes them a manager.

.. _cli-managed-account-pats:

``spire service-account create-pat``
------------------------------------

Creates a PAT for a service account you manage. This takes the same flags as
``spire user create-pat`` (``--name``, ``--expires``, ``--subscription``,
``--service`` and ``--json``) and has the same limits: each account can hold
up to 15 unexpired tokens, and each token expires no more than 12 months after
it is created.

The token value is shown **once** and cannot be retrieved later. The command
also shows the ``spire auth token`` command to sign in as the account.

For example:

.. code-block:: bash

   spire service-account create-pat --account user:<uuid> --name ci-pipeline --expires 90d

.. note:: PATs can only be created, listed or deleted after signing in with ``spire auth login``. A session obtained with ``spire auth token`` cannot manage PATs.

``spire service-account list-pats``
-----------------------------------

Lists a service account's PATs, in the same format as ``spire user
list-pats``. Token values are never shown.

``spire service-account delete-pat``
------------------------------------

Deletes one of a service account's PATs, identified by its ID, for example
``spire service-account delete-pat --account user:<uuid> pat:<uuid>``.
Deleting a token also ends any sessions that were created with it.

``spire service-account get-notification-settings``
---------------------------------------------------

Shows whether a service account gets notifications by email, and after how
many days its notifications are archived.

``spire service-account set-notification-settings``
---------------------------------------------------

Changes a service account's notification settings. Settings that aren't
specified are unchanged.

Flags:

* ``--email-enabled``

  Turns email notifications on. ``--email-enabled=false`` turns them off.
  Email can only be turned on for an account with a real email address.

* ``--auto-archive-days``

  Archive notifications after this many days, from 1 to 90. ``default`` uses
  the system default.
