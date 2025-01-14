# SSH / SSHD Setup (Applicable to basically all servers)

Always go to `/etc/ssh/sshd_config` and do the following:
1. Disable password based auth
```
# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no 
PermitEmptyPasswords no
```
2. Allow key based auth
```
PubkeyAuthentication yes
```

## Root access

I prefer to have an `admin` user in the `sudo` group and only log in as that
user with my ssh key, instead of just logging in as root directly. This
requires the following config:
```
PermitRootLogin yes
```
and/or you can just make sure passwords are off and root has no entries in the
`~/.ssh/authorized_keys` file.

## Logspam

The instant `sshd` is running on your server open on port 22, you will get a lot
of log spam from random script kiddes attempting to put a crypto miner on your
server (or etc.). It may be tempting to run `sshd` on an alternate port to
mitigate this but I don't think its a good idea. Standard ports help keep things
understandable, transferable, and useable. Other tools (`fail2ban` and `crowdsec` especially)
can mitigate the spam by just getting rid of a good number of the mosquitoes for
you via a firewall.
