# Take Your First Steps in Ximera

This repository has a basic Ximera course along with instructions for deploying that will help you get started using Ximera. It is designed to help a new user. If there are problems with the instructions below, please submit an "Issue" by pressing the "Issues Tab" at the top-left of the screen.

- [Take Your First Steps in Ximera](#take-your-first-steps-in-ximera)
  - [Software requirements and suggestions](#software-requirements-and-suggestions)
    - [Installing Git](#installing-git)
      - [Windows](#windows)
      - [MacOS](#macos)
      - [Linux](#linux)
    - [Installing Visual Studio Code](#installing-visual-studio-code)
      - [Windows WSL 2 install](#windows-wsl-2-install)
    - [Installing Docker](#installing-docker)
      - [Windows](#windows-1)
      - [MacOS](#macos-1)
      - [Linux](#linux-1)
    - [Installing LaTeX](#installing-latex)
      - [Windows](#windows-2)
      - [MacOS](#macos-2)
      - [Linux](#linux-2)
  - [Test your software and clone this repository](#test-your-software-and-clone-this-repository)
    - [Start Docker](#start-docker)
    - [Start VS Code](#start-vs-code)
    - [Clone the repository](#clone-the-repository)
      - [For MacOS and Linux](#for-macos-and-linux)
      - [Windows special instructions](#windows-special-instructions)
    - [Allow extensions](#allow-extensions)
    - [Bake with Xake](#bake-with-xake)
    - [Getting GPG Keys](#getting-gpg-keys)
  - [Deploying this course](#deploying-this-course)
    - [The published course](#the-published-course)
  - [Debugging Baking](#debugging-baking)
  - [Deploying new courses](#deploying-new-courses)
    - [Starting from scratch](#starting-from-scratch)
    - [Starting with an existing repository](#starting-with-an-existing-repository)

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
git
```

If you don’t have it installed already, your computer will prompt you to install it.

#### Linux

On Linux, there are various methods. However, if you are on a Debian-based distribution, such as Ubuntu, try:

```console
sudo apt update
```

and then

```
sudo apt install git
```

We suggest you follow the recommendations of Git and also do the following:

```
git config --global core.editor "nano"
```



### Installing Visual Studio Code

Visual Studio Code gives us a common deploy environment. In particular, on Windows machines it provides a UNIX-like terminal via WSL. In particular, Windows users must install Visual Studio Code first, and enable WSL.
Download from `https://code.visualstudio.com/download` or if you use Linux and are on a Debian-based distribution, such as Ubuntu, you must add the windows and install dependencies before you can install the repo try:

```console
sudo apt install software-properties-common apt-transport-https wget -y
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
```
You can verify the installation was successful using the following command:

```console
code --version
```

#### Windows WSL 2 install

Open Visual Studio Code and hit `Ctrl-~` then type (in the PowserShell):
```console
wsl --install
```
Now if you look to the upper right of the Terminal window you should see "PowerShell + v" Press the down-carrot, and select WSL. 

### Installing Docker

Docker is necessary for online deployment. It allows us to choose which **version** of software we use. Moreover, it allows us to rapidly test updates and revert back (if necessary) very easily. Our Docker containers contain LaTeX, so if one is willing to work exclusively in Docker, they do not need to install LaTeX.

If you start Docker, accept the license and accept recommendations. Once it asks you to sign in, just "Continue Without Signing In." You may choose to do the survey if you like. Once you finish this, you will see a "Engine running" at the bottom left hand corner of the screen.

#### Windows

Follow the directions found [here](https://docs.docker.com/desktop/install/windows-install/). "WSL" is key for our deployment, so be sure to follow those guidelines.

#### MacOS

Follow the directions found [here](https://docs.docker.com/desktop/install/mac-install/).

#### Linux

Follow the directions found [here](https://docs.docker.com/desktop/install/ubuntu/).



### Installing LaTeX

Since we deploy in docker, this is not **strictly** necessary. However, it will enable you to compile documents without using Docker. This can be helpful when developing.

#### Windows

#### MacOS

#### Linux

## Test your software and clone this repository

### Start Docker

Assuming you have Git, Docker, and VS Code installed, you should first start Docker.
Open the Docker Desktop application. It will ask you some questions -- if you are on Windows and it asks about "WSL," accept it, as you need "WSL" (if it asks!). You want to open the Docker Desktop application.  You should be able to do this with some sort of GUI launcher.

Once Docker is open and you have skipped through any other surveys/questions, you will see a "Engine running" at the bottom left hand corner of the screen. 
You can minimize the Docker window.

### Start VS Code
If on Windows, Once you start VS Code, make sure you instal the "WSL Extension." VS Code, may ask you if you want to install this via a window in the lower left-hand corner.



### Clone the repository

Here the instructions for MacOS and Linux are different from the instructions for Windows.


#### For MacOS and Linux

We suggest starting VS Code, hitting `Ctrl-~` and running: 
```
git clone https://github.com/XimeraProject/ximeraFirstSteps.git
```

#### Windows special instructions
**However**, if you are running Windows, you must use a WSL Ubuntu terminal. Hit `Ctrl-`` and you should see something like:

![An image of VS Code powershell](graphicsREADME/powershell.png "The powershell")

Click the arrow on the right:

![Clicking arrow to switch to WSL](graphicsREADME/clickedArrow.png "Click the arrow")

When you have selected "Ubuntu (WSL)" you should see something like:

![An Ubuntu (WSL) Terminal](graphicsREADME/WSL.png "An Ubuntu (WSL) terminal")




Now use VS Code to "Open Folder" and open `ximeraFirstSteps`
For all platforms VS Code will ask if you "trust the authors." You do!

### Allow extensions

Once you clone this repository, VS Code will ask you, via a pop-up (or a notification flag) in the lower right-hand corner, if you want to install extensions. **Install the suggested extensions.**
Once the extensions are installed, you should have four new small buttons at the bottom right-hand corner of your screen in VS code.
The new buttons will be named "PDF," "HTML," "Bake," and "Serve."

### Bake with Xake

If you press the "Bake" button, it should start downloading the Docker container. Then it should compile the course. The very **first** time it will compile all the documents. This will take some time. However, the next time you compile, it will only compile updated files and will be **much** faster.


### Getting GPG Keys

You need to have a GPG to create a course. This ensures that no one "overwrites" your online course without you knowing. (Even if this did happen, you can always just re-deploy and contact the Ximera developers)

Start by checking if you have GPG keys:
```
gpg --list-keys
```
If you have one listed, you may use it, or make a new one with:
```
 gpg --gen-key
```
Answer the questions, but leave the passphrase blank and copy the long hex string as YOUR-GPG-KEY-ID (ABCD3562DBF9929292 or whatever).

If you are using MacOS, you might not be able to leave the passphrase blank. In this case go to https://gpgtools.org/ and install the GPG Suite. This will provide a GUI that will produce a GPG key with spaces. Delete these spaces and this new key (without spaces) is your key. You should quite your terminal and open a new one. 

Now that you have a key, you need to tell a Ximera server about it:

```
gpg --keyserver hkps://ximera.osu.edu/ --send-key 5FB2------YOUR PUBLIC KEY------0CA
```

Now you will need your private key

```
gpg --armor --export-secret-key 5FB2------YOUR PUBLIC KEY------0CA
```


```
-----BEGIN PGP PRIVATE KEY BLOCK-----

WONTWORKRUdBQR1AFURSBLRVJTigUFJJVkkgQktYVJOcxPQ0sk1CREFEdGU5
...
...  OTHER        ...
...  LINES        ... 
...  IN YOUR      ...
...  PRIVATE KEY  ...
...
R1AgUFQkxPQJ0tLQVkFURSBJkgLRV0stLSo=
-----END PGP PRIVATE KEY BLOCK-----
```

You copy this part:
```
WONTWORKRUdBQR1AFURSBLRVJTigUFJJVkkgQktYVJOcxPQ0sk1CREFEdGU5
...
...  OTHER        ...
...  LINES        ... 
...  IN YOUR      ...
...  PRIVATE KEY  ...
...
R1AgUFQkxPQJ0tLQVkFURSBJkgLRV0stLSo=
```


## Deploying this course

To deploy this Ximera "course" aka "xourse" to a Ximera Server, edit `DOTximeraserve` line: 21, 22, and 27-34.

```
21 REPO_XIMERA=yourpublishurl  # lowercase, no spaces
22 URL_XIMERA=https://ximera.osu.edu
23 # URL_XIMERA=https://set-p-dsb-zomercursus-latest.cloud-ext.icts.kuleuven.be/
24 GPG_KEY_ID=8XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXEDF8
25 GPG_KEY=$(
26 cat <<'EOF'
27 WONTWORKRUdBQR1AFURSBLRVJTigUFJJVkkgQktYVJOcxPQ0sk1CREFEdGU5
28 ...
29 ... PASTE HERE YOUR PRIVATE KEY (with lots of lines as the one above )...
30 ...  Leave the line above with cat <<'EOF' untouched  
31 ...  and leave also the final lines with EOF and bracket ) untouched  ...
32 ...  Everything in between should become your private key
33 ...
34 R1AgUFQkxPQJ0tLQVkFURSBJkgLRV0stLSo=
```

**DO NOT SAVE DOTximeraserve with your changes.** Instead, you will need to "Show Hidden Files" and save as: `.ximeraserve` If you are on Windows, make sure you save as Type "All Files" (not Plain Text -- that will add .txt to the filename).

For experienced Git users: Do not attempt to add `.ximeraserve` to the repo, it is already in the `.gitignore` and **should not be added.**

Start Docker, accept the license and accpet recommendations. Once it asks you to sign in, just "Continue Without Signing In." You may choose to do the survey if you like. Once you finish this, you will see a "Engine running" at the bottom left hand corner of the screen.

### The published course

Once you've deployed the course, you can compare your output to ours:

- https://ximera.osu.edu/firststeps/course/firstTopic/firstActivity
- https://set.kuleuven.be/voorkennis/firststeps/course/firstTopic/firstActivity

The KULeuven version also contains two PDF versions: one with, and one without the answers.


## Debugging Baking

It often helps use an interactive BASH shell:

```
./scripts/xmlatex -i bash
```
then do
```
pdflatex FILE.tex
```
or
```
xake -v compile FILE.tex 
```



## Deploying new courses

There are two ways to create a new Ximera course that will deploy online

### Starting from scratch

REMOVE STUFF
CHANGE NAME OF REPO
PUSH

### Starting with an existing repository

Please follow these steps carefully. 


You'll need to show hidden files, and then copy the file `.gitignore` to your repo. If there is already a `.gitignore` we suggest you replace your file with ours.


Move `scripts` and `.vscode` to your repository. You may need to make xmlatex executable, via

```
chmod +x ./scritps/xmlatex
```
