This repository has a basic Ximera course along with instructions for deploying that will help you get started using Ximera. It is designed to help a new user. If there are problems with the instructions below, please submit an "Issue" by pressing the "Issues Tab" on https://github.com/XimeraProject/ximeraFirstSteps.


The course(s) in this repo are published on following places:

* https://ximera.osu.edu/firststeps24/aFirstStepInXimera 
* https://set.kuleuven.be/voorkennis/firststeps24/aFirstStepInXimera/basics/basicWorksheet
* https://set.kuleuven.be/voorkennis/firststeps24/variant/aNewlayout/variant/basics/basicWorksheet

and if you follow the instructions in this Readme, it could very soon be available on your own pc on

* http://localhost:2000/firststeps24

where you will be able to change, test and adapt it. 

In case of trouble: create an Issue and we'll (try to) help you.


# Contents
<!-- MANUAL TOC NEEDED ???? -->
- [Software requirements and suggestions](#software-requirements-and-suggestions)
- [Test your software and clone this repository](#test-your-software-and-clone-this-repository)
- [Deploying this course](#deploying-this-course)
- [Debugging](#debugging)
- [Deploying new courses](#deploying-new-courses)

# Software requirements and suggestions

Although a standard TeX installation is sufficient to generate PDF versions of your courses, we very strongly suggest to use Git and Docker. We additionally (also very strongly) suggest Visual Studio Code, but editing can be done in your favorite TeX-editor.
To generate interactive websites, use of Git and Docker is required. In the future, this might change (again).


## Installing Git

Git is fundamental to working with Ximera. All Ximera documents that will be deployed online must be in Git repository. If you have no experience with Git, the developers are happy to help get you started with Git, email: `ximera@math.osu.edu`

### Git on Windows

If you use Windows, go to: `https://git-scm.com/download/win ` and the download will start automatically. If it doesn't you probably want "64-bit Git for Windows Setup."

### Git on MacOS

On Mavericks (10.9) or above you can do this simply by trying to run git from the Terminal the very first time. To open the terminal, do one of the following:

- Click the Launchpad icon in the Dock, type Terminal in the search field, then click Terminal.
- In the Finder, open the /Applications/Utilities folder, then double-click Terminal.

Once in the terminal type `git` and hit return. It should look something like:

```console
git
```

If you don’t have it installed already, your computer will prompt you to install it.

### Git on Linux

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



## Installing Visual Studio Code

Visual Studio Code is a popular free editor and development environment by Microsoft, that integrates git, docker and tex support.
Note the `code` part: Visual Studio is a different and much bigger Microsoft product, that is not needed nor relevant for Ximera.

Download and install form
```
https://code.visualstudio.com/download
```
and accept the default WSL setup (which will enable Microsoft provided a Linux subsystem on your PC).

After starting Open Visual Studio Code, hit `Ctrl-~` to open a Terminal Windows, which will initially be PowerShell. It is suggested to enable a more complete Linux system by typing
```console
wsl --install
```
Now at the upper right of the Terminal window you should see "PowerShell + v" menu, and pressing the down-carrot should give an 'Ubuntu (WSL)' option (perhpas wwit a  specific Ubuntu version like 24.04).
This will be needed further to generate a gpg key.



If useing Linux with a Debian-based distribution such as Ubuntu, add the Microsoft windows install dependencies before installing Microsoft Visual Studio Code:

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

## Installing Docker

Docker is necessary for online deployment. It allows us to choose which **version** of software we use. Moreover, it allows us to rapidly test updates and revert back (if necessary) very easily. Our Docker containers contain LaTeX, so if one is willing to work exclusively in Docker, they do not need to install LaTeX.

If you start Docker, accept the license and accept recommendations. Once it asks you to sign in, just "Continue Without Signing In." You may choose to do the survey if you like. Once you finish this, you will see a "Engine running" at the bottom left hand corner of the screen.

### docker on Windows

Follow the directions found [here](https://docs.docker.com/desktop/install/windows-install/). "WSL" is key for our deployment, so be sure to follow those guidelines.

### docker on MacOS

Follow the directions found [here](https://docs.docker.com/desktop/install/mac-install/).

### docker on Linux

Follow the directions found [here](https://docs.docker.com/desktop/install/ubuntu/).


## OPTIONAL: Installing LaTeX

Since you can compile and deploy in docker, a local TeX installation is not **strictly** necessary.
If you have one already, you can use it, but you might have to add the Ximera package from CTAN.
And there might be some dependencies on old or new versions of some packages that cause issues...

# Test your software and clone this repository

## Start Docker and VSCode 

Assuming you have Git, Docker, and VS Code installed, you should first start Docker.
Open the Docker Desktop application. It will ask you some questions -- if you are on Windows and it asks about "WSL," accept it, as you need "WSL" (if it asks!). You want to open the Docker Desktop application.  You should be able to do this with some sort of GUI launcher.

Once Docker is open and you have skipped through any other surveys/questions, you will see a "Engine running" at the bottom left hand corner of the screen. 
You can minimize the Docker window.

If on Windows, once you start VS Code, make sure you instal the "WSL Extension." VS Code, may ask you if you want to install this via a window in the lower left-hand corner.



## OPTIONAL: Obtain a GitHub account and "Fork" this repository


For a first impression of Ximera, you can just **clone** this repo on your local PC,
and you won't need a Github account.

For deploying Ximera courses, tt's convenient to have a GitHub account and **fork** this repo to `https://github.com/YOUR-GIT-USER-NAME/ximeraFirstSteps`.
Accounts are free, and educators can request special access.
Once logged in into GitHub, at the top right there will be an option to "Fork" the https://github.com/XimeraProject/ximeraFirstStep repository, which will create your own copy which you can then clone, push and publish, e.g. on https://ximera.osu.edu.



## Clone ximeraFirstSteps

If you choose to forked the repo, you should clone  **your copy** of ximeraFirstSteps.
If not, you clone the https://github.com/XimeraProject/ximeraFirstSteps.git repo.  You will not be able to push your changes, but this will not be needed to get familiar with Ximera, and test the setup on your local device.

For all platforms, upon cloning VS Code will ask if you "trust the authors", which you should,
and also to 'Install recommended extensions', which you also should do.

On Windows there unfortunately is a subtle technical complication that can cause problems.

### On Windows 
If you are running Windows, we strongly suggest (for the time being; this might change) 
to clone INSIDE the WSL Ubuntu system, as follows.

(This is because Windows stores newlines in a textfile differently from Linux/MacOs, and the Ximera build process uses a Linux Docker container,
 and at this point requires (unfortunately) the Linux/MacOs convention)

Hit `Ctrl-~` and you should see something like:

![An image of VS Code powershell](graphicsREADME/powershell.png "The powershell")

Click the arrow on the right:

![Clicking arrow to switch to WSL](graphicsREADME/clickedArrow.png "Click the arrow")

When you have selected "Ubuntu (WSL)" you should see something like:

![An Ubuntu (WSL) Terminal](graphicsREADME/WSL.png "An Ubuntu (WSL) terminal")

Now run
```
git clone https://github.com/XimeraProject/ximeraFirstSteps.git
```
or
```
git clone https://github.com/YOUR-GIT-USER/ximeraFirstSteps.git
```
where "YOUR-GIT-USER" is replaced with your GitHub username.


Now use VS Code to "Open Folder" and open `ximeraFirstSteps`


### On MacOS and Linux

Start a terminal and run 
```
git clone https://github.com/XimeraProject/ximeraFirstSteps.git
```
or 
```
git clone https://github.com/YOUR-GIT-USER/ximeraFirstSteps.git
```
where "YOUR-GIT-USER" is replaced with your GitHub username.

You can either clone from any terminal window (or from any Git GUI that you might have), and start VS Code (e.g. in the cloned folder with `code .`), 
or start VS Code, hit `Ctrl-~` to start a terminal, and clone form there.


## Allow extensions

Once you clone this repository, VS Code will ask you, via a pop-up (or a notification flag) in the lower right-hand corner, if you want to install extensions. **Install the suggested extensions.**
Once the extensions are installed, at the bottom right-hand corner of your VS code window you should have four new small buttons, named "PDF," "HTML," "Bake," "Serve," and "Extra".

## PDF/HTML/Bake 

If you open any .tex file, e.g. by typing CTRL-p and typing/selecting basicWorksheet.tex, you can compile it to a PDF by hitting the 'PDF' button
at the right bottom of your screen. Similarly, an HTML version is generated by selecting the 'HTML' button.

The very first time you push one of the buttons a docker image will automatically be downloaded. It's very large, several gigabytes, and will take time.
Later compilations will be much faster.

If you press the "Bake" button, **all** files will be compiled to HTML. The very **first** time it will compile all the documents, and this will take some time. However, the next time you compile, it will only compile updated files and that will be **much** faster.


# Deploying the course(s) of your repo

## Getting GPG Keys

At this time (9/2024), you need to have a GPG key, even to deploy to the local server. This will change (hopefully very soon).

To deploy to a public server (e.g. the OSU server), you will definitely need a (personal) GPG key. This ensures that no one "overwrites" your online course without you knowing. (Even if this did happen, you can always just re-deploy and contact the Ximera developers)

The keys should be stored in a 'hidden' file `.ximeraserve`, as explained here.

Start by checking if you have GPG keys:
```
gpg --list-keys
```
If you have one listed, you may use it, or make a new one with (answer the questions, but **leave the passphrase blank**) and :
```
 gpg --gen-key
```
copy the long hex string as YOUR-GPG-KEY-ID (ABCD3562DBF9929292 or whatever).

If you are using MacOS, you might not be able to leave the passphrase blank. In this case go to https://gpgtools.org/ and install the GPG Suite. This will provide a GUI that will produce a GPG key with spaces. Delete these spaces and this new key (without spaces) is your key. You should quite your terminal and open a new one. 

You will also need your private key

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


To deploy this Ximera "course" aka "xourse" to your local Ximera Server, replace the dummies in  `DOTximeraserve`
with your own key and key-id, and save the file as `.ximeraserve`.
**DO NOT SAVE DOTximeraserve with your changes.** You should **NEVER** publish or send your key.

```
GPG_KEY_ID=8XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXEDF8
GPG_KEY=$(
cat <<'EOF'
WONTWORKRUdBQR1AFURSBLRVJTigUFJJVkkgQktYVJOcxPQ0sk1CREFEdGU5
...
... PASTE HERE YOUR PRIVATE KEY (with lots of lines as the one above )...
...  Leave the line above with cat <<'EOF' untouched  
...  and leave also the final lines with EOF and bracket ) untouched  ...
...  Everything in between should become your private key
...
R1AgUFQkxPQJ0tLQVkFURSBJkgLRV0stLSo=
```

On Windows, you will need to "Show Hidden Files", and save `.ximeraserve`
as Type "All Files" (not Plain Text -- that will add .txt to the filename).

Note: `.ximeraserve` will not be put in git, as it is (or **should be**) in the `.gitignore` file.

## Check the file `./scripts/config.txt`

The file `./scripts/config.txt` contains some optional default settings for compiling and publishing your courses.
Without any setting, your courses will be published to a local ximeraserver you can start on your own PC from the 'Extra' menu. 

## Compare with the published course

Once you've deployed the course, you can compare your local version to ours. 
At this time (09/2024), your local version will have a 'KULeuven' styling, but this will change (hopefully) soon, when you'll be able to choose or make more layout options.

•	https://ximera.osu.edu/firststeps24/aFirstStepInXimera
•	https://set.kuleuven.be/voorkennis/firststeps24/aFirstStepInXimera/basics/basicWorksheet
•	https://set.kuleuven.be/voorkennis/firststeps24/variant/aNewlayout/variant/basics/basicWorksheet


The KULeuven version also contains two PDF versions: one with, and one without the answers.


# Debugging

You can get an interactive BASH shell **inside** the docker container, with your local folder available under /code.
In this way, you have access to the full tex/ximera settings, and tweak/debug the process.
On exiting and restarting the container again, you'll start again from a clean, standard xake image.
Check the docker documentation if you would want to make permanent changes to the image.

Start a shell with
```
./scripts/xmlatex -i bash
```
Then, you could e.g. 
```
pdflatex FILE.tex
```
or
```
xake -v compile FILE.tex 
```


# Deploying new courses

There are two ways to create a new Ximera course that will deploy online

## Starting from scratch

REMOVE STUFF
CHANGE NAME OF REPO
PUSH

## Starting with an existing repository

Please follow these steps carefully. 


You'll need to show hidden files, and then copy the file `.gitignore` to your repo. If there is already a `.gitignore` we suggest you replace your file with ours.


Move `scripts` and `.vscode` to your repository. You may need to make xmlatex executable, via

```
chmod +x ./scritps/xmlatex
```
