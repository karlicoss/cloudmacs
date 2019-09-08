![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/karlicoss/cloudmacs)

For ages I've been seeking a decent browser frontend for my org-mode notes and todo lists. Until I realised that nothing prevents me from having emacs itself in my browser.

# Using 
1. `cp docker-compose.example.yml docker-compose.yml`
2. Edit necessary variables in `docker-compose.yml`, presumably your want to
   * change port
   * map the files you want to make accessible to container
   * map the path to your config (e.g. `.spacemacs.d`)
3. Run the container: `./run` (TODO note about substituted variables)

# TODOs
* reverse proxy
* `post-start`
* write about asUserEnv?

# Limitations
* Phones? (use orgzly)

# Credits
* [dit4c/dockerfile-gotty](https://github.com/dit4c/dockerfile-gotty)
* [JAremko/docker-emacs](https://github.com/JAremko/docker-emacs)

# License
GPL due to the fact that I looked at other GPL licensed dockerfiles as reference.
