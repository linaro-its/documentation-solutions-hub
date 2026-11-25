.. _settings-access-tokens:

Access Tokens
=============

A personal access token lets a script, a CI job or a command-line tool such as
the :doc:`SPIRE CLI </cli/index>` use the Linaro Solutions Hub as you, without
signing in through a web browser. Each token has a name, an expiry date and,
optionally, a limit on which subscription or service it can be used with.

.. note:: You can only use access tokens if your organisation has given you
   permission to do so. If the **Access tokens** tab says that you don't have
   permission, or the **Create access token** button is greyed out, ask your
   organisation administrator to assign you a **PAT User** seat.

Creating an access token
------------------------

1. Click on your name in the top-right of the page:

   .. image:: access-tokens-1.png
       :scale: 50 %
       :alt: Top navigation bar with the user name button highlighted

2. Click on **User Settings**:

   .. image:: access-tokens-2.png
       :scale: 50 %
       :alt: User menu with User Settings highlighted

3. Click on the **Access tokens** tab:

   .. image:: access-tokens-3.png
       :scale: 50 %
       :alt: User Settings page with the Access tokens tab highlighted

4. Click on **Create access token**:

   .. image:: access-tokens-4.png
       :scale: 50 %
       :alt: Access tokens tab with the Create access token button highlighted

5. Fill in the form:

   * **Name**: a name that helps you recognise the token later, for example
     the name of the script or CI job that will use it. The name cannot be
     changed afterwards.

   * **Expires**: the last day the token works. Pick a date or click on one of
     the **30 days**, **90 days**, **6 months** or **12 months** buttons.

   * **Subscription** and **Service** (both optional): leave these empty for a
     token that has all of your permissions, or choose a subscription or
     service to limit what the token can do.

   Then click on **Create token**:

   .. image:: access-tokens-5.png
       :scale: 50 %
       :alt: Create access token dialog with the Create token button highlighted

6. Click on the copy icon next to the token and store the token somewhere
   safe, such as a password manager or your CI system's secret store:

   .. image:: access-tokens-6.png
       :scale: 50 %
       :alt: Access token created dialog with the copy icon highlighted

   .. warning:: This is the only time the token is shown. It cannot be
      retrieved after you close the dialog. If you lose it, delete it and
      create a new one.

7. Click on **I've saved my token**:

   .. image:: access-tokens-7.png
       :scale: 50 %
       :alt: Access token created dialog with the I've saved my token button highlighted

   If you close the dialog any other way, you are asked to confirm, because
   you will not be able to see the token again.

The new token now appears in the list, with the first few characters of the
token shown under its name so that you can tell your tokens apart.

Deleting an access token
------------------------

Delete a token when you no longer need it, or straight away if you think
someone else may have seen it.

1. On the **Access tokens** tab, click on the bin icon at the end of the
   token's row:

   .. image:: access-tokens-8.png
       :scale: 50 %
       :alt: Access token list with the delete icon highlighted

2. Click on **Delete** to confirm:

   .. image:: access-tokens-9.png
       :scale: 50 %
       :alt: Delete access token dialog with the Delete button highlighted

Anything using the token stops working, and sessions obtained with it are
revoked shortly afterwards. Your other tokens, and your current sign-in, are
not affected. Deleting a token cannot be undone.

Limits
------

* You can have up to 15 active access tokens. The number you have is shown
  next to the **Personal access tokens** heading. Expired tokens don't count
  towards this limit.

* A token can last for up to 12 months. In the last 14 days before a token
  expires, the **Expires** column shows how many days it has left. Once it
  has expired, the column shows **Expired** and the token no longer works.

* A token name can be up to 100 characters long and must be different from
  the names of your other tokens.

* Tokens marked **Legacy** were created before tokens had expiry dates and
  scopes. A legacy token has full access and keeps working until the date
  shown. Replace it by creating a new token, then delete the legacy one.

You can also create, list and delete access tokens with the
:doc:`SPIRE CLI </cli/user>`.
