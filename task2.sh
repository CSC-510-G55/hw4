#!/bin/bash

cd dataset1 && grep -rl "sample" file* | xargs grep -o "CSC510" | uniq -c | awk '$1 >= 3 {print $2}' | cut -d: -f1 | xargs -I {} sh -c 'echo $(grep -o "CSC510" {} | wc -l) $(ls -l {} | awk "{print \$5, \$9}")' | sed 's/file_/filtered_/' | sort -k1,1nr -k2,2nr | cut -d' ' -f3-
