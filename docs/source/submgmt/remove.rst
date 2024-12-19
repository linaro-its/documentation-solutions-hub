Removing a seat
===============

To remove a seat from a user with the SPIRE CLI, the ID of the seat to be removed is required. This was displayed by the CLI tool when the seat was first assigned to a user.

``spire seat remove -s <seat id>``

If the seat ID is not known, the seat can be removed via interactive prompts. If ``spire seat remove`` is run without any parameters, the CLI will:

* Prompt for the name or email address of the user. As this is typed, a list of matches (no more than 5) is displayed. Once you see the name of the affected person, select them using the up/down cursor keys and press Enter.
* A list of seats assigned to this user will be displayed. Use the left/right cursor keys to select the appropriate seat and press Enter.

The tool confirms the IDs for the user and the seat, and then proceeds to remove the seat assigned.
