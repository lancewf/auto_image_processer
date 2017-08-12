#! /bin/bash

processFile() {
       file=$1
       echo `date` " processing: $file"

       filenameWithExtention=${file##*/}
       filenameWithExtention=${file/ /_}
       filename=${filenameWithExtention%.*}

       mkdir $filename
       mv "$file" $filename/$filenameWithExtention

       ogvFilename="$filename/${filename}_2500kbitrate_320x.ogv"
       m4vFilename="$filename/${filename}_2500kbitrate_320x.m4v"

       echo `date` " creating ogv: $ogvFilename"
       ffmpeg -i $filename/$filenameWithExtention -b 2500k -vf scale=320:-2 $ogvFilename

       echo `date` " creating m4v: $m4vFilename"
       ffmpeg -i $filename/$filenameWithExtention -b 2500k -vf scale=320:-2 $m4vFilename
       
       echo `date` " finished" >> $filename/finished.txt
       echo `date` " finished processing $file"
}

checkForVideos() {
 cd /home/media/ftp/files/process_video
 #echo `date` " checking for videos"
 for file in *
 do
    if [[ -f $file ]]; then
     fileExtention=${file##*.}
     fileExtention=${file,,}
     lastModifiedTime=`stat -c %Y "$file"`
     currentTime=`date +%s`
     currentTime="$((currentTime - 10))"
     if [ "$lastModifiedTime" -lt "$currentTime" ]; then
        if [[ "$fileExtention" == *.mov ]] || [[ "$fileExtention" == *.mp4 ]] 
        then
	  processFile "$file"
        fi
     else 
        echo `date` " $file upload in progress"
     fi

    fi
 done
}


checkForVideos
