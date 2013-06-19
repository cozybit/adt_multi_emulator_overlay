This repo contains the ADT multi emulator overlay

In order to (un)install this overlay, use the overlay.sh script:

Installing:

 $ ./overlay -a install -p path_to_android_sdk

Restoring:

 $ ./overlay -a restore -p path_to_android_sdk

If your $ANDROID_HOME env var is defined, the -p parameter is not necessary.
