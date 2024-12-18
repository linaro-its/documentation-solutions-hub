Assigning a seat
================

To assign a seat to a user with the SPIRE CLI, the following information is required:

* Subscription ID
* Seat definition ID
* User ID

If some or all of that is known, it can be provided to the CLI tool as follows:

``spire seat assign -s <subscription id> -d <seat definition id> -u <user id> [--copy-permissions | --no-permissions]``

Any missing information will be requested via interactive prompts, as explained below.

It is **always** necessary to specify either ``--copy-permissions`` or ``--no-permissions``, regardless of how much or how little of the other information is provided on the command line.

If ``--copy-permissions`` is specified, all permissions for that seat that can be targeted at the subscription will be copied into the specified user's seat.

If ``--no-permissions`` is specified, no permissions are copied and it will be necessary to grant at least one permission before the assigned seat contributes anything to what the user can do.

Interactive assignment
----------------------

For any information needed to assign a seat that is not provided as a parameter on the command line, the CLI tool will prompt for and provide a list of possible choices.

If the subscription ID has not been provided, the tool will list those subscriptions for which the user is a subscription administrator. Use the left and right arrow keys to move through the list, press Return to select the desired subscription or CTRL+C to exit. If a subscription is selected, the tool displays the corresponding subscription ID for reference.

If the seat definition ID has not been provided, the tool will list the choices available for the chosen subscription. Use the left and right arrow keys to move through the list, press Return to select the desired seat definition or CTRL+C to exit. If a seat definition is selected, the tool displays the corresponding ID for reference.

If the user ID has not been provided, the tool will prompt for an email address to be typed in. As you start to type the email address, a list of matching users is displayed (limited to a maximum of 5 users). Once you can see the desired user, use cursor up/down keys to select the desired user and press Return.

.. note:: The CLI tool will only list those users that you have permission to retrieve, typically those in the same organisation as yourself. There will be a future enhancement to allow you to specify users by email address so that you can grant a seat to someone outside of your view.
