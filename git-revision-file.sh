#!/bin/bash
# Created: 24-Aug-2018
# Author: Daniel Mastropietro
# Goal: Access the different revisions of a file
# Description: This program runs git-log on the specified file to get the SHA codes where
# the file changed, and then runs git-show on each revision
# Note that git-log is run with the --follow options so renames of the files are also tracked.
#
# Usage:
# ./git-revision-file.sh <path-to-filename-possibly-with-spaces> [<outpath-with-NO-spaces>]
# The output path may or may not exist.
#
# Results:
# All the file revisions up to the current repository state are saved into [<outpath-with-NO-spaces>] path
# or to 'tmp' if none is specified. Each revision has the following filename form:
# <filename-possibly-with-spaces-but-with-no-extension>_<nn>_<sha>.<file-extension>
# where <nn> is the revision number (smaller number indicates older version).
#
# Example:
# ./git-revision-file.sh code/file_to_track.sas tmp-revisions-file
# If there are 3 revisions of this file, it will generate e.g. the following files inside directory tmp-revisions-file:
# file_to_track_01_b09d0d7fb806354fc59e9dd877a975f83ae1c3bd.sas
# file_to_track_02_b31362163b669b6ca462971bccc08d0aac3eff69.sas
# file_to_track_03_7a6e9a1b537a17bd301bb1df678df59c31114c64.sas
# where version 01 is the oldest one and 03 is the most recent one.
#
# References:
# https://stackoverflow.com/questions/25086777/get-all-versions-of-a-file-from-a-single-branch
#

filepath=$1
if [ $2 ]
then
	outpath=$2
else
	outpath=tmp
fi

# Create output directory if needed
if test ! -d $outpath
then
	mkdir $outpath
fi

# Extract filename and extension
# Ref:
# (how to do the trick) https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# (manual of parameter expansion) http://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html#Shell-Parameter-Expansion
filename=$(basename -- "$filepath")
extension="${filename##*.}"
filename="${filename%.*}"

# Create an array with the SHA values for each hash entry where the file was modified
mapfile -t sha_in_file_revision_history < <(git log --format="%H" --follow -- "$filepath")

# Create an array with the DATES of each commit
# Ref:
# (do the trick) https://stackoverflow.com/questions/14243380/how-to-configure-git-log-to-show-commit-date
# (manual) https://www.git-scm.com/docs/git-log
mapfile -t dates_in_file_revision_history < <(git log --format="%ci" --follow -- "$filepath")

# Create an array with the NAMES of the file in each sha entry
# (blank spaces are allowed in file names! --this is accomplished by using mapfile instead of simply assigning the result of 'git log...'
# Ref:
# (do the trick) https://stackoverflow.com/questions/13823706/capture-multiline-output-as-array-in-bash
# (manual) http://wiki.bash-hackers.org/commands/builtin/mapfile
mapfile -t filenames_in_file_revision_history < <(git log --format="" --name-only --follow -- "$filepath")

nfiles=${#filenames_in_file_revision_history[@]}

echo "Getting Git revision history for file '$filepath' (renames are tracked)"
echo
echo "Number of revisions found: $nfiles"
echo "The different versions will be stored in directory '$outpath' from earliest revision 1 to latest revision $nfiles"
echo

for ((i=0; i<$nfiles; i++)); do
	# Output filename
	let "ver = $nfiles - $i"

	# Revision variables
	sha=${sha_in_file_revision_history[$i]}
	sha_date=${dates_in_file_revision_history[$i]:0:10}			# Extract just the date which happens in the first 10 characters
	filename_in_sha=${filenames_in_file_revision_history[$i]}

	# Output filename
	outfilename=$(printf "%s_%02d_%s_%s.%s" "$filename" $ver $sha_date $sha $extension)

	# Process
	echo "Processing revision $ver (sha=$sha, filename='$filename_in_sha')"
	echo "...saved to $outfilename"
	git show $sha:"$filename_in_sha" > $outpath/"$outfilename"
done
