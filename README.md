This repository has a basic Ximera course along with instructions for deploying that will help you get started using Ximera. It is designed to help a new user. If there are problems with the instructions below, please submit an issue on the "Issues" tab on https://github.com/XimeraProject/ximeraFirstSteps.


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



## Installing Visual Studio Code


Visual Studio Code, also 'VSCode' or just 'code', is a popular free editor and development environment by Microsoft, that supports git, docker and TeX.


> [!NOTE] 
> The 'Code' in 'Visual Studio Code' is very relevant: Visual Studio is a different and much bigger Microsoft product, that is not needed nor relevant for Ximera.

### Installing VSCode on Windows

Download and install Visual Studio Code from
```
https://code.visualstudio.com/download
```

<!-- After starting Open Visual Studio Code, hit `Ctrl-~` to open a Terminal Window, which will initially be PowerShell. It is suggested to enable a more complete Linux system by typing -->

It is **not necessary not** to start Visual Studio Code right now. 
The setup will be completed and slightly adapted below, when you'll install Docker.

### Installing VSCode on Linux 

If using Linux with a Debian-based distribution such as Ubuntu, add the Microsoft windows install dependencies before installing Microsoft Visual Studio Code:

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
and start VSCode (inside your current directory `.`) with
```console
code .
```

## Installing (or preparing) WSL

It is strongly suggested to enable '[WSL](https://learn.microsoft.com/en-us/windows/wsl/install)', the Microsoft 'Windows Subsystem for Linux'.
It will be used by VSCode and Docker.

Start a Powershell window and run
```console
wsl --install
```
This installs an Ubuntu subsystem.
It asks for a username, we suggest to take your first name. Choose a not too difficult password (you won't need it often, but should not loose it.) The account is local to your PC.
The `wsl --install` will give you a prompt *inside* this Linux subsystem, in which you type
```console
mkdir ~/git
cd ~git
code .
```
If somehow you're not (anymore) in this Linux shell, you can use a Powershell window with
```console
wsl bash -c "mkdir ~/git; code ~/git"
```
or  (if you happen to have several WS distributions)
```console
wsl -d Ubuntu bash -c "mkdir ~/git; code ~/git"
```
This should start Visual Studio Code (*inside* the WSL subsystem, but this should not bother you too much).

## Installing Docker

When installing [Docker](https://docs.docker.com/desktop/install/windows-install/), accept the license and accept recommendations.You do *not have to sign in*, and may choose to do the survey if you like. Once you finish this, you will see a "Engine running" at the bottom left hand corner of the screen.


Follow the directions for 
- [Windows](https://docs.docker.com/desktop/install/windows-install/). Select the "WSL"  option.
- [MacOs](https://docs.docker.com/desktop/install/mac-install/).
- [Ubuntu (Linux)](https://docs.docker.com/desktop/install/ubuntu/).


## OPTIONAL: Installing LaTeX

Since you will typically compile and deploy in docker, a local TeX installation is not **strictly** necessary.
If you have one already, you can use it, but you might have to add the Ximera package from CTAN.
And there might be some dependencies on old or new versions of some packages that cause issues...

## OPTIONAL: Installing Git (on Windows)

Git is fundamental to working with Ximera. All Ximera documents that will be deployed online must be in Git repository. 

When using Docker-with-WSL, it'll be most convenient to use the git software that's automatically available inside WSL. You can optionally also install git on your Windows PC, but it will not be used for this repo.
<!-- If you have no experience with Git, the developers are happy to help get you started with Git, email: `ximera@math.osu.edu` -->

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


# Test your software and clone this repository

## Start VSCode and Docker

Start VSCode if not yet running.
* on Linux/MacOS with `code .`, in a folder of your choice (eg `~/git`) 
* on Windows please use a Powershell window this very first time and
```console
wsl bash -c "code ~/git"
```
or -- if you did not yet make a ~/git folder:
```console
wsl bash -c "mkdir ~/git; code ~/git"
```

The command `Ctrl+~` will now open a shell *inside* VSCode, which you can use to check if the Docker Engine is running by typing:
```console
docker ps
```
If you get an error with 'permission denied' and something about a 'socket', that probably means the Docker Engine is not running. It could be that your Ubuntu distribution is not 'Enabled' in the WSL section of the Resources option in Docker Settings. Or it could be that you'r not member of the 'docker' group of your system. Or it could be one of a zillion other problems. Make an Issue if in trouble.

Start the Docker Engine if needed from the Docker Desktop application.
You can minimize the Docker window.

Now the 'docker ps' command should no longer return an error. If it still does: complain with ab Issue that this README is incomplete.

<!-- 
If on Windows, once you start VS Code, make sure you install the "WSL Extension." 
VS Code may ask you if you want to install this via a popup window in the lower left or right corner of your screen. -->


## OPTIONAL: Obtain a GitHub account and "Fork" this repository


For a first impression of Ximera, you can just **clone** this repo on your local PC,
and you won't need a Github account.

For deploying Ximera courses, tt's convenient to have a GitHub account and **fork** this repo to `https://github.com/YOUR-GIT-USER-NAME/ximeraFirstSteps`.
Accounts are free, and educators can request special access.
Once logged in into GitHub, at the top right there will be an option to "Fork" the https://github.com/XimeraProject/ximeraFirstStep repository, which will create your own copy which you can then clone, push and publish, e.g. on https://ximera.osu.edu.



## Clone ximeraFirstSteps

If you've chosen to *fork* the repo, you should clone  **your copy** of ximeraFirstSteps.
If not, you clone the global https://github.com/XimeraProject/ximeraFirstSteps.git repo.  In this case you will not be able to push your changes, but this will not be needed to get familiar with Ximera and test the setup and functionality on your local device.

For all platforms, upon cloning this repo VS Code might ask if you "trust the authors", which you should,
and also to 'Install recommended extensions', which you also should do.

Now type `Ctrl-Shift-P` to open the 'Command' window, start typing 'Git clone' until `Git= Clone` appears at the top of the list, and hit enter. 
Select `Clone from Github`, and start typing `ximeraProject/ximeraFirstSteps` (or `<yourgithubname>/ximeraFirstSteps`)  until you can select the correct copy of 'ximeraFirstSteps'.

![An image of VS Code Git: Clone (from Github)](graphicsREADME/cloneRepo.png "Cloning ximeraFirstSteps")

Hit enter, select a place where to clone your local copy of this repo. 
On Windows, we strongly suggest to use the `~/git` folder *inside* the WSL subsystem.
This will have *much* better performance than cloning directly on your Windows disk.

VS Code will ask to "Open in New Window", and this will start a new VSCode window for this repo.


## Allow extensions

Once you clone this repository, VS Code will ask you, via a pop-up (or a notification flag) in the lower right-hand corner, if you want to install extensions. **Install the suggested extensions.**
Once the extensions are installed, at the bottom right-hand corner of your VS code window you should have four new small buttons, named "PDF," "HTML," "Bake," "Serve," and "Extra".

## PDF/HTML/Bake 

If you open any .tex file, e.g. by typing CTRL-p and typing/selecting basicWorksheet.tex, you can compile it to a PDF by hitting the 'PDF' button
at the right bottom of your screen. Similarly, an HTML version is generated by selecting the 'HTML' button.

The very first time you push one of the buttons a docker image will automatically be downloaded. It's very large, several gigabytes, and will take time.
Later compilations will be much faster.

If you press the "Bake" button, **all** files will be compiled to HTML. The very **first** time it will compile all the documents, and this will take some time. However, the next time you compile, it will only compile updated files and that will be **much** faster.


# Testing the course(s) on your local ximeraserver

## Start a local ximeraserver

Start a ximeraserver on your own PC from the 'Extra' menu. 
(The first time, it will download the docker image, which will take some time.)

A server should start on http://localhost:2000. 
It is accessible with your browser, or even *inside VSCode* with the 'Preview in Simple Browser' option form the Extra menu. (At this point, you have not yet published any courses, and you'll only get a mostly empty screen...)

## Check the file `./scripts/config.txt`

The file `./scripts/config.txt` contains some optional settings for compiling and publishing your courses.
You should not have to change anything to publish to your local ximeraserver. 

## Publish to the testserver

Just hit the 'Serve' button. Make sure you first hit 'Bake', and that all files/changes have been committed. It's not necessary to also 'push' your changes at this point.
You should now have access to the course(s), by default on http://localhost:2000/test.

## Compare with the published course

Once you've deployed the course, you can compare your local version to ours. 
At this time (10/2024), your local version will have a 'KULeuven' styling, but this will change (hopefully) soon, when you'll be able to choose or make more layout options.

-	https://ximera.osu.edu/firststeps24/aFirstStepInXimera
-	https://set.kuleuven.be/voorkennis/firststeps24/aFirstStepInXimera/basics/basicWorksheet
-	https://set.kuleuven.be/voorkennis/firststeps24/variant/aNewlayout/variant/basics/basicWorksheet


The KULeuven version also contains two PDF versions: one with, and one without the answers.

# Publishing the course(s) to a public ximeraserver (needs a gpg key)

The file scripts/config.txt determines where (and with which version of Ximera...) to publish your courses.

The relevant settings are 

* XIMERA_URL contains the (url of) the server on which to publish your repo (`http://localhost:2000/` for test, `https://ximera.osu.edu` for real)
* XIMERA_NAME contains the name (lowercase, no underscores!) under which to publish this repo, eg XIMERA_NAME=testing would publish to https://ximera.osu.edu/testing.

You can save and commit these settings.

But, to deploy to a public server (e.g. the OSU server), a (personal) GPG key is needed. This ensures that no one "overwrites" your online course without you knowing. (Even if this did happen, you can always just re-deploy and contact the Ximera developers).

This personal key is to be saved in a 'hidden' config file `.ximeraserve`, and should **never** be committed and pushed.


This git repo has a `.ximeraserve` with a dummy key and key-id which can be used to publish to localhost, which has to be replaced with your own key and key-id when publishing elsewhere.
In VSCode, the `.ximeraserve` file is by default not visible in the Explorer window, but you can open it with CTRL-o, and then typing `.ximeraserve` (which is in the root folder of your repo).

If you do not yet have a GPG key (check with `gpg --list-keys`), you can generate one with
```
 gpg --gen-key
```
Answer all the questions, but **leave the passphrase blank**.

Note: on MacOS you might not be able to leave the passphrase blank. In this case go to https://gpgtools.org/ and install the GPG Suite. This will provide a GUI that will produce a GPG key with spaces. Delete these spaces and this new key (without spaces) is your key. You should quite your terminal and open a new one. 


In `.ximeraserve`, replace the long hex string in `GPG_KEY_ID=215FC33FAB44D5CCA31A04B2CC78CB561FDC49A8` with your key-id (also of the form `ABCD3562DBF99...29292` or whatever).

You will also need your private key, which you can show with 

```
gpg --armor --export-secret-key
```
or (if you happen to have several keys ...)
```
gpg --armor --export-secret-key ABC...your-key-id...92
```
which will show 
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

Copy the key itself, thus the stuff above *without* the  -----BEGIN... en -----END headers :
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
and paste it in `.ximeraserve`, replacing the dummy key:
```
GPG_KEY_ID=ABCD3562DBF99 ... 29292
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
EOF
)
```
Note: leave the 'EOF' and ')' at the end!

Delete the first few lines with comments (that by now are wrong, and might confuse you in the future!), 
and save the `.ximeraserve` file.

Note: `.ximeraserve` will (**or should**) not be updated in git, as it is (**or should be**) in the `.gitignore` file.
You should **NEVER** commit, publish or send your private key.
You may want to make a backup of this file/key in a safe place...

Now, pressing the 'Serve' button in the status bar at the bottom should publish your courses.


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


# Making new courses

There are several options to create a new repo, with new Ximera courses that will deploy online:

## Starting from https://github.com/XimeraProject/ximeraNewProject

You clone [this repo](https://github.com/XimeraProject/ximeraNewProject), REMOVE STUFF, CHANGE THE NAME OF THE REPO and PUSH to your account.
You start adding TeX code ...

## Starting with an existing repository

You follow these steps carefully. 

You'll copy following files and folders from [this repo](https://github.com/XimeraProject/ximeraNewProject) to your repo:
* `.gitignore` 
* `scripts`
* `.vscode`

If there is already a `.gitignore` we suggest you replace your file with ours, or at least check the differences. Did we mention you should never push `.ximeraserve`?
If there is already a folder `.vscode` we suggest you compare your files with ours and check the differences.

The .vscode folder is not needed, but without it, you'll not have the PDF/HTML/Bake/Serve buttons, and you'll have to start 
* `./scripts/xmlatex compilePdf <path-to-your-texfile>`
* `./scripts/xmlatex compile <path-to-your-texfile>`
* `./scripts/xmlatex bake`
* `./scripts/xmlatex serve`

Note: you may need to make xmlatex executable, via
```
chmod +x ./scripts/xmlatex
```
