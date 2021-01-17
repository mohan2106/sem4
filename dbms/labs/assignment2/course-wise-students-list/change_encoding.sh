#!/bin/bash
FROM_ENCODING="ISO-8859-1"
TO_ENCODING="UTF-8//TRANSLIT"
#convert
CONVERT="iconv -f $FROM_ENCODING -t $TO_ENCODING"
#loop to convert multiple files
for file in '*.csv';do
        $CONVERT "$file" -o "${file}"
done    
exit 0

