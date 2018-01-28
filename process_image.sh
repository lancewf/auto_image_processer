#! /bin/bash

processFile() {
       file=$1
       echo `date` " processing: '$file'"

       # remove spaces in the file name
       filenameWithExtention=$(echo -e "${file}" | tr -s ' ' | tr ' ' '_')
       filename=${filenameWithExtention%.*}

       mkdir $filename
       mv "$file" $filename/$filenameWithExtention

       thumbnailFilename="$filename/${filename}-th.jpeg"

       echo `date` " creating thumbnail: $thumbnailFilename"
       ffmpeg -i $filename/$filenameWithExtention -vf scale=250:-2 $thumbnailFilename
       
       echo `date` " finished" >> $filename/finished.txt
       echo `date` " finished processing '$file'"
}

checkForImages() {
 cd /home/media/ftp/files/process_image
 for file in *
 do
    if [[ -f $file ]]; then
     #echo `date` " working file: '$file'"
     fileExtention=${file##*.}
     fileExtention=${file,,}
     lastModifiedTime=`stat -c %Y "$file"`
     currentTime=`date +%s`
     currentTime="$((currentTime - 10))"
     if [ "$lastModifiedTime" -lt "$currentTime" ]; then
        if [[ "$fileExtention" == *.jpeg ]] || [[ "$fileExtention" == *.jpg ]] 
        then
	  processFile "$file"
	else
	  echo `date` " do not suport file '$file'"
        fi
     else 
        echo `date` " '$file' upload in progress"
     fi

    fi
 done
}


checkForImages
