# How to setup BanSync
Firstly, you'll need to add <@1115368540124500018> to your server.
If the commands do not initially appear, please restart your Discord client.
This has been an issue for me during development and should help you too.
After adding it, you'll need to run "/bansync-config".
This will generate a new Sync ID for your server. This will be required when syncing with other servers who use the bot.

You will need bansync enabled to operate and it is highly recommended to set a text channel for any reports & requests to be seen. Just click "Set as bansync channel" to set the current channel for the notifications.

The "Host Mode" is used when acting as a host & "Client Mode" for when acting as client.
The provided description will tell you what each sync mode does.

# How to configure with other servers?
There are two ways to setup a connection.
Either case does require the client to provide their sync id which can be grabbed via "/bansync-config".

1. "/bansync-request"
  * Any user can send a request on the server they want to sync with.
    The host will receive this request and can choose to accept, or ignore it.
    When accepting, the host can specify the type of mode they'll allow for your server.
  * You will be asked to provide a reason as to why you wish to sync up.
2. "/bansync-invite"
  * This command is only executable by server management. And is often used when requests are disabled.

Upon success, a confirmation message is posted for both client & host.

# How do I change the sync mode for an existing connection?
Use "/bansync-profile" to change it. It will have an auto-complete for you which can help find the server you wish to edit the sync mode for.