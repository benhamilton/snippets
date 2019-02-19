# SSH Tunnel From Bash Command Line

Use this if you need to establish an SSH tunnel, and then connect to the MySQL database the command line. i.e. to establish an SSH Tunnel for a local app (Navicat) to talk to remote MySQL DB 

```
ssh -p32222 -i ~/.ssh/ben.hamilton.id.au.2019 -v evolution@202.174.102.110 -L 3306:127.0.0.1:3306 -N
```

Explaining that command line:

- which port to ssh on: `-p 32222`
- which ssh private key to use: `-i ~/.ssh/ben.hamilton.id.au.2019`
- which username @ ip or hostname: `-v evolution@202.174.102.110`
- remap local port to remote port: `-L 3306:127.0.0.1:3306`
- no idea what this one does yet: `-N`

*Note*: change which PRIVATE key it references, change the username and IP address, and remap the MySQL port as required

tags: #mysql #ssh #iterm #port #publickey #privatekey