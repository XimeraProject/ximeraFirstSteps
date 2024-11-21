This repository will help get you started as a new Ximera author. It contains a small Ximera demo course and instructions to deploy it both locally and to public servers. 
We'll teach you how to use a Github Codespace to play around with Ximera, edit your first Ximera course, and test a personal online version of it.

Demo versions of this repo are published as:

- [a preview with the newest Ximera layout](https://set.kuleuven.be/voorkennis/firststeps24/aFirstXourseVariant/aFirstFolder/aFirstActivityVariant)
- [a version on the current production server](https://ximera.osu.edu/firststeps24/aFirstXourse/aFirstFolder/aFirstActivity)

The preview version also contains two PDF versions of all pages: one with, and one without the answers (on 11/2024 the links are unfortunately in Dutch...).


Ximera is under active development and new functionality is regularly added. The official Ximera webserver at (https://ximera.osu.edu) currently runs a version that does not yet support the newest features, and in particular not the newer layout that is available for local testing and at the KU Leuven servers. This is expected to change soon.

In case of problems, please submit an issue on the "Issues" tab at [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps).



# Use Github Codespaces to play around with Ximera, without any further setup.

- Log into GitHub and go to [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps)
- Start a Codespace
<br>Push the green 'Code' button, select the `Codespaces` and push the `+` plus sign:
<br>![new_codespace](https://github.com/user-attachments/assets/8abac097-77ad-4187-a4fc-38d5acff62b6)
<br>If there is no `Codespaces` tab, you're presumably not logged in.
- GitHub notifies you (somewhat inconspicuously, it might have been under the button you just pressed) that **you** will pay for the codespace. You can **ignore this warning** as the first 120 hours per month are free, and you should not spend 120 hours playing around with Ximera anyway.
- It will take up to 5 minutes to build a personal `codespace` for you. Subsequent starts of the codespace will be much faster.
- Wait for Visual Studio Code to be completely initialized: it will activate some extensions, and you get buttons in the bottom right of the window: 'PDF,' 'HTML,' 'SERVE,' and 'Extra'. 
- Push 'SERVE' and wait a few minutes to compile the demo course. Subsequent builds will be faster.
- Select 'PORTS' (next to 'TERMINAL', in the right bottom pane), and click on the "globe" icon that appears next to the URL under 'Forwarded Address' to open a browser window on your private Ximera server inside your Codespace.
- Hit `CTRL-P` to open a file, type 'AFirstA' to see that the file aFirstActivity.tex is shown. Press enter to open it, change the `\title` around line 11 to e.g. `A VERY basic activity`, press `CTRL-S` to save, and hit `SERVE` again. After a few seconds, an orange `Update` button will appear on the page in the Ximera course, and after pushing it, the title will be updated. 
- Play around changing other things in the activities, push SERVE, and look at the results.
- Be impressed. Decide to look further into this and to write your own content. Contact us.

As Ximera is under active development, some things might not be as smooth as suggested here, and some things might change quickly. Do not hesitate to contact us. 
The current production site has been used since 2016 for hundreds of courses by many thousands of students. These courses will continue to work unchanged in the new version, with an updated layout. 
New functionality will become available for new or updated courses.

#  Further steps if you liked what you saw

## Use your local TeX installation 

First, to create a PDF version of a Ximera course or activity, you can use your existing (recent) TeX installation with a recent version of the Ximera package installed (as found on CTAN).
But, the real fun of Ximera comes with the online versions of the courses, and online development is easier with either Github Codespaces or Docker.

## Use Github Codespaces for further experimenting with Ximera

For further experimenting, you need a personal copy of this repository, where you can save changes.

If you decide to make your own **new** Ximera content, it is better to create a new repo using [ximeraNewProject](https://github.com/XimeraProject/ximeraNewProject) as a **Template**. There should be a large green "Use this template" button near the top-right of that page. You could also start a **Template** from this [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps) repo, which contains some more demo files.

## Upgrade an existing repository

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
- `./xmScripts/xmlatex updateDevEnv`

The xmlatex script will download and start a docker container to compile your code. It does not need nor use a local TeX installation. But it requires a correct Docker setup on your PC.
It is not required but strongly advised to also have Visual Studio Code. 
It remains possible though to edit your .tex files with the editor of your choice.
\
Note: in a codespace (or inside a Docker container), `pdflatex` and `xake` are available and the xmlatex script is in your PATH so you can use

- `xmlatex compilePdf <path-to-your-texfile>`
- `xmlatex compile <path-to-your-texfile>`
- `xmlatex bake`
- `xmlatex serve`
- `xmlatex updateDevEnv`



## Developing on your own PC

If you prefer to work locally on your own PC, it is strongly advised to use Docker as explained [here](README_localsetup.md).

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
