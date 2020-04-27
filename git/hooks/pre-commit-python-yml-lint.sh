#!/bin/bash

FLAKE8_KILL="flake8"
PYCODESTYLE="pycodestyle"
PYDOCSTYLE="pydocstyle"

echo "Pre-commit: Checking staged python files for linting errors."
ERRORS_PRESENT=0
for pythonfile in $(git diff --name-only --cached | egrep '.*\.py$')
do
        echo "Linting $pythonfile"
        $FLAKE8_KILL $pythonfile || ERRORS_PRESENT=$(($ERRORS_PRESENT | $?))
        #$PYCODESTYLE $pythonfile || ERRORS_PRESENT=$(($ERRORS_PRESENT | $?))
        $PYDOCSTYLE $pythonfile || ERRORS_PRESENT=$(($ERRORS_PRESENT | $?))
done

echo "Pre-commit: Checking staged YML files for syntax errors."
for ymlfile in $(git diff --name-only --cached | egrep '.*\.ya?ml$')
do
        echo "Checking $ymlfile"
        # Found this at https://stackoverflow.com/a/20420243/299084
        ruby -ryaml -e "YAML.load(STDIN.read)" < $ymlfile
done

if [[ $ERRORS_PRESENT -gt 0 ]]
then
        # Read user input, assign stdin to keyboard
        exec < /dev/tty
        while read -p "Linter errors present in staged files.  Continue commit? (y/N)" yn;
        do
                case $yn in
                        "" ) echo "Aborting commit."; exit 1;;
                        [Nn] ) echo "Aborting commit."; exit 1;;
                        [Yy] ) break;;
                        * ) echo "Only 'y' or 'n' are valid responses." && continue;
                esac
        done
fi
echo "No issues found. Proceeding with commit."
