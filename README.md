# auto_image_processer

Install ffmpeg with `apt install ffmpeg`

# crontab setup

m h  dom mon dow   command

* * * * * /usr/lib/process-video/process_video.sh >> /home/media/ftp/files/process_video/logs/work.log
* * * * * /usr/lib/process-video/process_image.sh >> /home/media/ftp/files/process_image/logs/work.log
