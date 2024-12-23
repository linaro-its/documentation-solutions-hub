Add permissions to a seat
=========================

The CLI offers two methods of adding permissions to seats - interactive and non-interactive.

With the non-interactive method, all of the information required is passed on the command line:

``spire seat add-permission -s <seat id> -t <target id>[, <target id>] -p <permission id>[, <permission id>]``

Interactive assignment
----------------------

For any information needed to add permissions to a seat that is not provided as a parameter on the command line, the CLI tool will prompt for and provide a list of possible choices.

If the seat ID is missing, the CLI will prompt for a user and, once selected, will display the choice of seats available.

If the target ID is missing, the CLI will check the seat to see if there are any permissions already assigned to the seat. If there are and the target is the subscription ID, the CLI will automatically select the same subscription ID as the target. Otherwise, the CLI will list the resources available within the subscription as possible targets. One or more resources can be selected by using the cursor up/down keys and the space bar to select/deselect, finishing with pressing Enter when the selection is correct.

If the permission ID is missing, the CLi will list the permissions allowed by the seat definition, as well as a "Select all" option. Use the cursor up/down keys and the space bar to make the appropriate selection, and press Enter when complete.

.. note:: The CLI does not show which permissions, if any, have already been assigned. No error will occur if the permissions are assigned when already assigned.

The CLI tool ends by displaying the JSON output resulting from adding the selected permissions.
