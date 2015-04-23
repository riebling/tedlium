You might get an error when buliding this Docker container on Ubuntu


```
#!bash

docker build .
```


(tons and tons of output)


```
#!bash

git clone git@bitbucket.org:fmetze/kitchen-sandbox.git/wiki

Step 31 : RUN curl http://bark.phon.ioc.ee/tanel/kaldi-offline-transcriber-data-2014-12-17.tgz | tar -xvzC /opt/kaldi-offline-transcriber
 ---> Running in 5a682a931eb0
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
language_model/
language_model/pruned.vestlused-dev.splitw2.arpa.gz
language_model/pruned6.vestlused-dev.splitw2.arpa.gz
language_model/compounder-pruned.vestlused-dev.splitw.arpa.gz
language_model/vestlused-dev.splitw2.dict
kaldi-data/
kaldi-data/tri3b/
kaldi-data/tri3b/final.mat
kaldi-data/tri3b/tree
kaldi-data/tri3b/final.mdl
kaldi-data/tri3b/splice_opts
kaldi-data/tri3b/final.alimdl
kaldi-data/nnet5a_pnorm_fast/
kaldi-data/nnet5a_pnorm_fast/final.mat
kaldi-data/nnet5a_pnorm_fast/tree
kaldi-data/nnet5a_pnorm_fast/final.mdl
 52 1088M   52  569M    0     0   128k      0  2:24:33  1:15:38  1:08:55     0
curl: (56) Recv failure: Connection timed out

gzip: stdin: unexpected end of file
tar: Unexpected EOF in archive
tar: Unexpected EOF in archive
tar: Error is not recoverable: exiting now
INFO[5416] The command [/bin/sh -c curl http://bark.phon.ioc.ee/tanel/kaldi-offline-transcriber-data-2014-12-17.tgz | tar -xvzC /opt/kaldi-offline-transcriber] returned a non-zero code: 2 

```
