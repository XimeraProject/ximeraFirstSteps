
# Software requirements

- a standard TeX installation is sufficient to generate PDF versions of your courses
- Github Codespaces provide a convenient development environment, with zero installation on your PC
- using Git, Docker and Visual Studio Code, a local development environment can be set up that is fully compatible with the Codespace experience
- in the future, the Docker requirement might change (again).

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


# Test the installation

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



## Start your first project 

On Github, create a personal repo, based on the template ximeraNewProject or ximeraFirstSteps.

In VSCode, type `Ctrl-Shift-P` to open the 'Command' window, start typing 'Git clone' until `Git Clone` appears at the top of the list, and hit enter. 
Select `Clone from Github`, and start typing the name of your (username and) repo until you can select the correct repo.

![An image of VS Code Git: Clone (from Github)](https://github.com/user-attachments/assets/92b85301-4da5-483e-beb5-178b3d193ce2 "Cloning ximeraFirstSteps")

Hit enter, select a place where to clone your local copy of this repo. 
On Windows, we strongly suggest to use the `~/git` folder *inside the WSL subsystem*.
This will have *much* better performance than cloning directly on your Windows disk,
and you won't have any issues with line-endings that will drive you crazy.

VS Code will ask to "Open in New Window", and this will start a new VSCode window for this repo.

Upon opening a repo the first time, VS Code might ask if you "trust the authors", which you should do.

## Allow extensions

Once you open your repository, VS Code will ask you, via a pop-up (or a notification flag) in the lower right-hand corner to install suggested extensions. **Install the suggested extensions.**
Once the extensions are installed, at the bottom right-hand corner of your VS code window you should have small buttons, named "PDF," "HTML," "SERVE" and "Extra".

## Start a local ximeraserver

Start a ximeraserver on your own PC from the 'Extra' menu. 
(The first time, it will download the docker image, which will take some time. In the mean time, you can continue the next steps of installation the procedure)

 Go to http://localhost:2000/repositories

It is accessible with your browser, or even *inside VSCode* with the 'Preview in Simple Browser' option form the Extra menu. (Because at this point you have not yet published any courses, you'll only get a mostly empty screen...)

## PDF/HTML/SERVE

If you open any .tex file, e.g. by typing CTRL-p and typing/selecting basicWorksheet.tex, you can compile it to a PDF by hitting the 'PDF' button
at the right bottom of your screen. Similarly, an HTML version is generated by selecting the 'HTML' button.

The very first time you push one of the buttons a docker image will automatically be downloaded. It's very large, several gigabytes, and will take time.
Later compilations will be much faster.

If you press the "SERVE" button, **all** committed files will be compiled to HTML. The very **first** time it will compile all the documents, and this will take some time. However, the next time you compile, it will only compile updated files and that will be **much** faster.

It's not necessary to 'commit' or 'push' your changes at this point, except for *new files*: they only get compiled once committed.

## Check the course(s) on your local ximeraserver

You should now have access to the course(s) via http://localhost:2000/.


The file `./xmScripts/config.txt` contains some optional settings for compiling and publishing your courses.
You should not have to change anything to publish to your local ximeraserver. 
