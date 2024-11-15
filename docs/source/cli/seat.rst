seat commands
=============

``seat assign``
---------------

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

``seat remove``
---------------

Removes a previously-assigned seat from a user, removing any associated permissions from them.

.. note:: Any authorization token currently issued to the affected user is *not* revoked at this time.

Flags:

* ``-s`` or ``--seat``

  The ID of the seat to be removed.

If the seat ID is not provided and the command is being run in an interactive terminal, the user will be guided through an interactive selection process.

``seat add-permission``
-----------------------

Adds permissions to a user's existing seat.

Flags:

* ``-p`` or ``--permission``

  Specifies a permission ID to grant. Flag can be used more than once.

* ``-t`` or ``--target``

  Specifies a target ID - either a subscription ID or a resource ID. Flag can be used more than once.

* ``-s`` or ``--seat``

  Specifies the seat to be updated.

If any of the flags are missing and the command is being run in an interactive terminal, the user will be guided through an interactive selection process.

.. note:: It is not possible to mix a subscription ID and a resource ID as the target. Either a subscription ID must be specified, or one or more resource IDs must be specified.
