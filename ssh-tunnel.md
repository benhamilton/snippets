# SSH Tunnel From Bash Command Line

Use this if you need to establish an SSH tunnel, and then connect to the MySQL database the command line. i.e. to establish an SSH Tunnel for a local app (Navicat) to talk to remote MySQL DB 

```
ssh -p22 -i ~/.ssh/privatekeyfilenamehere -v user@1.1.1.1 -L 3306:127.0.0.1:3306 -N
```

Explaining that command line:

- which port to ssh on: `-p 22`
- which ssh private key to use: `-i ~/.ssh/privatekeyfilenamehere`
- which username @ ip or hostname: `-v user@1.1.1.1`
- remap local port to remote port: `-L 3306:127.0.0.1:3306`
- no idea what this one does yet: `-N`

*Note*: change which PRIVATE key it references, change the username and IP address, and remap the MySQL port as required

To connect to a terminal connection, use this command:

```
ssh user@1.1.1.1 -p 22 -i ~/.ssh/privatekeyfilenamehere
```

tags: #mysql #ssh #iterm #port #publickey #privatekey