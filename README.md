![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/karlicoss/cloudmacs)

For ages I've been seeking a decent browser frontend for my org-mode notes and todo lists. Until I realised that nothing prevents me from having emacs itself in my browser.

Selfhost your Emacs with your favorite configuration.

# Motivation
Since I've became hooked on emacs (all-in TODO with org-mode, evil-mode and helm), I've been looking for ways to use it TODO.

TODO My usecase is non-personal computers where it's undesirable to install emacs and dropbox/syncthing to sync your personal data. 
So I've been looking for some cloud solution (I've got a VPS).

Dropbox is not capable of previewing arbitrary text files (let alone), and obviously you won't get anything close to your usual emacs workflow.

Filestash TODO support vim/emacs keybindings TODO, but still rest of navigation is TODO

And you could imagine that while elisp/vim style editing is fairly application agnostic (TODO point to surfingkeys?), it's a thankless job to rewrire/port all the amazing emacs packages and features 
I'm used to: nerdtree, helm, refile, swoop, agenda, org-drill etc.

So I figured the only thing that would keep me happy is to run emacs itself over the web! Thankfully, due to its TUI interface that works surprisingly well.

It works **really** well with spacemacs style `SPC`/`,` bindings because they for the most part don't overlap with OS/browser hotkeys.

# Try it out locally 
1. `cp docker-compose.example.yml docker-compose.yml`
2. Edit necessary variables in `docker-compose.yml`, presumably your want to
   * map the files you want to make accessible to container
   * map the path to your config files/directories (e.g. `.spacemacs.d`)
   * change port (see 'selfhost' secion)
3. Run the container: `./run`.

4. Check it out in browser: 'http://localhost:7001**.

# Customize
 TODO Dockerfile.customized

# Selfhost
* TODO cloning emacs.d first? not sure if should just reuse .emacs.d? I guess better not to to avoid potential problems coming from different builds?
* TODO reverse proxy -- same instuctions as for gotty
* TODO basic auth?
* TODO docker compose up -- how to make sure it restarts after reboot?

# Potential improvements


# TODOs
* `post-start`
* write about asUserEnv?
* rg turds
* split rg/locales/gotty in separate docker containers? maybe locales could be somehow moved to original emacs container?

# Limitations
* Phones? (use orgzly)

# Credits
* [dit4c/dockerfile-gotty](https://github.com/dit4c/dockerfile-gotty)
* [JAremko/docker-emacs](https://github.com/JAremko/docker-emacs)

# License
GPL due to the fact that I looked at other GPL licensed dockerfiles as reference.
