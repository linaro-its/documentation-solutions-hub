seat commands
=============

``spire seat assign``
---------------------

Assigns a seat to a user from a seat definition.

Flags:

* ``-c`` or ``--copy-permissions``
  
  Copy all subscription-targeted permissions to the seat

* ``-n`` or ``--no-permissions``

  Do not copy any permissions to the seat.

* ``-d`` or ``--seat-def``

  The ID of the seat definition for the seat to be assigned.

* ``-s`` or ``--subscription``

  The ID of the subscription for this seat.

* ``-u`` or ``--user``

  The ID of the user being assigned this seat.

Either ``--copy-permissions`` or ``--no-permissions`` *must* be specified.

For the other flags, if the command is being run in an interactive terminal and some values are missing, the user will be guided through interactive selection of the answers.

The flag ``--json`` can be used to return the information from the assigned seat in a JSON structure.

``spire seat remove``
---------------------

Removes a previously-assigned seat from a user, removing any associated permissions from them.

.. note:: Any authorization token currently issued to the affected user is *not* revoked at this time.

Flags:

* ``-s`` or ``--seat``

  The ID of the seat to be removed.

If the seat ID is not provided and the command is being run in an interactive terminal, the user will be guided through an interactive selection process.

``spire seat add-permission``
-----------------------------

Adds permissions to a user's existing seat.

Flags:

* ``-p`` or ``--permission``

  Specifies a permission ID to grant. Multiple permissions can be provided, separated by commas.

* ``-t`` or ``--target``

  Specifies a target ID - either a subscription ID or a resource ID. If specifying resource IDs, multiple IDs can be provided, separated by commas.

* ``-s`` or ``--seat``

  Specifies the seat to be updated.

If any of the flags are missing and the command is being run in an interactive terminal, the user will be guided through an interactive selection process.

.. note:: If more than one target is specified, the targets must be resources.

.. note:: It is not possible (or appropriate) to mix a subscription target with resource targets. If the seat already has permissions applied, the new permissions must have matching target types.
