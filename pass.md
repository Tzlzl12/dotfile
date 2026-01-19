## keep apikey safe using pass
> install `pass`
* sudo pacman -S pass
> init secret by GPG
* gpg --generate-key
* pass init email@example.com
> store
* pass insert api/agent
> to show
* pass api/agent

`pass ls`   
`passs find api`

**GPG**
```bash
gpg --list-keys
gpg --edit-key email@example.com
gpg > expire or 2y or 3m ...
gpg > save
```

## restore from git
```bash
pass git clone ...
gpg --import pub.asc
gpg --import pri.asc

gpg --list-secret-keys
gpg --list-keys

gpg --edit-key email@example.com
gpg > trust (5)
gpg > save 
gpg > quit
```

