#! /bin/sh

cd /usr/src/mjpg-streamer/mjpg-streamer/mjpg-streamer-experimental
./mjpg_streamer -o "output_http.so -w ./www" -i "input_uvc.so"

exit
