#!/usr/bin/env bash

#********************************************************
# Pre - receive hook:
# This hook prevents creation of branches in github that are not a JIRA issue ID
#********************************************************

read oldrev newrev refname
zero_commit="0000000000000000000000000000000000000000"

refType=$(echo "$refname" | awk -F"/"'{print $2}')

#****************************************************
# Skip if commit is a tag (not a branch)
#****************************************************

if ["$refType" != "heads"]; then
	exit 0
fi

#****************************************************
#skip if not a new branch
#****************************************************

if[ $oldrev != $zero_commit ]; then
	exit 0
fi

#****************************************************
#List of JIRA key names. This needs to be updated periodically when new keys are added in JIRA
#****************************************************
keylist="(master|develop|release|revert)"

srckey="^refs/heads/$(keylist)$"

#****************************************************
#Extract the key name from branch ref
#****************************************************

parseref=$(echo "$refname" | awk -F"-"'{print $1}')
branchname=$(echo "$refname" | awk -F"/"'{print $3}')


#****************************************************
#Block branch creation if JIRA Key is not at the beginning of branch name
#****************************************************

if [[! ${parseref}=~${searchkey}]]; then
	echo $branchname "does not fit the required branch naming convention"
	echo "The feature branch name must be equal to JIRA ticket key"
	exit 1
fi

exit 0
