git-readme.txt
--------------
Created: 18-May-2014
Author: Daniel Mastropietro
Description: Examples of using git. All commands used should be run from a Git BASH environment.
Assumptions: Git BASH and optionally Git GUI are installed on a local machine.
Ref:
http://git-scm.com/
https://help.github.com/
https://www.atlassian.com/git/tutorials/comparing-workflows (added on 31-Oct-2017: nice view of different working scenarios with examples and useful git commands)
https://sethrobertson.github.io/GitFixUm/fixup.html (added on 24-Jul-2018: very good site about fixing up github history (e.g. when we make a commit we didn't intend to do) where the author guides the user into different solution paths depending on what the user did wrong. VERY NICE!)
[2019] https://github.com/lorenzwalthert/w-c4ds/blob/master/01-learning_resources/command_line_git.Rmd (added on 17-Feb-2019: it contains a help file for Git --similar to the help files I write to myself, but this one is in Markdown! It was referenced in an article I saw in R-Bloggers about how to become a better programmer (https://www.r-bloggers.com/mastering-your-day-as-a-programmer-3/))
[2019] https://towardsdatascience.com/10-git-commands-you-should-know-df54bea1595c (added on 21-Mar-2019: it contains a non-trivial list of useful git commands. Good to have it as reference. It might require SIGN UP though...)
[2019] https://zoom.us/recording/play/f9nAjPUhnIMBRwjDFk6OH7PXWg0Cb0ena17cqEN6bgidewC67zC6fbfK-IzDFKfY?continueMode=true (added on 30-Oct-2019: 1-hour webinar by Git Tower titled "17 ways to undo things in Git" --more info in e-mail by Git Tower Client saved under "Courses..." folder in Outlook dated 07-Oct-2019 and 30-Oct-2019. I watched the webinar and I found it very clear and useful to have as reference. Ex: undo a reset --hard, undo a deleted branch, git rebase (the Swiss Army Knife!!), etc. Ref: www.git-tower.com/learn/git/first-aid-kit )


======================================================================
INDEX

Basic stuff (starts at item 0)
-----------
0.- Main daily commands
1.- Initialize bare server repository (to where we can 'push')
2.- Clone a server repository
3.- Commit changes locally
4.- Update a bare server repository (PUSH)
5.- Fetch changes from remote server repository and resolve conflicts (FETCH)
6.- Merge MASTER with a TEST branch
7.- Revert to a previous version of the PROJECT (i.e. an earlier commit)
8.- Revert to a previous version of a FILE
9.- See the files that are TRACKED (i.e. are in the working tree)
10.- See ALL the working tree (including branches that are out of reach)
11.- See the historical differences of a single file
12.- See how HEAD changed with time

Additional stuff (starts at item 100)
----------------
100.- Change commit messages in past commits
101.- Stash current work and work on something else
102.- Remove an earlier commit
103.- About code lines removed by other developers
104.- SSH keys
======================================================================


********************************************* Basic stuff *******************************************
0.- Main daily commands
-----------------------
The following commands are listed in the order in which thye are normally run from a Git Bash console:

1) WHEN WE HAVE MADE CHANGES THAT WE WANT TO PUBLISH TO THE REMOTE REPOSITORY
(optional)
git pull --> optionally run this to update the local repository with any changes done in the remote server

(always)
git status --> lists files that are part of the commit to be done (green means the file will be included, red means it will NOT be included)
git add -u --> adds the modified files to the list of files to be committed (turns red files to green)
git add <files> --> adds new files not yet tracked to be tracked and will therefore be part of the commit
git commit --> commits the local changes in the LOCAL repository (it opens a vim editor where one writes a short line describing the commit)

(if 'git pull' had not been run as shown above, the following PUSH may be rejected by the remote repository)
git push --> pushes the local changes to the REMOTE repository (if this is rejected, we first need to PULL the data from the remote repository --see item(2) next)

2) WHEN WE WANT TO UPDATE OUR LOCAL REPOSITORY WITH THE CURRENT STATUS OF THE REMOTE REPOSITORY
git pull --> reads the status of the remote repository and updates the local repository (with automatic merge if needed)
(if we are unsure about whether we would like to merge the changes in the remote repository with the local changes, we can see what would be updated using 'git fetch' and, if we are comfortable with the changes, run 'git merge FETCH_HEAD')

If there are conflicts during the PULL process, we need to resolve them by editing the conflicted files and resolving the places enclosed between symbols like "<<<<< HEAD" and ">>>>> efc314" or similar.
Once conflicts have been resolved, we can commit the changes to the local repository (it's automatically labeled as a MERGE commit) and continue working.


1.- Initialize bare server repository (to where we can 'push')
--------------------------------------------------------------
Ref: http://git-scm.com/book/en/Git-on-the-Server-Setting-Up-the-Server
1) Initialize BARE repository at server
	# e.g. at directory in Dropbox (if another server is not available!)
	mkdir git
	cd git
	git init --bare CMP.git
	## RESULT: A bare git repository called CMP.git for project CMP is created in the server (server = Dropbox). Its size is ~ 15 KB.

	Using Git drop down menu in Explorer: (i) create the directory CMP.git, (ii) right click on it and select "Git Create repository here...", (iii) check the "Bare" box (which is checked by default if the directory ends in .git!)

2) Initialize local git repository
	# On local directory (with an already working project called CMP)
	cd CMP
	git init
	## RESULT: A git repository was created in local machine (we will see a .git hidden directory)

	Using Git drop down menu in Explorer: (i) cd to CMP.git, (ii) right click on an empty space and select "Git init here...".

3) Add list of ignored files (i.e. files to be excluded from tracking)
	In local repository (ONLY), open file .git/info/exclude to add files or directories to exclude from tracking.
	I added a new line 'data/' in order to exclude the data directory (files possibly too large).
	
	Another option of ignoring files (and directories) is to create a .gitignore file at the root directory of the project where exclusions are listed. HOWEVER note that:
	- files that were ALREADY TRACKED before adding their exclusion in the .gitignore file are not affected. I.e. they are still going to be tracked. Only non-tracked files and new files matching the ignore pattern are affected. To stop tracking a file that is already tracked use `git rm --cached` (Ref: https://git-scm.com/docs/gitignore)
	- On the contrary, files that WERE IGNORED ALREADY before a change in .gitignore that stops ignoring them are NOT tracked automatically. We need to FORCE their addition to the tree by using `git add -f <files>`.

	Note that if one of the ignore pattern is to ignore all hidden files (by adding a .* entry), in principle we should NOT ignore the .gitignore file itself (if we want all team members to ignore the same files). In order to do this, add the following line to .gitignore:
	!.gitignore

	The reference below also explains how to make .gitignore ignore files that are not new (where "not new" means that these are files that are currently tracked, as opposed to files already existing prior to the creation of the .gitignore file).
	Ref: http://stackoverflow.com/questions/8021441/gitignore-hidden-dot-directories

	WHERE SHOULD WE PLACE AN IGNORE PATTERN?
	The logic is as follows:
	- Use .gitignore to list files to ignore that should be shared with the team (i.e. that should be tracked)
	- Use info/exclude to list files to ignore locally (i.e. that should NOT be tracked)
	More info at git-ignore documentation:	
	file:///C:/Program%20Files%20%28x86%29/Git/doc/git/html/gitignore.html

4) Add files and first commit
	# On local project directory
	cd CMP
	git add .
	git commit
	## Add the line: "Project created"
	## RESULT: All files in the CMP directory except those excluded in .git/info/exclude are committed.

5) Define the remote repository
	# On local CMP repository
	git remote add origin /e/Dropbox/Daniel/Projects/Lundin/git/CMP.git
	# List remotes and their path
	git remote -v
	## RESULT: remote directory containing the server repository was added to the local git repository
	
	HOW TO UPDATE A REPOSITORY ADDRESS:
	If at some point the location of the remote repository has changed, we can update the remote address by one of the following ways:
	- running 'git remote set-url <name> <new-path>' (where <name> is the name of the remote to change (typically 'origin')
	(note that even if the path is not an URL (but a directory path instead) we still use the option set-url)
	- updating the 'url' property value in the .git/config file to the new path.

6) Push changes in local repository to server
	# On local git CMP repository
	git push --set-upstream origin master
	## RESULT: the contents of the local CMP directory where pushed (copied) to the remote bare server repository (identified as origin)
	## and by using the --set-upstream option the local 'master' branch is set to track the server 'master' branch.

	NOTE: (2015/05/27) using 'git push' alone could do the same trick as long as we work with tracking branches (i.e. for the branch we are working on now there is a remote branch that the local version is linked to and information about how far ahead or behind the remote branch is from the local branch is reported e.g. in EGit (git for Eclipse)). But BEFORE USING THIS CHECK OUT THE CONFIGURATION FOR THE push.default OPTION IN THE CONFIGURATION FILE.
	To do this:
	# List the current config settings
	git config --list
	# Change the push.default option to a suitable option, in this case 'upstream' which is what works for me
	git config push.default upstream
	
	Notes:
	- 'upstream' means that by default the current branch is pushed to the tracked branch, REGARDLESS of whether the local and remote branch names are the same. If we want the default action to push to remote branches having the SAME NAME, use the 'simple' option which is the default starting Git 2.0.
	- we can add an upstream (tracking) reference (i.e. refer a branch in the remote repository to be tracked to the local branch) by using the -u option as in 'git push -u origin master'. This is similar to using the 'git checkout --track <remote-branch>' command explained below to make a copy of a remote branch while tracking it, but in the opposite direction: i.e. we are indicating git to create *in the remote repository* a branch that is set as tracking branch to the local branch we are pushing (in this case the remote branch 'origin/master' will be created and will track the local branch 'master').
	
	Ref: man-page for git-config, man-page for git-push.


2.- Clone a server repository
-----------------------------
# On the local directory where we want to create the clone (e.g. E:\Daniel\Projects\Lundin) run:
git clone /e/Dropbox/Daniel/Projects/Lundin/git/CMP.git
# and this will create the directory called CMP inside the working directory.


3.- Commit changes locally
--------------------------
1) Go to the local repository where I have been working
	cd /e/Daniel/Projects/Lundin/CMP

2) Add the modified files to the list of changes to be committed
	git add --update :/
	## Note: ':/' may not be necessary
	## or equivalently:
	git add -u

3) Commit the changes
	git commit
	## Add a less-than-50-character line at the top, leave next line blank and describe the changes related to the commit


4.- Update a bare server repository (PUSH)
------------------------------------------
1) Push the changes to the remote server repository (this is only possible when the remote repository is BARE!! i.e. contains only a .git directory --otherwise, the changes must be PULLed from the repository)
	# On the local repository
	git push origin master
	## RESULT: The remote server repository has been updated with the changes performed locally
	
	NOTE: This step only works when the push results in a fast-forward (i.e. the new version --in the master local branch-- is a *direct descendent* of the remote master version, thus allowing for a fast-forward). If this is not the case, we would first need to PULL the changes from the remote repository and merge with the local changes.
	
	HOWEVER, a very common case when this step does not work (and we would like it to work) is when we do an amendment to a previous commit (via 'git commit --amend'), for example when we just want to forgot a comment that we want to add to the recently committed changes. When this is the case and **when we are the only users of the repository or we know that nobody is using the repository**, we can do a 'git push --force' in order to force the PUSH even if it is NOT a fast-forward. This however produces a loss of history!
	Otherwise, we would need to proceed as before, firt pull the changes from the remote repository (note that in the meanwhile somebody may have been working on it!), merge and then push.
	
	Example of a forced push:
	git push --force origin master
	
	More info about this issue and fast-forwarding at:
	http://git-scm.com/docs/git-push ("Note about fast-forwards") --> the very last paragraph of this section describes exactly this issue!
	http://stackoverflow.com/questions/253055/how-do-i-push-amended-commit-to-the-remote-git-repo (the top answer gives an example of what steps to follow if we really want to pull, merge and then push --even when it is an amendment)
	http://stackoverflow.com/questions/6897600/git-push-failed-non-fast-forward-updates-were-rejected (gives an example of pulling, merging and pushing)
	

2) Add the same exclusions used in the local repository to the info/exclude file in the server repository
	This is done so that any user cloning the server repository will get those exclusions too!
	Note that the info/exclude file is NOT pushed from the local repository to the server repository with git-push above...
	## RESULT: Exclusions are added to the server repository


5.- Fetch changes from remote server repository and resolve conflicts (FETCH)
-----------------------------------------------------------------------------
1) Fetch or pull the changes from the remote server repository
	# On server directory
	# (Make sure that there are no changes done locally in this production directory that should first be committed
	# using 'git add -u :/' and 'git commit'-- or discarded --using 'git checkout -- <files>'
	git fetch						# equivalent to: git fetch origin (this step ONLY retrieves the current status of the remote server,
									# it does NOT download any code!)
	git merge FETCH_HEAD			# This means: "merge" the HEAD FETCHed from the remote repository with the local branch
	# or equivalently (I think)
	git pull						# This is actually fetch + merge
	
	# or we could do: (2017/10/31)
	git pull --rebase origin master	# Ref: https://www.atlassian.com/git/tutorials/comparing-workflows
	which avoids the generation of an intermediate MERGE commit that simply states that merge conflicts were resolved.

2) Conflict may appear when doing the "git merge FETCH_HEAD". In order to resolve them we can use a merge tool by running:
	git mergetool --tool=tortoisemerge
	
	which uses the Tortoise merge tool to resolve the conflicts in one file at a time presenting conflicts. With this 	tool we can easily decide which version of the file to accept (CTRL+F10 to accept the local version, CTRL+F9 to accept the remote version).

	Note that if the file with conflicts is new and didn't exist in a "base" version, the Tortoise merge tool cannot handle it and we need to accept/reject changes manually by editing the <<<< HEAD and >>>> FETCH_HEAD sections.
	Ref: http://stackoverflow.com/questions/16865937/what-should-i-do-when-i-get-tortoisemerge-cannot-be-used-without-a-base
	
	There are many tools for merging. They are listed by doing:
	git mergetool --tool-help
	
	Another good reference to better understand fetching and merging and its relationships to just pulling is:
	http://longair.net/blog/2009/04/16/git-fetch-and-merge/
	see also: https://www.atlassian.com/git/tutorials/comparing-workflows with useful examples and commands.
	
	NOTE: If we want to abort the merge because e.g. the conflicts appeared after we requested a merge with an incorrect commit, we can issue the following command to keep the original base branch from which the merge is requested:
	git reset --hard HEAD
	Ref: http://stackoverflow.com/questions/101752/i-ran-into-a-merge-conflict-how-can-i-abort-the-merge

	NOTE 2: If we don't have a merge tool available (because we are e.g. working in a command-only git interface, we can resolve the conflicts by manually editing the files and keeping the part that we want to keep (look for things like "<<<< HEAD", etc. to see where the conflicts are).
	Once the conflict is resolved, we simply add the files with the resolved conflict again to git, as if we were doing a new commit, and then do a:
	git rebase --continue (which I think makes sense when we had done 'git pull --rebase' when pulling the changes --see above).
	
	NOTE 3: When we open the merge tool, at least three copies of the file with conflict are created:
	- local copy
	- remote copy
	- base copy (what is this??)
	Once we finish resolving conflicts and we exit the merge tool answering "y" to the question "Was the conflict resolved?", all those files disappear and the file generated by merge when attempting to auto-merge is named with the .orig extension (e.g. functionsdb.php.orig).
	
3) Run show-ref to make sure that the HEAD in the Production directory points to the same state as the local repository where changes have been made.
	git show-ref --head
	
4) Create a remote branch for a newly created local branch
	Simply push the newly created local branch.
	Use the -u or --set-upstream option of git push to create a remote branch (with the same name as the local branch) that tracks the local branch. See example below.
	We can then use the git branch --set-upstream-to= or -u option to change the tracked remote branch for a local branch if needed.

	Ex: if the local branch is called 'test' and we have checked it out (perhaps this checkout step is not necessary), use:
	git push origin test		# --> creates the remote branch 'origin/test'
	git push -u origin test 	# --> creates the remote branch 'origin/test' that tracks the local branch 'test'
	git branch --set-upstream-to=origin/testdaniel test		# --> sets the upstream track of branch 'test' to 'origin/testdaniel'

5) Create a local branch of a remote branch
	If the remote server has a new branch the git-fetch command just informs us about it, but NO BRANCH IS CREATED LOCALLY.
	
	If we want to work on a local copy of that branch, we should track it with the following command:
	git checkout --track <remote-branch>
	Ex:
	git fetch origin	# --> suppose that in the answer of this command we see there is a new remote branch 'test'
	git checkout --track origin/test
	
	The above git-checkout --track is equivalent to using the -b option, which however allows to set a different name to the remote branch.
	Ex:
	git checkout -b mytest origin/test
	# -b means: "new branch"
	
	Now the remote test branch is tracked locally by the mytest branch (or by the test branch in the first use of git-branch), which means that whenever I am working on the local test branch (because I have done a 'checkout test') and I do a git-pull (N.B. PULL not FETCH), Git will automatically know to pull the data from the remote origin/test branch.
	
	This is called "Tracking (remote) Branches".
	
	We can see what remote branches are tracked locally (and by which local branch) by running:
	git branch -vv		# double verbose (the remote tracked branch will appear enclosed in [] after the version reference code)
	git branch -avv		# add the list of the remote branches to the above output
	
	Ref: http://git-scm.com/book/en/v2/Git-Branching-Remote-Branches

6) Update any branch with the remote version
	If we are working on a branch (e.g. test) and we want to update another branch (e.g. master) we need to:
	a) checkout the 'master' branch	(git checkout master)
	b) pull from origin/master (git pull) (as long as master is tracking origin/master)
	NOTE: If we want to take THEIR version (i.e. the remote version, without dealing with conflicts) we should do:
		git pull -s recursive -X theirs [origin/master]
	EQUIVALENT TO:
		git pull --strategy-option theirs [origin/master]
	OR, if a pull has already been done and conflicts were found, we can resolve ALL the conflicts taking their version by doing:
		git checkout --theirs .
		git add .
	OR, if we want to resolve conflicts for particular files:
		git checkout --theirs path/to/file		(wildcards are accepted)
	Note that the opposite of --theirs is --ours.
	Ref: https://stackoverflow.com/questions/10697463/resolve-git-merge-conflicts-in-favor-of-their-changes-during-a-pull

	We can then go back to the original branch we were working on (e.g. 'test') with a new git checkout command.

7) Update a remote branch with a local version
	Use git push as follows to allow for different branch names in local and remote (e.g. because of branch tracking with different local and remote names):
	git push origin <local-branch>:<remote-branch>
	
	Ex:
	git push origin test:danieltest

	Ref: git-push documentation
	

6.- Merge MASTER with a TEST branch
-----------------------------------
Ref: http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging
After working on a test branch (assumed called TEST) and having tested that everything works fine and having committed the changes, we are ready to merge with the MASTER branch. To do so:
1) Checkout the MASTER branch
	git checkout master
2) Merge with the TEST branch
	git merge test
3) Delete the TEST branch (optional)
	git branch -d test

NOTE 1: Doing the above merge may not be directly possible because there may be some conflicts, which should first need to be resolved. To see how to do this, see the above reference page.

NOTE 2: This is not the same as REPOSITIONING (which is what we may be after), e.g. reposition the master branch to the current test branch after we have tested that the test branch works fine. To do so use 'git branch -f master test' (see below "REPOSITION").

NOTE 3: To delete a remote branch called test, use git push as follows:
	git push origin --delete test
Ref: http://www.gitguys.com/topics/adding-and-removing-remote-branches/


7.- Revert to a previous version of the PROJECT (i.e. an earlier commit)
-----------------------------------------------------------------------
Ref: http://stackoverflow.com/questions/4114095/revert-to-previous-git-commit
1) If I want to go to the previous from a previous commit, use git checkout <commit>.

2) If I just want to go back to a previous commit and LOSE local changes use 'git reset --hard'.
	# This will destroy any local modifications.
	# Don't do it if you have uncommitted work you want to keep.
	git reset --hard HEAD
	
	(be careful because it seems that this may prevent me from pushing later on IF I had previously pushed my commits before the hard reset... For more info, see comments to second answer at the above reference)
	
	NOTE: To see where the HEAD is positioned use 'git show-ref --head'.

	After doing this operation the files at the local copy of the repository will have been updated to the repositories version given by the HEAD position, WHENEVER there was a change done in the file w.r.t. the HEAD version. Note however that the modification date of any modified file will be the time of execution of the git-reset command! (this is a little unexpected but the reason is that the dates of the files are set to the dates when the information from the repository is fetched)

	Apparently this may also be done with 'git rebase' with the --onto option...? --> NO! (see UPDATE on next line)
	UPDATE: (2015/09/01) After reading the git-rebase documentation, ***the answer to the above question is NO**. The rebase --onto option is useful to make a branch *look as if* it was forked from a point that is different from the current fork point. The "look as if" means that all the information regarding differences between commits is updated based on the new forking point!
	See:
	http://git-scm.com/docs/git-rebase
	http://stackoverflow.com/questions/5471174/git-move-branch-pointer-to-different-commit

	See also the following link for a very good explanation of what git-reset means and its difference with git-revert (which is used to remove an earlier commit --referenced at item 102 below as well):
	https://www.atlassian.com/git/tutorials/undoing-changes
	
	***	REPOSITION (or "rebase" in my language) A BRANCH (very common task when we want to make master point to the currently working branch, e.g. daniel) ***
	If I just need to reposition a branch (e.g. master branch) to a another commit, use git branch -f (e.g. git branch -f master test) (see also item (4) below).
	
	UPDATE-2019/10/30: NOTE however that git-rebase is a VERY POWERFUL command in so much as it is called the Swiss Army Knife command (ref: webinar by Git Tower referenced at the top of this file delivered on 30-Oct-2019).

3) If I want to keep the history of the changes, see git-revert manpage (http://schacon.github.io/git/git-revert.html) or git-checkout.

4) If we just need to move a branch to a different commit...
	Use:
	git branch -f <branch> <new-tip-commit>
	
	where <new-tip-commit> can be a branch name or the hashcode referencing the branch.
	
	Ex:
	git branch -f master daniel

	Notes:
	- option -f means "force". From the documentation:
		"-f: Reset <branchname> to <startpoint> if <branchname> exists already. Without -f git branch refuses to change an existing branch."
	- for this command to be successful we MUST NOT stand at the branch whose position we want to move.
	- if we ommit the <new-tip-commit> the branch tip will be moved to HEAD

	See also:
	git update-ref

	Ref: http://stackoverflow.com/questions/5471174/git-move-branch-pointer-to-different-commit


8.- Revert to a previous version of a FILE
------------------------------------------
Ref: http://stackoverflow.com/questions/215718/reset-or-revert-a-specific-file-to-a-specific-revision-using-git
ANSWER 1:
# Use git checkout
# Assuming the commit hash we want is abcde:
git checkout abcde file/to/restore
## SEE BELOW ON HOW TO CHECKOUT A FILE WITH ANOTHER NAME (so that we don't override the current version! --uses git-show)

# Note that a similar command is used to go back to the original version of a file when we are working on the current branch
# and would like to undo all the changes we did locally. The command is:
git checkout -- file/to/restore 	# This command is actually shown by the helper information available with the 'git status' command.

ANSWER 2: This also explains what BRANCHES are useful for!
# We can quickly review the changes made to a file using the diff command:
git diff <commit hash> <filename>

# Then to revert a specific file to that commit use the reset command:
# We may need to use the --hard option if we have local modifications.
git reset <commit hash> <filename>

# A good workflow for managaging work points is to use tags to cleanly mark points in our timeline.
git tag v0.4.0
# Push the tag to the remote repository
git push origin v0.4.0

# In order to delete a remote tag
# Ref: https://nathanhoad.net/how-to-delete-a-remote-git-tag/
git tag -d v0.4.0
git push origin :refs/tags/v0.4.0

# Check the commit that a tag points to
# Ref: https://stackoverflow.com/questions/1862423/how-to-tell-which-commit-a-tag-points-to-in-git
git show-ref --tags

# In order to work into a new line of development from an earlier commit
# (i.e. suppose we started working on something new which we thought would be easy
# and then realize it is not easy... in that case we want to move all our work we have done
# so far on that new development to a new branch, WITHOUT changing the status of the branch I have
# been working on so far...), diverge a branch from that previous point in time.
# To do this, use the handy checkout command:
git checkout <commit hash>
git checkout -b <new branch name>
Ref: https://stackoverflow.com/questions/2569459/git-create-a-branch-from-unstaged-uncommitted-changes-on-master

# We can then rebase that against our mainline (master branch) when we are ready to merge those changes done in <my branch>:
git checkout <my branch>
git rebase master
git checkout master
git merge <my branch>
## This last merge step can result in a fast-forward if <my branch> is ahead of master with a direct path.
## After the last merge step we are still working at the master branch.

# To checkout an older version of a file with ANOTHER NAME
# Use git-show
git show 21b0fbf66185a49473e4f8195fed3c2542275ef2:path/to/file/04-DAT-TransformacionVariables.sas > path/to/file/04-DAT-TransformacionVariables_old.sas
Ref: https://stackoverflow.com/questions/888414/git-checkout-older-revision-of-a-file-under-a-new-name

# To find a commit
# Use git-show and add the --stat option to avoid showing the whole commit diff information
# Ref: https://stackoverflow.com/questions/14167335/find-commit-by-hash-sha-in-git
git show dea48e8961 --stat

9.- See the files that are TRACKED (i.e. are in the working tree)
-----------------------------------------------------------------
Ref: http://stackoverflow.com/questions/15606955/how-can-i-make-git-show-a-list-of-the-files-that-are-being-tracked
# Option 1: simple and quick
git ls-files

# Option 2: more complicated but with more flexibility and information
git ls-tree -r master --name-only
## -r: recurse on directories in the tree
## --name-only: show just the name of the file, and no strange codes before them.

If we need to stop tracking files, use rm --cached
Ex:
git rm --cached <files>
# or to do it recursively on the files of a directory
git rm --cached -r <dir>


10.- See ALL the working tree (including branches that are out of reach)
------------------------------------------------------------------------
Ref: https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History (found it here, although it is not the main topic)
Use gitk --all --date-order.
This should also show branches that are normally not seen from our current branch (such as a diverted remote branch that is tracked to the local branch --e.g. remotes/origin/daniel that is tracked to the local branch 'daniel').

The git command to see the commit history is git-log.
Ex:
git log --pretty --graph
(this shows the lines on the left with the different commit paths and merges as we see it in gitk)


11.- See the historical differences of a single file
----------------------------------------------------
Ref: https://stackoverflow.com/questions/278192/view-the-change-history-of-a-file-using-git-versioning
Use:
git log -p --follow -- file
# --follow follows the file through its renames
(note that, as suggested by the first answer on the above link, 'gitk --follow file' does NOT work, i.e. it does NOT show the file any more if the file was renamed in its history)

Understanding the output from git-log or git-diff: (very clear answers given)
https://stackoverflow.com/questions/2529441/how-to-read-the-output-from-git-diff
********************************************* Basic stuff *******************************************

12.- See how HEAD changed with time
-----------------------------------
Use 'git reflog'.

This can be useful to e.g. undo a wrong change such as a 'git reset --hard' (i.e. discard commits that we didn't want to) or deleted a branch we didn't want to delete.

Ref: Webinar on 30-Oct-2019 by Git Tower referenced at the top of this file.



******************************************* Additional stuff ****************************************
100.- Change commit messages in past commits
--------------------------------------------
Ref: https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History
This is part of re-writing history and it can be achieved by using the git-rebase command in interactive mode (-i).
For more info, see reference above which is quite well explained.
NOTE: (2015/09/22) Today I actually tested the instructions in section "Changing Multiple Commit Messages" on the IOLS project and it worked quite well! And it is actually fairly easy, although it may look cryptic at some point.
As a recall, I ran:
	git rebase -i HEAD~3
(-i enters the interactive mode)
	
and then I edited the file that is opened accordingly to what commit I want to change.
Then I followed the following instructions (which appear further down in the aforementioned section):
<<
You need to edit the script so that it stops at the commit you want to edit. To do so, change the word ‘pick’ to the word ‘edit’ for each of the commits you want the script to stop after. For example, to modify only the third commit message, you change the file to look like this:
edit f7f3f6d changed my name a bit
pick 310154e updated README formatting and added blame
pick a5f4a0d added cat-file
>>

Recall that the commits are listed in reverse order w.r.t. how we see them in gitk, that is the oldest commit appears first.
Also note that the command "pick" means: don't change anything about the commit.
Change "pick" to "reword" in order to change the wording of a commit. If we need to amend it, change it to "edit".

UPDATE-2019/10/30: See examples in the webinar by Git Tower mentioned at the top of this file delivered on 30-Oct-2019.

101.- Stash current work and work on something else
---------------------------------------------------
Ref: http://www.gitguys.com/topics/temporarily-stashing-your-work/
Use git-stash (stash means "almacenar") to save the current state of the project in a safe place to come back later.

Ex:
	git stash
equivalent to:
	git stash push

This tool may be helpful if we are in the middle of something and do not want to commit it because we are still working on it, but we need to go and work on something else before finishing.

To restore the stashed work (called "WIP" by Git --Work In Progress) we can simply run:
	git stash pop
which is the reverse operation to 'git stash push'. Note that the stash state is dropped from the stash list.
which is equivalent to:
	git stash stash@{0}
where 0 is the revision number (the latest stash is 0, the previous one is 1, etc.).

Note that once (Apr-2016) I had difficulties going back to stashed work as the head didn't seem to go back to the original stash, but rather a new branch with changes appeared, even when I ran 'git stash apply' (although 'git stash apply' is the same as 'git stash pop' but without dropping the stash state from the stash list. The problem was not solved even when creating a branch for the stashed work with 'git stash branch'... I am a little lost here.

To see the list of stashed work use:
	git stash list
To see the differences between the latest stash and the current working copy use:
	git stash show

Ref:
https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing
https://git-scm.com/docs/git-stash

102.- Remove an earlier commit
------------------------------
Ref: https://www.atlassian.com/git/tutorials/undoing-changes
Ref: http://sethrobertson.github.io/GitFixUm/fixup.html (quite nice reference which is very intuitive)
Use git-revert (which is different from git-reset!) to remove a commit (usually a faulty commit) from history.

Here is what the first link (undoing-changes) says under section "git reset":
<<
If git revert is a "safe" way to undo changes, you can think of git reset as the dangerous method. When you undo with git reset (and the commits are no longer referenced by any ref or the reflog), there is no way to retrieve the original copy --it is a permanent undo
...
Whereas reverting is designed to safely undo a public commit, **git reset** is designed to **undo local changes**. 
>>

NOTES:
- The first link above (undoing-changes) has a VERY good explanation (also graphically) of what the implications of this are and what the difference with git-reset is.
- The second link above (fixup.html) seems also quite useful to know how to proceed based on our situation.
- At one point (when testing the no-fast-forward merge option in IOLS project) I wanted to remove all the commits that I used to test that functionality (since it was done on dummy files). In order to achieve this I checked out the daniel branch (an earlier commit) and then deleted the test branch which I had created to test the functionality by running 'git branch -D test'. It seems that this made those commits (which are in the future w.r.t. daniel) disappear.

103.- About code lines removed by other developers
--------------------------------------------------
While trying to understand how to make git-merge warn me when a merge makes a line in my code disappear (because the other developer deleted that line), I came accross the following discussion in stackoverflow: http://stackoverflow.com/questions/4404444/how-do-i-blame-a-deleted-line.
In fact, I think conceptually such type of merge is NOT a conflict and therefore it should be done silently without any conflict complaint (in fact, the non-fast-forwarding merge option suggested to me by Yi Cheng in EARL-2015 did not work). Therefore, what I am looking for perhaps is a tool that tells me when a given line was deleted from my code, and this is what the above link discusses.

104.- SSH keys
--------------
In order to work with a web repository (e.g. GitHub) we usually need an SSH key. For more information see OneNote -> Git & GitHub -> GitHub HowTo.
Note that SSH keys are generated by running:
	ssh-keygen -t rsa -C "mastropi@uwalumni.com"
which generates two files id_rsa (private key) and id_rsa.pub (public key) in ~/.ssh, where ~ is the home directory in the Linux-equivalent bash (e.g. C:\Users\lundinmatlab).
******************************************* Additional stuff ****************************************
