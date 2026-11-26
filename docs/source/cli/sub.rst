sub commands
============

``spire sub list``
------------------

Presents a list of the subscriptions you administer. Selecting a subscription
displays its details as if ``spire sub describe`` had been used.

.. note:: This command is interactive, so it must be run in an interactive terminal.

``spire sub describe``
----------------------

Displays the details of a subscription: its name, owner, renewal and expiry
details and plan. For each seat definition in the subscription, it shows how
many seats are used out of the limit, and who has been assigned those seats.

Flags:

* ``-s`` or ``--subscription``

  The ID of the subscription to display.
