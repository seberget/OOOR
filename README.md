# Out-Of-Office-Replies
Filters out e-mail responses to ticket updates that are out-of-office-replies. This is done by analyzing e-mail headers. All e-mails are received but they will not change the state of the ticket. An entry is created in _history_ to say which action was made.

Make sure that the following headers are present in the _Ticket - Core::PostMaster' 'PostmasterX-Header'_ section:
_X-Autoreply_, _X-Autorespond_ and _Auto-Submitted_. Case is important.
