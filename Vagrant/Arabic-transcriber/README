Instructions:

 * Copy these files to new local folder
 * Path to that folder and execute 'vagrant up'
 * This will download a VM with Kaldi, Arabic models and transcriber code,
    and configure the VM environment.
 * When it finishes, in the folder, type 'vagrant ssh'

If you are on a system running X11, this should log you into a shell on
the guest as the 'vagrant' user, and automatically bring up a
small panel with buttons to launch an Xterm, and a TRee icon button to
launch the TRanscriber. 

 * Click the tree icon to start Kaldi offline transcriber in a
    small xterm window.  (If you'd prefer to run it in the shell window where you
    started, run './startup.sh' instead) It will say "Kaldi offline transcriber ready"
 * On your host computer, in the new local folder, you will see new
    folders 'transcribe-in/' and 'transcribe-out/'. Drag or copy a .mp4 video
    (or .mp3 audio, or .wav audio, or most any media format) into the
    transcribe-in folder.
 * Within 10 seconds you should see activity in the transcriber window.
    The system runs in slower-than-real-time, so expect transcription to take
    roughly twice the length of the audio or video.
 * When it finishes, you will see resulting transcription in 'transcribe-out/'
    For example if your input file was ALJ.mp4, the output will be ALJ.mp4.srt

There are two modes to transcription, normal, and permissive segmentation.  In 
practice, a lot of videos produced no transcriptions because segmentation failed
to segment it into one of the three categories: "speech", "music", "jingle".
To work around this and try transcribing audio in spite of not fitting these
categories, the default setting in the Makefile:

PERMISSIVE_SEGMENTATION?=yes   

For stricter segmentation, change "yes" to "no"
