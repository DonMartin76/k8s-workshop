#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <file.template>"
    echo "  This script will replace environment variables inside the source file and"
    echo "  output it to a file with the same name, but without the last suffix. Typically"
    echo "  the source files end with *.yml.template, the target file will be *.yml."
    echo "WARNING: Handle with care."
    exit 1
fi

sourceFile=$1
targetFile=${sourceFile%.*}

echo "Templating ${sourceFile} to ${targetFile}..."

perl -pe 's;(\\*)(\$([a-zA-Z_][a-zA-Z_0-9]*)|\$\{([a-zA-Z_][a-zA-Z_0-9]*)\})?;substr($1,0,int(length($1)/2)).($2&&length($1)%2?$2:$ENV{$3||$4});eg' $sourceFile > $targetFile
