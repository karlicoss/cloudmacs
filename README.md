![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/karlicoss/cloudmacs)

[Docker hub](https://hub.docker.com/r/karlicoss/cloudmacs)

For ages I've been seeking a decent browser frontend for my org-mode notes and todo lists. Until I realised that nothing prevents me from having emacs itself in my browser.

Selfhost your Emacs with your favorite configuration.

# Motivation
Since I've became hooked on emacs, I've been looking for ways to have same experience in my browser.
Sometimes you have to use non-personal computers where it's not possible/undesirable to install desktop Emacs and Dropbox/Syncthing to access your personal data. 
So I've been looking for some cloud solution since I've got a VPS.

The closest tool to what I wanted was [Filestash](https://github.com/mickael-kerjean/filestash): it suports vim/emacs bindings and some [org-mode goodiness](https://www.filestash.app/2018/05/31/release-note-v0.1). However, it wasn't anywhere as convenient as emacs.

Dropbox is not capable of previewing arbitrary text files let alone edit; and even if it could you obviously wouldn't get anything close to your usual emacs workflow.

And you could imagine that while elisp/vim style editing is fairly application [agnostic](https://github.com/brookhong/Surfingkeys#vim-editor-and-emacs-editor), it's a thankless job to rewrire/port all the amazing emacs packages and features I'm used to like neotree, helm, refile, swoop, agenda, projectile, org-drill etc.

So I figured the only thing that would keep me happy is to run emacs itself over the web! Thankfully, due to its TUI interface that works surprisingly well.

It works **really** well with spacemacs style `SPC`/`,` bindings because they for the most part don't overlap with OS/browser hotkeys.

# Try it out locally 
1. `cp docker-compose.example.yml docker-compose.yml`
2. Edit necessary variables in `docker-compose.yml`, presumably your want to
   * map the files you want to make accessible to container
   * map the path to your config files/directories (e.g. `.spacemacs.d`). Also check the 'Setting up Spacemacs' section!
   * change port (see 'selfhost' secion)
3. Run the container: `./compose up -d`.
4. Check it out in browser: 'http://localhost:8080'.

# Setting up Spacemacs
Spacemacs doesn't use `init.el`, instead you have `~/.spacemacs.d` directory, and `~/.emacs.d` serves as Spacemacs distribution.
I **don't** recommend you to reuse `~/.emacs.d` your OS emacs distribution will generally be different from containers, 
and who knows what else could it break. Instead just clone spacemacs in a separate dir and map it.

On your Host OS:

```
git clone https://github.com/syl20bnr/spacemacs.git -b develop ~/.cloudmacs.d
cd ~/.cloudmacs.d && git revert --no-edit 5d4b80 # get around https://github.com/syl20bnr/spacemacs/issues/11585
```

In your `docker-compose.yml`, add:
```
    volumes:
      - ${HOME}/.cloudmacs.d:/home/emacs/.emacs.d
```

# Customize
Some packages need extra binaries in the container (e.g. `magit` needs `git`). There are to ways you can deal with it

1. Extend cloudmacs dockerfile and mix in the packages you need: see [example](Dockerfile.customized).
   Then you can build it, e.g.:
   ```
   docker build -f Dockerfile.customized -t customized-cloudmacs --build-arg RIPGREP_VERSION="11.0.2" .
   ```
   Don't forget to update `docker-compose.yml` with the name of your new container.

2. Install packages directly on running container. The downside is that it's easy to lose changes if you delete the container. 
   Unfortunately docker-compose file [doesn't support](https://github.com/docker/compose/issues/1809) post-start scripts
   so if you want to automate this perhaps easiest would be to write a wrapper script like this:
   ```
   #!/bin/bash -eux
   docker-compose up -d
   docker exec cloudmacs sh -c "apk add --no-cache git"
   ```
 
# Selfhost
* I use basic auth to access my container.
* Set up reverse proxy to access Gotty. Steps may vary depending on your web server, but for my nginx it looks like that:
  ```
  location / {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header Host $host;
      proxy_http_version 1.1;
      proxy_pass http://localhost:8888;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
  }
  ```


# Potential improvements
* split rg/locales/gotty in separate docker containers? maybe locales could be somehow moved to original emacs container?

# Limitations
* Mobile phones -- you'd struggle to use default emacs/spacemacs on touchscreens. Perhaps there is some special phone friendly config out there?
  Anyway, I tend to use [orgzly](https://github.com/orgzly/orgzly-android) on my Android phone.

# Credits
* [dit4c/dockerfile-gotty](https://github.com/dit4c/dockerfile-gotty)
* [JAremko/docker-emacs](https://github.com/JAremko/docker-emacs)
* [JAremko/browsermax](https://github.com/JAremko/browsermax). It's pretty similar but Dockerfile is quite complicated, looks like they are trying to use X11 for some reason, whereas I'd be perfectly happy with `emacsclient --tty`.
* [raincoats/nginx.gotty.proxy](https://github.com/raincoats/nginx.gotty.proxy)

# License
GPL due to the fact that I looked at other GPL licensed dockerfiles as reference.
