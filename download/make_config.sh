#!/bin/sh
#$ -S /bin/sh

cd /scratch/alpine/jinamo@xsede.org/
curl --location --fail https://service.azul.data.humancellatlas.org/manifest/files/eyJjYXRhbG9nIjogImRjcDMxIiwgImZvcm1hdCI6ICJjdXJsIiwgIm1hbmlmZXN0X2hhc2giOiAiODVkM2M0NDAtYzU1Ni01OGY2LWEwMTctZGE5OTFiZGMyNTJhIiwgInNvdXJjZV9oYXNoIjogImRmY2Q3N2E1LTUxNzMtNTMzOC05ZDE2LTA5MWJiMDQzZjE0NyJ9 > urls.txt

COMMON_OPTIONS="--create-dirs
--compressed
--location
--globoff
--fail
--fail-early
--continue-at -
--retry 2
--retry-delay 10
--write-out \"Downloading to: %{filename_effective}\n\n\""

# Initialize counter
counter=1

# Read urls.txt line by line and get url/output pairs
while IFS= read -r line; do
    if [[ $line == url=* ]]; then
        url=$line
    elif [[ $line == output=* ]]; then
        output=$line

        # Generate configuration file
        echo "$COMMON_OPTIONS" > "config${counter}.txt"
        echo "$url" >> "config${counter}.txt"
        echo "$output" >> "config${counter}.txt"

        # Increment counter
        ((counter++))
    fi
done < urls.txt

ls config*.txt > config_list.txt
