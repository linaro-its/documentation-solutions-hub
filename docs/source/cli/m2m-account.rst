m2m-account commands
====================

An M2M account is a non-human user that replaces an Auth0 machine-to-machine
(M2M) application. It signs in with
:ref:`personal access tokens<cli-user-pats>` (PATs), and its sessions get the
rights that its *M2M config* defines: its scopes, permitted resource types and
permitted solutions.

M2M accounts, their M2M config and their managers are defined by Linaro, so
there are no commands to create, change or delete them. The account's
**managers** create and delete its PATs and change its notification settings.

Every command that acts on one account takes it with ``-a`` or ``--account``,
followed by the account's ID (``user:<uuid>``). Most commands accept
``--json`` to return the information in a JSON structure.

``spire m2m-account list``
--------------------------

Lists the M2M accounts you can see, ordered by slug. Managers see the accounts
they manage, and super admins see every account.

Descriptions are cut short. Use ``spire m2m-account describe`` to see one in
full.

``spire m2m-account describe``
------------------------------

Shows an M2M account, with its full description and its M2M config. A PAT for
the account can only be restricted to a subscription in one of the permitted
solutions, and to one of the services its scopes name.

``spire m2m-account managers``
------------------------------

Lists the users and groups that manage an M2M account, each with the ID of the
seat that makes them a manager.

``spire m2m-account create-pat``
--------------------------------

Creates a PAT for an M2M account you manage. This works like
:ref:`spire service-account create-pat<cli-managed-account-pats>`, with the
same flags and limits.

``spire m2m-account list-pats``
-------------------------------

Lists an M2M account's PATs. Token values are never shown.

``spire m2m-account delete-pat``
--------------------------------

Deletes one of an M2M account's PATs, identified by its ID. Deleting a token
also ends any sessions that were created with it.

``spire m2m-account get-notification-settings``
-----------------------------------------------

Shows whether an M2M account gets notifications by email, and after how many
days its notifications are archived.

``spire m2m-account set-notification-settings``
-----------------------------------------------

Changes an M2M account's notification settings. This takes the same flags as
``spire service-account set-notification-settings``.

Signing in as an M2M account
----------------------------

A client signs in with ``spire auth token``, using the account's email address
(shown by ``spire m2m-account describe``) as the username. For example, a
manager creates a token and the client then uses it:

.. code-block:: bash

   spire m2m-account create-pat --account user:<uuid> --name git-sync --expires 6m

   export SPIRE_EMAIL=git-sync@m2m-accounts.invalid
   export SPIRE_PAT=<token>
   spire auth token
