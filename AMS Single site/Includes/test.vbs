set Outlook As New Outlook.Application
set NS As MOutlook.NameSpace = Outlook.GetNamespace("MAPI")
set Inbox As Outlook.MAPIFolder = NS.GetDefaultFolder(olFolderInbox)
Count = Inbox.Items.Count
