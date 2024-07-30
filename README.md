# Take Your First Steps in Ximera

This repository has a basic Ximera course along with instructions for deploying that will help you get started using Ximera.

- [Take Your First Steps in Ximera](#take-your-first-steps-in-ximera)
  - [Software requirements and suggestions](#software-requirements-and-suggestions)
    - [Installing Git](#installing-git)
      - [Windows](#windows)
      - [MacOS](#macos)
      - [Linux](#linux)
    - [Installing Docker](#installing-docker)
      - [Windows](#windows-1)
      - [MacOS](#macos-1)
      - [Linux](#linux-1)
    - [Installing Visual Studio Code](#installing-visual-studio-code)
    - [Installing LaTeX](#installing-latex)
      - [Windows](#windows-2)
      - [MacOS](#macos-2)
      - [Linux](#linux-2)
  - [Contents of this repository](#contents-of-this-repository)
  - [The published course](#the-published-course)
  - [Deploying new courses](#deploying-new-courses)


## Software requirements and suggestions

To use Ximera, we require that users use Git and Docker.
We additionally (very strongly) suggest Visual Studio Code and LaTeX.

### Installing Git

Git is fundamental to working with Ximera. All Ximera docuements that will be deployed online must be in Git repository. If you have no experience with Git, the developers are happy to help get you started with Git, email: `ximera@math.osu.edu`

#### Windows

If you use Windows, go to: `https://git-scm.com/download/win ` and the download will start automatically. If it doesn't you probably want "64-bit Git for Windows Setup."

#### MacOS

On Mavericks (10.9) or above you can do this simply by trying to run git from the Terminal the very first time. To open the terminal, do one of the following:

- Click the Launchpad icon in the Dock, type Terminal in the search field, then click Terminal.
- In the Finder, open the /Applications/Utilities folder, then double-click Terminal.

Once in the terminal type `git` and hit return. It should look something like:

```console
% git
```

If you don’t have it installed already, your computer will prompt you to install it.

#### Linux

On Linux, there are various methods. However, if you are on a Debian-based distribution, such as Ubuntu, try:

```console
$ sudo apt update
$ sudo apt install git
```

### Installing Docker

Docker is necessary for online deployment. It allows us to choose which **version** of software we use. Moreover, it allows us to rapidly test updates and revert back (if necessary) very easily. Our Docker containers contain LaTeX, so if one is willing to work excusively in Docker, they do not need to install LaTeX.

#### Windows

Follow the directions found [here](https://docs.docker.com/desktop/install/windows-install/). "WSL" is key for our deployment, so be sure to follow those guidelines.

#### MacOS

Follow the directions found [here](https://docs.docker.com/desktop/install/mac-install/).

#### Linux

Follow the directions found [here](https://docs.docker.com/desktop/install/ubuntu/).



### Installing Visual Studio Code

Visual Studio Code gives us a common deploy environment. In particular, on Windows machines it provides a UNIX-like terminal via WSL.
Download from `https://code.visualstudio.com/download`  or if you use Linux and are on a Debian-based distribution, such as Ubuntu, try:

```console
$ sudo apt update
$ sudo apt install code
```
### Installing LaTeX

Since we deploy in docker, this is not **strictly** necessary. However, it will enable you to compile documents without using Docker. This can be helpful when developing.

#### Windows

#### MacOS

#### Linux

## Contents of this repository

- `.gitignore`
- `firstTopic/firstActivity.tex`
- `secondTopic/anotherActivity.tex`
- `activityCollection.tex`
- some sort of exercise list
- `scripts/xmlatex`

## The published course

- https://ximera.osu.edu/firststeps/course/firstTopic/firstTopic
- https://set.kuleuven.be/voorkennis/firststeps/course/firstTopic/firstTopic

The KULeuven version also contains two PDF versions: one with, and one without the answers.


## Deploying new courses