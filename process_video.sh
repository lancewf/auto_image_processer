#! /bin/bash

processVideoFile() {
    file=$1
    echo `date` " processing: '$file'"

    # remove spaces in the file name
    filenameWithExtention=$(echo -e "${file}" | tr -s ' ' | tr ' ' '_')
    filename=${filenameWithExtention%.*}

    mkdir $filename
    mv "$file" $filename/$filenameWithExtention

    ogvFilename="$filename/${filename}.ogv"
    m4vFilename="$filename/${filename}.m4v"

    echo `date` " creating ogv: $ogvFilename"
    ffmpeg -i $filename/$filenameWithExtention -b 2500k -vf scale=320:-2 $ogvFilename

    chmod 777 $ogvFilename

    echo `date` " creating m4v: $m4vFilename"
    ffmpeg -i $filename/$filenameWithExtention -b 2500k -vf scale=320:-2 -strict -2 $m4vFilename

    chmod 777 $m4vFilename
    
    echo `date` " finished" >> $filename/finished.txt
    echo `date` " finished processing '$file'"
}

checkForVideos() {
 watch_folder=$1
 cd $watch_folder
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
	        processVideoFile "$file"
        else
	        echo `date` " do not suport file: '$file'"
        fi
     else 
        echo `date` " '$file' upload in progress"
     fi

    fi
 done
}
