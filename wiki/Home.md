# Welcome
Welcome to the start page of the Kitchen Sandbox Bitbucket Wiki

## [VagrantMachines](https://bitbucket.org/srvk/kitchen-sandbox/wiki/browse/VagrantMachines) ##
### [Overview](https://bitbucket.org/srvk/kitchen-sandbox/wiki/VagrantMachines/MachineIndex)
* [Prix Fixe]() ( coming soon )
* [Interaction in Virtual Worlds]()
* [Arabic Transcriber](https://bitbucket.org/srvk/kitchen-sandbox/wiki/browse/VagrantMachines/ArabicTranscriber)
* [Kaldi Language Model Builder](https://bitbucket.org/srvk/kitchen-sandbox/wiki/browse/VagrantMachines/KaldiLmBuild) an add-on to Kaldi based virtual machines to build language models from sample text
* [Mario Base Box](https://bitbucket.org/srvk/kitchen-sandbox/wiki/browse/VagrantMachines/MarioBaseBox)
* [TEDLIUM](https://bitbucket.org/srvk/kitchen-sandbox/wiki/browse/VagrantMachines/Tedlium) a fully open-source Kaldi training setup which also has a graphical user interface with error analysis for speech developers.

### General wiki help

This wiki uses the [Markdown](http://daringfireball.net/projects/markdown/) syntax.

The wiki itself is actually a git repository, which means you can clone it, edit it locally/offline, add images or any other file type, and push it back to us. It will be live immediately.

### Git tips: ###
"git push" is more like 3 steps:

1.   git add <newfile>
1.   git commit
1.   git push

To update a brand new Git repo with a tree of pre-existing code:

1.   git clone https://github.com/your-git-username/new-empty-repo-name.git
1.   # copy the code into the current working directory
1.   git push origin master

Useful equivalent to "svn up":

* git reset --hard origin/master

Go ahead and try:

```
$ git clone https://fmetze@bitbucket.org/srvk/kitchen-sandbox.git/wiki
```

Wiki pages are normal files, with the .md extension. You can edit them locally, as well as creating new ones.

## Syntax highlighting


You can also highlight snippets of text (we use the excellent [Pygments][] library).

[Pygments]: http://pygments.org/


Here's an example of some Python code:

```
#!python

def wiki_rocks(text):
    formatter = lambda t: "funky"+t
    return formatter(text)
```


You can check out the source of this page to see how that's done, and make sure to bookmark [the vast library of Pygment lexers][lexers], we accept the 'short name' or the 'mimetype' of anything in there.
[lexers]: http://pygments.org/docs/lexers/


Have fun!
