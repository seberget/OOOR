# OOOR
Out-Of-Office-Replies
Filters out e-mail responses that are out-of-office-replies. Does this by analyzing e-mail headers. All mails are received
but they will not change the state of the ticket. An entry is done in the history to say which action was made.

Make sure that the following headers are present in the 'Ticket - Core::PostMaster' 'PostmasterX-Header' section:
'X-Autoreply', 'X-Autorespond' and 'Auto-Submitted'. Case is important.
