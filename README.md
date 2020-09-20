<p align="center">
    <a href="http://github.com/luisaveiro/dev.env">
        <img src="https://res.cloudinary.com/luisaveiro/image/upload/v1600614169/github/docker-vue-template/docker-vue-template-logo_qj2krh.png" alt="Vue + Docker Logo" width="75%">
    </a>
</p>

<h4 align="center">
    A GitHub template to quickly start Vue.js application running in Docker
</h4>

<p align="center">
    <a href="#about">About</a> •
    <a href="#disclaimer">Disclaimer</a> •
    <a href="#getting-started">Getting Started</a> •
    <a href="#how-to-use">How To Use</a> •
    <a href="#make-commands">Make Commands</a> •
    <a href="#known-issues">Known Issues</a> •
    <a href="#license">License</a>
</p>

## About

These instructions will get you through the bootstrap phase of creating a containerised Vue.js application with Docker Compose.

## Disclaimer
**Please note:** The Dockerfile provided is intended for use in local development environments. **Please do not** use this Dockerfile to deploy your Vue.js application in production environments. Please visit [Vue CLI Deployment Documentation](https://cli.vuejs.org/guide/deployment.html#platform-guides) for deploying on various platforms.

## Getting started

Make sure that you have Docker and Docker Compose installed

- Windows or macOS: [Install Docker Desktop](https://www.docker.com/get-started)
- Linux: [Install Docker](https://www.docker.com/get-started) and then [Docker Compose](https://github.com/docker/compose)

For new projects, click on ***use this template*** button to create a new repository with this GitHub template.

## How To Use

Below is how your Vue.js project repository is structured. Your Vue.js code will be stored in the `code` folder.

```
.
├── .env
├── docker-compose.yaml
├── Makefile
├── README.md
└── docker
    └── Dockerfile
└── code
    └── ...
```

#### <ins>Setup Docker environment</ins>

Before you setup a new Vue.js application, you will need to create an **.env** file for the Docker Compose file to use. This template includes a **.env.example** which you can copy from.

```bash
# Create .env from .env.example.
$ cp .env.example .env
```

Your **.env** needs to have the following environment variables.

| # 	| Variable        	| Description                                   	| Example Value 	|
|---	|-----------------	|-----------------------------------------------	|---------------	|
| 1 	| DOCKER_USERNAME 	| Docker hub username                           	| luisaveiro    	|
| 2 	| PROJECT_NAME    	| Project name                                  	| website       	|
| 3 	| CONTAINER_NAME  	| Docker container name                         	| website.local 	|
| 4 	| IMAGE_NAME      	| Image tag                                     	| website       	|
| 5 	| PROJECT_PATH    	| Project directory in Docker image & container 	| website       	|
| 6 	| NETWORK         	| Docker container network                      	| front-end     	|
| 7 	| VUE_UI_PORT     	| Port used for the UI server                   	| 8000          	|
| 8 	| VUE_UI_HOST     	| Host used for the UI server                   	| 0.0.0.0       	|

Once you have updated the **.env** as per your requirements. You can run the `docker compose up` command to create your Docker environment.

```bash
$ docker-compose up 
Creating network "front-end" with the default driver
Creating volume "website.local_node_modules" with default driver
Building web
Step 1/11 : FROM node:14.11.0-alpine3.12
...
Successfully tagged luisaveiro/website:latest
WARNING: Image for service web was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating website.local ... done
Attaching to website.local
website.local | 🚀  Starting GUI...
website.local | 🌠  Ready on http://0.0.0.0:8000
website.local | 8000
```

After the Docker container has started, navigate to http://localhost:8000 in your web browser to access the Vue UI web server.

#### <ins>Creating a new Vue.js project</ins>
Do not use the Vue UI web server to create a new project [See known issue #1](#known-issues). Instead you need to use the Vue CLI `create` command.

You can access the Docker container terminal by using the `make ssh` alias command.

```bash
$ make ssh
# docker exec -t -i website.local /bin/sh
/var/www/website
```

Once you have accessed your Docker container terminal, you will need to run the `vue create .` command. This will create a new Vue.js application in the current directory, which is the volume mounted to your `code` folder.

```bash
$ vue create .

Vue CLI v4.5.6
? Generate project in current directory? (Y/n) y
...

Vue CLI v4.5.6
✨  Creating project in /var/www/website.
⚙️  Installing CLI plugins. This might take a while...
...
success Saved lockfile.
Done in 15.19s.
⚓  Running completion hooks...

📄  Generating README.md...

🎉  Successfully created project website.
👉  Get started with the following commands:

 $ yarn serve
```

Once Vue CLI has created your new Vue.js application, you will able to access your code in the `code` folder of your repository.

#### <ins>Import Vue.js project into Vue UI</ins>

Once you have a Vue.js project (new or existing), you can import your Vue.js project using Vue UI import function. You will be able to see all the Vue UI functionality for you Vue.js application.

#### <ins>Enabling Hot-Reloading with vue-cli-service serve</ins>

To enable Hot-Reloading when using the **Vue UI serve task**; you will need to include `devServer.watchOptions` in your `vue.config.js` file. This template includes a `vue.config.js` file in the `code` folder or you can copy the code below.

```javascript
module.exports = {
  devServer: {
    watchOptions: {
      poll: true
    }
  }
}
```

## Make Commands

This template includes `Makefile`. A Makefile is a file containing a set of directives used by a make build automation tool to generate a target/goal. The following commands are available.

| # 	| Command      	| Description                                             	|
|---	|--------------	|---------------------------------------------------------	|
| 1 	| make clean   	| Remove project Docker container, image, network, volume 	|
| 2 	| make image   	| Build Docker image                                      	|
| 3 	| make publish 	| Publish Docker image to Docker Hub                      	|
| 4 	| make serve   	| Run Docker container without Docker compose             	|
| 5 	| make ssh     	| Access Docker container terminal.                       	|
| 6 	| make stop    	| Stop Docker container                                   	|

## Known issues

<b>1. Vue UI is unable to generate a new project in current directory.</b>

This is a limitation of Vue UI, please visit [GitHub vue-cli issue #1509](https://github.com/vuejs/vue-cli/issues/1509#issuecomment-436707488).

**[Solution]** Access Docker container terminal and run `vue create .` command.

<b>2. Stopping Vue UI `serve task` causes the Vue UI server to crash and stops the docker container.</b>

It seems the development server which is used by the `serve task` is linked to Vue UI web server. Below is the log of the Vue UI during the crash.

```bash
website.local | events.js:291
website.local |       throw er; // Unhandled 'error' event
website.local |       ^
website.local | 
website.local | Error: spawn /usr/local/share/.config/yarn/global/node_modules/@vue/cli-ui/apollo-server/util/terminate.sh ENOENT
website.local |     at Process.ChildProcess._handle.onexit (internal/child_process.js:268:19)
website.local |     at onErrorNT (internal/child_process.js:464:16)
website.local |     at processTicksAndRejections (internal/process/task_queues.js:80:21)
website.local | Emitted 'error' event on ChildProcess instance at:
website.local |     at Process.ChildProcess._handle.onexit (internal/child_process.js:274:12)
website.local |     at onErrorNT (internal/child_process.js:464:16)
website.local |     at processTicksAndRejections (internal/process/task_queues.js:80:21) {
website.local |   errno: -2,
website.local |   code: 'ENOENT',
website.local |   syscall: 'spawn /usr/local/share/.config/yarn/global/node_modules/@vue/cli-ui/apollo-server/util/terminate.sh',
website.local |   path: '/usr/local/share/.config/yarn/global/node_modules/@vue/cli-ui/apollo-server/util/terminate.sh',
website.local |   spawnargs: [ '77' ]
website.local | }
website.local exited with code 1
```

**[Solution]** re-run `docker-compose up` to have everything running again.

<b>3. Hot-Reloading with vue-cli-service serve is slow.</b>

This is caused by the host-container file system configuration. [Docker documentation](https://docs.docker.com/docker-for-mac/osxfs-caching/#performance-implications-of-host-container-file-system-consistency) provides information on Docker implementations of volume mount.

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.

---

<p align="center">
  <a href="https://www.luisaveiro.com" target="_blank">luisaveiro.com</a> •
  <a href="http://github.com/luisaveiro" target="_blank">GitHub</a> •
  <a href="https://uk.linkedin.com/in/luisaveiro" target="_blank">LinkedIn</a> •
  <a href="https://twitter.com/luisdeaveiro" target="_blank">Twitter</a>
</p>
