This repository contains a small Ximera demo course along with instructions for deploying it, to get you started as a new Ximera user. If there are problems with the instructions below, please submit an issue on the "Issues" tab at [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps).

The course(s) in this repo are published in the following locations:

- https://ximera.osu.edu/firststeps24/aFirstXourse/aFirstFolder/aFirstActivity 
- https://set.kuleuven.be/voorkennis/firststeps24/aFirstXourse/aFirstFolder/aFirstActivity
- https://set.kuleuven.be/voorkennis/firststeps24/aFirstXourseVariant/aFirstFolder/aFirstActivityVariant

If you follow the instructions in this Readme, you can publish the course in a Codespace, 
or if working on your own PC at http://localhost:2000/ximerafirststeps
where you will be able to you play around with Ximera, edit your first Ximera course, and test a personal online version.  

Ximera is under active development, and new functionality is regularly added. The official Ximera webserver at https://ximera.osu.edu currently runs a version that does not yet support the newest features, and in particular not the newer layout that is available for local testing and at the KU Leuven servers. This is expected to change soon.


# Use Github Codespaces to play around with Ximera, without any further setup.

- Log into GitHub and go to [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps)
- Start a Codespace (if under the green 'Code' button there is no tab `Codespaces`, you're presumably not logged in). Push the green button 'Create a codespace on main'.
- GitHub notifies you (somewhat inconspicuously, it might have been under the button you just pressed) that **you** will pay for the codespace. You can **ignore this warning** as the first 120 hours per month are free, and you should not spend 120 hours playing around with Ximera anyway.
- Wait for up to 5 minutes to build a `codespace` for you. Subsequent starts of the codespace will be much faster.
- You get a Visual Studio Code window inside your browser with buttons in the bottom right of the window: 'PDF,' 'HTML,' 'SERVE,' and 'Extra'. Wait for Visual Studio Code to be completely initialize: it will activate some extensions, as could be seen on the bottom status bar.
- Push 'SERVE' and wait a few minutes to compile the demo course. Subsequent builds will be faster.
- Select 'PORTS' (next to 'TERMINAL', in the right bottom pane), and click on the "globe" icon that appears next to the URL under 'Forwarded Address' to open a browser window on your private Ximera server inside your Codespace.


#  Further steps if you liked what you saw

## Use your local TeX installation 

First, to create a PDF version of a Ximera course or activity, you can use your existing (recent) TeX installation with a recent version of the Ximera package installed (as found on CTAN).
But, the real fun of Ximera comes with the online versions of the courses, and online development is easier with either Github Codespaces or Docker.

## Use Github Codespaces for further experimenting with Ximera

For further experimenting, you could clone or fork the repo to get a personal copy, where you can save changes.

If you decide to make your own **new** Ximera content, it is better to start create a new repo using [ximeraNewProject](https://github.com/XimeraProject/ximeraNewProject) as a template. There should be a large green "Use this template" button near the top-right of that page. You could also start from this [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps) repo, which contains some more demo files.

## Starting with an Existing Repository

If you already have a repo with a Ximera course, you can 
copy the following files and folders from [this repo](https://github.com/XimeraProject/ximeraNewProject) to your repo:

- `.gitignore`
- `xmScripts/`
- `.vscode/`

If a `.gitignore` file already exists in your repo, we suggest you replace it with ours or at least check for differences. Note: **never** push the file `.xmKeyFile` with your own key.

If a `.vscode` folder exists, compare your files with ours and check for differences.
The `.vscode` folder is not required, but without it, you won’t have the PDF/HTML/SERVE buttons, and you'll need to run:

- `./xmScripts/xmlatex compilePdf <path-to-your-texfile>`
- `./xmScripts/xmlatex compile <path-to-your-texfile>`
- `./xmScripts/xmlatex bake`
- `./xmScripts/xmlatex serve`

The xmlatex script will download and start a docker container to compile your code. It does not need not use a local TeX installation. But is requires a correct Docker setup on your PC.
\
Note: in a codespace (or inside a Docker container), `pdflatex` and `xake` are available and the xmlatex script is in your PATH so you can use

- `xmlatex compilePdf <path-to-your-texfile>`
- `xmlatex compile <path-to-your-texfile>`
- `xmlatex bake`
- `xmlatex serve`

## Publishing the course(s) to a public Ximera server (requires a GPG key)

The file `xmScripts/config.txt` determines where (and with which version of Ximera) to publish your courses.

Relevant settings:

- **XIMERA_URL** contains the server URL where you want to publish your repo (`http://localhost:2000/` for testing or `https://ximera.osu.edu` for a live deployment).
- **XIMERA_NAME** contains the name (lowercase, no underscores!) under which to publish this repo, e.g., `XIMERA_NAME=testing` would publish to https://ximera.osu.edu/testing.

You should save changes to these settings, committing them is optional.

To deploy to a public server (e.g., the OSU server), a (personal) GPG key is needed to ensure that no one overwrites your online course without your knowledge.

This key is to be stored in the environment variables `GPG_KEY` and `GPG_KEY_ID`.
When using Codespaces, this should be done as Codespaces Secrets named `GPG_KEY` and `GPG_KEY_ID`: in GitHub, go to your profile picture, select "Settings," then on the left select "Codespaces," and you should see "Secrets" with a green button labeled "New secret."
It is also possible to overwrite the keys in the file `.xmKeyFile` (but make sure *NEVER* to commit-and-push that file)


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

You may need to make `xmlatex` executable with
```
chmod +x ./scripts/xmlatex*
```
