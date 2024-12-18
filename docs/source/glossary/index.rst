Glossary
========

ORGANISATION
------------

A company that has been set up on the Solutions Hub. An organisation can have one or more *organisation administrators* who can create, update and delete users.

PERSONAL ACCESS TOKEN
---------------------

Shortened to "PAT", this is a string that is used with a user's email address to authenticate without needing access to a web browser. This method of authenticating would typically be used in a CI environment.

A user can only have one PAT at a time. Authenticating with a PAT typically results in a full authorization token, although some CLI tools may request a reduced token.

RESOURCE
--------

A resource is a reference to something that exists within a Solution. For example, in ONELab, a registered appliance is handled within SPIRE as a resource.

SEAT
----

A *seat* on the Solutions Hub defines what a user can do (in terms of permissions) when assigned that seat. A solution might offer a choice of different seats, each with their own sets of permissions.

It is possible for multiple seats of different seat types from the same subscription to be assigned to the same user. That user's permissions comes from all of the permissions from each seat combined. It is not possible for a seat to remove a permission granted by another seat. It is also not possible to assign multiple seats of the same seat type to a user for the same subscription.

Seat permissions are a combination of the permission itself and what the permission is targeted at. For a given seat, the permissions are either all targeted at the subscription, or they are targeted at individual resources.

So, if a seat already has a permission targeted at a subscription, adding new permissions will require those permissions to also be targeted at the same subscription. On the other hand, if the seat only has permissions targeting resources, then adding new permissions will also need those to target resources *but* they do not need to be the same resources.

PERMISSION
----------

A *permission* specifies something that the user is allowed to do, such as creating a user.

Permissions are granted to users via seats (see above). Permissions can be targeted at:

* the subscription, in which case the operation granted by that permission can be carried out on any appropriate resource within the subscription
* one or more resources, in which case the operation granted by that permission can only be carried out against the specified resource(s).

SUBSCRIPTION
------------

A *subscription* is an arrangement to have access to a solution on Linaro's Solutions Hub.

What access is provided depends on what the solution offers, the *subscription plan* and the *seat* permissions granted.

Anyone can start a subscription, but the subscription does not become active unless the selected plan is free, or if a payment method has been set up for the selected plan and subscription.

SUBSCRIPTION PLAN
-----------------

Typically shortened to just **plan**, this defines the seats available for assignment. A plan may place a limit on how many seats can be assigned.

USER
----

A user is an individual that has an account on the Solutions Hub. They can be an individual user, or an organisational user.
