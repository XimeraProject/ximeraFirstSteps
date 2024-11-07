This repository has a basic Ximera course along with instructions for deploying it, which will help you get started using Ximera. It is designed to assist new users. If there are problems with the instructions below, please submit an issue on the "Issues" tab at [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps).

The course(s) in this repo are published in the following locations:

- https://ximera.osu.edu/firststeps24/aFirstStepInXimera 
- https://set.kuleuven.be/voorkennis/firststeps24/aFirstStepInXimera/basics/basicWorksheet
- https://set.kuleuven.be/voorkennis/firststeps24/variant/aNewlayout/variant/basics/basicWorksheet

If you follow the instructions in this Readme, you can publish the course on your own PC at

- http://localhost:2080/firststeps24 (from within your Codespace)  
or
- http://localhost:2000/firststeps24 (if running on your local PC),

where you will be able to change, test, and fine-tune how your content is deployed online.

# Quick Start

This section will help you play around with Ximera, edit your first Ximera course, and publish a test version to your own computer.  

## Fork the repository

You'll have some difficulty saving your work unless you fork this repository.

Procedure:
- Log into GitHub and go to [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps)
- Push the "Fork" button, and now you have a copy of this repository in your account. 
- Start a Codespace (under the green 'Code' button).
- Presumably, GitHub will notify you (somewhat inconspicuously) that **you** will pay for this codespace. You can ignore this warning, as the first 120 hours per month are free, which is sufficient for experimenting.
- The first time you start this codespace, it will take a few minutes to build a "devcontainer" for you. Subsequent starts will be faster.
- You should get a Visual Studio Code window inside your browser with buttons in the bottom right of the window: 'PDF,' 'HTML,' 'SERVE,' and 'Extra.'
- Push 'SERVE' and wait a few minutes to let your Codespace compile the demo course.
- Select 'PORTS' (next to 'TERMINAL'), and click on the "globe" icon that appears next to the URL under 'Forwarded Address' to open a browser window on your private Ximera server inside your Codespace.

This fork will server as your personal copy of our deploy scripts. You can go to your GitHub page, find your fork of this repository, and "Sync fork" to obtain the most recent deploy environment. 
If you want to make **new** Ximera content, either use this repository as a Template (there should be a large "Template" button near the top-right of the page), or use [ximeraNewProject](https://github.com/XimeraProject/ximeraNewProject) as a template.


## Compare with the published course

Once you've deployed the course, you can compare your local version to ours.

The KU Leuven version also contains two PDF versions: one with answers and one without.

## Publishing the course(s) to a public Ximera server (requires a GPG key)

The file `scripts/config.txt` determines where (and with which version of Ximera) to publish your courses.

Relevant settings:

- **XIMERA_URL** contains the server URL where you want to publish your repo (`http://localhost:2000/` for testing or `https://ximera.osu.edu` for a live deployment).
- **XIMERA_NAME** contains the name (lowercase, no underscores!) under which to publish this repo, e.g., `XIMERA_NAME=testing` would publish to https://ximera.osu.edu/testing.

You can save and commit these settings.

To deploy to a public server (e.g., the OSU server), a (personal) GPG key is needed to ensure that no one overwrites your online course without your knowledge. (If this does happen, you can re-deploy and contact the Ximera developers.)

### Publishing online using Codespaces

When using Codespaces, your own GPG key and ID need to be added to Codespaces Secrets as `GPG_KEY` and `GPG_KEY_ID`. In GitHub, go to your profile picture, select "Settings," then on the left select "Codespaces," and you should see "Secrets" with a green button labeled "New secret."

If you do not yet have a GPG key (check with `gpg --list-keys`), you can generate one with
```
gpg --gen-key
```
Answer all the questions, but **leave the passphrase blank**.

> **Note**: On macOS, you might not be able to leave the passphrase blank. In this case, go to https://gpgtools.org/ and install the GPG Suite. This will provide a GUI that will produce a GPG key with spaces. Delete these spaces, and the key (without spaces) is your new key. You may need to quit and reopen your terminal.

Add `GPG_KEY_ID=ABCD3562DBF99...29292` as a GitHub secret.

You will also need your private key, which you can show with
```
gpg --export-secret-key
```
or, if you have multiple keys:
```
gpg --export-secret-key ABC...your-key-id...92
```
This will output something like:
```
WONTWORKRUdBQR1AFURSBLRVJTigUFJJVkkgQktYVJOcxPQ0sk1CREFEdGU5 
...             ...
... OTHER       ...
... LINES       ...
... IN YOUR     ...
... PRIVATE KEY ... 
...             ...
R1AgUFQkxPQJ0tLQVkFURSBJkgLRV0stLSo=
```
Add `GPG_KEY=sdkjfsdkjfsklj` into your GitHub Secrets. Restart your Codespace. If you type
```
echo $GPG_KEY_ID
```
it should return your public GPG key. If not, quit the browser and reload.

## Debugging

You get an interactive BASH shell **inside** the Docker container, with your local folder available under `/code`.
You could, for example, use
```
pdflatex FILE.tex
```
or
```
xake -v compile FILE.tex
```

# Deploying from your own computer

To deploy from your own machine, you will need Docker and VS code installed. We will supply further instructions for this soon.

# Making New Courses

There are several options to create a new repo with new Ximera courses that will deploy online:

## Starting from https://github.com/XimeraProject/ximeraNewProject

Clone [this repo](https://github.com/XimeraProject/ximeraNewProject), **remove extraneous content, change the repo name**, and push to your account.
Then start adding TeX code.

## Starting with an Existing Repository

Follow these steps carefully.

Copy the following files and folders from [this repo](https://github.com/XimeraProject/ximeraNewProject) to your repo:

- `.gitignore`
- `scripts`
- `.vscode`

If a `.gitignore` file already exists, we suggest you replace it with ours or at least check for differences. Remember, you should **never** push `.ximeraserve`.
If a `.vscode` folder exists, compare your files with ours and check for differences.

The `.vscode` folder is not required, but without it, you won’t have the PDF/HTML/Bake/Serve buttons, and you'll need to run:

- `./scripts/xmlatex compilePdf <path-to-your-texfile>`
- `./scripts/xmlatex compile <path-to-your-texfile>`
- `./scripts/xmlatex bake`
- `./scripts/xmlatex serve`

You may need to make `xmlatex` executable with
```
chmod +x ./scripts/xmlatex*
```
