#!/bin/bash

# Change the directory and run pyhton file that will fetch latest commit
(cd /home/light/linex/CICD/CICDpipeline/; sudo pyhton latestcommit.py)

# Sleep for 3 seconds as to wait for new commti file to get generated
(sleep 3)

oldCommitId=`cat old-commit.txt`
newCommitId=`cat /home/light/linex/CICD/CICDpipeline/latest-commit.txt`

# Add if condition to match old and new commit id.
# If they dont match then do a latest pull
if [ "${oldCommitId}" != "${newCommitId}" ]; then
    echo "Pulling latest code"
    (cd /home/light/linex/CICD/CICDpipeline/; git pull)
    echo "Created latest commit file"
    `cat /home/light/linex/CICD/CICDpipeline/latest-commit.txt > old-commit.txt`
    echo "Done!!"

    # Copy latest index file to hosted folder that is html/
    (cp /home/light/linex/CICD/CICDpipelineindex.html /var/www/html/)
    
    # Reload the nginx server
    (systemctl reload nginx)

fi
