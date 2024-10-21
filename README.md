This repository has a basic Ximera course along with instructions for deploying that will help you get started using Ximera. It is designed to help a new user. If there are problems with the instructions below, please submit an issue on the "Issues" tab on https://github.com/XimeraProject/ximeraFirstSteps.


The course(s) in this repo are published on following places:

* https://ximera.osu.edu/firststeps24/aFirstStepInXimera 
* https://set.kuleuven.be/voorkennis/firststeps24/aFirstStepInXimera/basics/basicWorksheet
* https://set.kuleuven.be/voorkennis/firststeps24/variant/aNewlayout/variant/basics/basicWorksheet

and if you follow the instructions in this Readme, it could very soon be available on your own pc on

* http://localhost:2080/firststeps24  (from within your Codespace)
or
* http://localhost:2000/firststeps24  (if running this on your local PC)

where you will be able to change, test and adapt it. 

## Quick Start

This section will allow you to play around with Ximera, edit your first Ximera xourse and publisgh a testversion.
You'll have some difficulty saving your work (but it is possible).
If you want to be able to save your work, first clone this repo. 

Procedure:
* Start a codespace  (under the green 'Code' button)
* Presumably, Github will tell you (somewhat hidden), that YOU will pay for thsi codespace. You can ignore hte warning, as the first 120 hourse per month a free, which is sufficient for playing around.
* The first time you start this codespace, it will take a few minutes to build a so-called 'devcontainer' for you. Subsequent starts will be faster.
* You should get a Visual Studio Code window inside your browser, with in the bottom right of the window buttons 'PDF', 'HTML', SERVE' and 'Extra'
* Push 'SERVE' and wait a few minutes to let your Codespace compile the demo-course
* Select 'PORTS' (next to 'TERMINAL'), and click on the World-icon that appears after the URL under 'Forwarded Address' to open a browser window on your private Ximera server inside your own Codespace.



## Compare with the published course

Once you've deployed the course, you can compare your local version to ours. 

The KULeuven version also contains two PDF versions: one with, and one without the answers.

# Publishing the course(s) to a public ximeraserver (needs a gpg key)

The file scripts/config.txt determines where (and with which version of Ximera...) to publish your courses.

The relevant settings are 

* XIMERA_URL contains the (url of) the server on which to publish your repo (`http://localhost:2000/` for test, `https://ximera.osu.edu` for real)
* XIMERA_NAME contains the name (lowercase, no underscores!) under which to publish this repo, eg XIMERA_NAME=testing would publish to https://ximera.osu.edu/testing.

You can save and commit these settings.

But, to deploy to a public server (e.g. the OSU server), a (personal) GPG key is needed. This ensures that no one "overwrites" your online course without you knowing. (Even if this did happen, you can always just re-deploy and contact the Ximera developers).

When using Codespaces, your own GPG key is best added to Codesapces Scretes, as GPG_KEY and GPG_KEY_ID.

If you do not yet have a GPG key (check with `gpg --list-keys`), you can generate one with
```
 gpg --gen-key
```
Answer all the questions, but **leave the passphrase blank**.

Note: on MacOS you might not be able to leave the passphrase blank. In this case go to https://gpgtools.org/ and install the GPG Suite. This will provide a GUI that will produce a GPG key with spaces. Delete these spaces and this new key (without spaces) is your key. You should quite your terminal and open a new one. 


Add  `GPG_KEY_ID=ABCD3562DBF99...29292` as a Github secret

You will also need your private key, which you can show with 

```
gpg --export-secret-key
```
or (if you happen to have several keys ...)
```
gpg --export-secret-key ABC...your-key-id...92
```
which will show 
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

Put GPG_KEY=sdkjfsdkjfsklj  in yout Github Secrets




# Debugging

You get an interactive BASH shell **inside** the docker container, with your local folder available under /code.
You could e.g. 
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
