This repository will help get you started as a new Ximera author. It contains a small Ximera demo course and instructions to deploy it both locally and to public servers. 
It explains how to use a Github Codespace to play around with Ximera, how to edit your first Ximera course and how to test a personal online version of it.

Demo versions of this repo are published as:

- [a preview with the newest Ximera layout](https://set-p-dsb-zomercursus-latest.cloud-ext.icts.kuleuven.be/firststeps/aFirstXourseVariant/aFirstFolder/aFirstActivityVariant)
- [a version on the current production server](https://ximera.osu.edu/firststeps24/aFirstXourse/aFirstFolder/aFirstActivity)

The preview version also contains two PDF's of all pages: one with, and one without the answers (on 11/2024 some labels might unfortunately be in Dutch...).
The preview version is automatically updated whenever a new tag is created on this repo.


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

## Use Github Codespaces for further experimenting with Ximera

For further experimenting, you need a personal copy of this repository, where you can save changes.

If you decide to make your own **new** Ximera content, it is better to create a new repo using [ximeraNewProject](https://github.com/XimeraProject/ximeraNewProject) as a **Template**. There should be a large green "Use this template" button near the top-right of that page. You could also start a **Template** from this [ximeraFirstSteps](https://github.com/XimeraProject/ximeraFirstSteps) repo, which contains some more demo files.

## Upgrade an existing repository

If you already have a repo with a Ximera course, you can 
copy the following files and folders from [this repo](https://github.com/XimeraProject/ximeraNewProject) to your repo:

- `xmScripts/`     (this folder contains the `xmlatex` script that builds the Ximera courses) 
- `.gitignore`
- `.vscode/`       (only  necessary when using VSCOde, which is advised for new )
- `.devcontainer/` (only necessary when using a devcontainer or codespace)

If a `.gitignore` file already exists in your repo, we suggest you replace it with ours or at least check for differences. Note: **never** push the file `.xmKeyFile` with your own key.

If a `.vscode` folder exists, compare your files with ours and check for differences.
The `.vscode` folder is not required, but without it, you won’t have the PDF/HTML/SERVE buttons, and you'll need to run:

- `./xmScripts/xmlatex compilePdf <path-to-your-texfile>`
- `./xmScripts/xmlatex compile <path-to-your-texfile>`
- `./xmScripts/xmlatex bake`
- `./xmScripts/xmlatex serve`
- `./xmScripts/xmlatex updateDevEnv`


The xmlatex script will download and start a docker container to compile your code. It does not need nor use a local TeX installation. But it requires a correct Docker setup on your PC.
Files in `.xmScripts` must be executable. If there is an issue with permissions, open the codespace and run
```
chmod +x ~/xmScripts/xmlatex*
```
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

- **XIMERA_URL** contains the server URL where you want to publish your repo (`http://localhost:2000/` for testing or `https://ximera.osu.edu/` for a live deployment). (NOTE 2025-01: make sure to terminate the XIMERA_URL with a `/`. You'll get exotic errors if you don't.)
- **XIMERA_NAME** contains the name (lowercase, no underscores!) under which to publish this repo, e.g., `XIMERA_NAME=testing` would publish to https://ximera.osu.edu/testing.

You should save changes to these settings, committing them is optional.

To deploy to a public server (e.g., the OSU server), a (personal) GPG key is needed to ensure that no one overwrites your online course without your knowledge.

This key is to be stored in the environment variables `GPG_KEY` and `GPG_KEY_ID`.
When using Codespaces, this should be done as Codespaces Secrets named `GPG_KEY` and `GPG_KEY_ID`: in GitHub, go to your profile picture, select "Settings," then on the left select "Codespaces," and you should see "Secrets" with a green button labeled "New secret."
It is also possible to provide the keys in the file `.xmKeyFile` (but make sure *NEVER* to commit-and-push that file)

To generate a key, add your name and email to xmScripts/config.txt and run
```
xmlatex genKey
```

This will generate and display a new key.

If there is no .xmKeyFile, and if the name .xmKeyFile is properly .gitignored, the key will be also saved in .xmKeyFile, from where it will automatically be used. 


For Github Actions or Codespaces: 
 - copy-paste into a new secret `GPG_KEY_ID`  the one-line string of type `ABCD3562DBF99...29292`
 - copy-paste into a new secret `GPG_KEY`the long multi-line string of type `LS......`. 
 - Restart your Codespace. Actions will pick up the values at every following (re-)run.


**Note**: (advanced)

Current rule: the low-level script ALWAYS uses env vars GPG_KEY and GPG_KEY_ID

These env vars can be 
 - explicitely set in the shell   
```
export GPK_KEY_ID = aaa; 
xmlatex name 
```
or just for one invocation:
```
GPK_KEY_ID = aaa   xmlatex name
```
  - set before (eg from Codespace and/or Action secrets (and strongly suggested in both these use cases)
  - empty, but set by config.txt     (strongly NOT advised)
  - empty, but set by .xmKeyFile   (suggested for local deployments)
  - still empty: this will generate the error "No key found'





## Debugging

With `xmlatex bash` you get an interactive BASH shell **inside** the Docker container, with your local folder available under `/code`.
You could, for example, use
```
pdflatex FILE.tex
```
or
```
luaxake -d compile FILE.tex
```

In some cases you may need to make `xmlatex` executable with
```
chmod +x ./xmScripts/xmlatex*
```
