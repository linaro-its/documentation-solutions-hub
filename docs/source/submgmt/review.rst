Review subscription seats
=========================

The command ``spire sub list`` will display a picker, allowing you to cycle through the subscriptions you have at least read access to. Use the left/right cursor keys to scroll through and press Enter to select.

Once a subscription has been selected, the CLI will display the details of the subscription (name, owner, renewal/expiration status, plan name and plan solution) along with details of the seats available on the subscription with how many used and how many are available, and who has been assigned each type of seat.

To review the permissions assigned for a given seat, use ``spire user describe --user <user id> --output perms`` with a user ID from the output of the previous command. This will list all seats and permissions for that user.
