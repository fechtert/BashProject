# BashProject
Bobby Fechtel's IT3038C Bash Project

The purpose of the script is to backup media stored in a directory.

When I run races with the running club, I like to save any photos and/or videos that were taken at the race.
I do not frequently go back and look at these photos/videos, however.
This script allows me to back up and compress photos and/or videos (or any other files I throw at it) that are located in a single directory.
This repository comes with an example directory, including several photos from my last race and a video.
This script allows me to backup and compress these so that they take up less storage space than they would otherwise.

===================================================================

How to use the script:

\nUsage: ./media_backup.sh -d <input_directory> <mode: -p -v or -a>
\nOptions:
\n	-d <input_directory>: specify the input directory where files to be backed up are found.
\n	-p: photo mode - will only back up .png .jpg and .jpeg files in the input directory.
\n	-v: video mode - will only back up .mp4 and .mov files in the input directory.
\n	-a: all mode - will back up all files in the input directory.
\n	-h: displays this help information.
