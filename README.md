# Take Your First Steps in Ximera

This repository has a basic Ximera course that will help you get started using Ximera.

## Software suggestions

Before we begin, we have some sofware suggestions: Git, Docker, Visual Studio Code, and LaTeX.

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

Docker is necessary for online deployment. In particular, on Windows machines it provides a UNIX-like terminal via WSL.

#### Windows

#### MacOS

#### Linux

### Installing Visual Studio Code

#### Windows

#### MacOS

#### Linux

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
