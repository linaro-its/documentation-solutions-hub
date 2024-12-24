Delete permissions from a seat
==============================

The CLI offers two methods of removing permissions from seats - interactive and non-interactive.

With both methods, a list of permissions and/or a list of targets can be provided. The removal process behaviour depends on what has been provided:

* If a list of permissions is provided, but no targets, then those permissions will be removed regardless of the target.
* If a list of targets is provided, but no permissions, then any permission targeted at a target in the list will be removed.
* Otherwise, permissions matching the list of permissions and the list of targets will be removed.

.. note:: To remove permissions targeted at the subscription, leave the list of targets empty.

The non-interactive CLI syntax is:

``spire seat del-permission -s <seat id> -t <target id>[, <target id>] -p <permission id>[, <permission id>]``

Interactive use
---------------

If both permissions and targets are NOT provided, the CLI will prompt for missing information.

If the seat ID is missing, the CLI will prompt for a user and, once selected, will display the choice of seats available.

If no targets have been provided AND the existing permissions on the seat target resources, a list of resources from the permissions will be presented. You can select all of the targets, or individual targets, by using cursor up/down, SPACE to select/deselect and Enter to finish.

If no permissions have been specified, the CLI will list the permissions on the seat. You can then select all permissions or individual permissions using the same keys as for the target selection.

The CLI tool ends by displaying the JSON output resulting from removing the selected permissions.
