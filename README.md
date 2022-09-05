# docker-template

This is a collection of docker-compose templates and management scripts, for my own swarm cluster. Each sub-dir is a standalone template, management scripts are redundant replicated in each templates, just to ensure the portability. Each template can be used independently. Each template is organized in a standard structure and has same management scripts, so only need one document for all templates.

## Structure of each template

```bash
- <template_name>/ # Root dir of a template with name <template_name>
  - bin/ # Root dir of management scripts, each template has the same content
    - start.sh    # literal meaning
    - stop.sh     # literal meaning
    - restart.sh  # literal meaning
    - status.sh   # Print running status of this template, same as `docker stack status <template_name>`
    - info.sh     # Print template env config and its real value (all `DEPLOY_` prefixed variables defined and used in docker-compose.yml)
    - config.sh   # Print real config file content used by docker swarm, used in all scripts like this: `./config.sh | docker swarm start/stop/... -f -`
    - deploy.sh   # Deploy this template as a runnable swarm stack, required a swarm cluster + nfs server + ... (a lot of pre-work, see below for details)
    - init.sh     # Optinal, auto invake in deploy.sh, init the stack created by a specific template, different for each templates
    - lib.sh      # literal meaning, imported in all scripts
    - data-backup.sh    # Backup tools, backup all data volume and env config as a single zip file ...
    - data-restore.sh   # Restore tools, use a backup zip file to create a new swarm stack ...
  - docker-compose.yml  # Main template, compatibled with original docker-compose format, add some small custom features based on comments, can be customized with `DEPLOY_` prefixed env variables
  - var/    # Optinal, define all volume this template required, all of them will copy to `$DEPLOY_DATA_ROOT/<template_name>/` dir on nfs storage during deploying
    - volume1/  # A empty dir, represents a data volume with name <volume1>
    - volume2/  # A empty dir, represents a data volume with name <volume2>
    - ...
  - deploy.env  # Only presents in a deployed template, created manual, define all custom env variable, POSIX shell format (A=1;B=2;C="$A-${B:-1}-$(date +%F)";...), as a user level config
```

## Quickstart

1. Prepare a single node swarm cluster to run docker container, with this cmd: `docker swarm init`
2. Prepare a nfs server to store data volume, and then set the following env variable:
  - DEPLOY_DATA_HOST: hostname or ip of nfs server
  - DEPLOY_DATA_ROOT: root dir on nfs server to store all volumes
3. Prepare a overlay network with name `external_network` for reverse proxy, every container will attach to this network. Use this cmd to create manually: `docker network create -d overlay --attachable external_network`
4. Create a env config file to custom a template, (create a `deploy.env` file manually)
5. Deploy a template as swarm stack, (use `deploy.sh` script)
6. Start running swarm stack, (use `start.sh` script)

Now the swarm stack is running, but it cannot be accessed from outside. Because these templates are designed work with a reverse proxy and a domain, and each stack should be accessed by a sub domain. The exposed ports of containers are hidden defaultly and only accessible by reverse proxy. You can use the custom feature switch `port` to expose them, just add this line to your `deploy.env` config file and restart swarm stack:

```bash
DEPLOY_ENABLED_FEATURE="port"
```

To find the exposed port, you can use the `info.sh` script to print all env variables defined in this template, and the `*_PORT` env variables are the exported ports. use this cmd to find them: `./info.sh|grep 'PORT'`

## Reverse Proxy and Domain

If you want to use the reverse proxy and domain, follow the next steps:

1. Prepare a domain, and add an A record pointing to your host
2. Deploy and run a `traefik` reverse proxy stack, refer the steps above
3. Add the following env variable to your `deploy.env` config file, and restart the swarm stack (use `restart.sh` script):
  - DEPLOY_HOSTNAME: your domain
  - DEPLOY_SUBDOMAIN: the prefix of your sub domain, (optional, default is the name of template)

Above steps will create a traefik container listening 80 and 443 ports. All access should use the domain without port (http://<sub_domain>.<your_domain> or https://<sub_domain>.<your_domain>), ssl cert will be set up and updated automatically inside the traefik container

## Custom Feature Switch

*TODO...*

