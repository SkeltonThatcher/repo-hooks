Useful repo hooks for Git
=========================

## post-checkout.debug

Example `post-checkout` hook that simply diagnoses the current operation.

### Output

Checkout existing branch:

	$ git checkout master
	Checking out files: 100% (189/189), done.
	Switched to branch 'master'
	Your branch is up-to-date with 'origin/master'.

	post-checkout hook

	Checkout type: branch
	    prev HEAD: bugfix-318
	     new HEAD: master

Checkout new branch:

	$ git checkout -b release-34
	Switched to a new branch 'release-34'

	post-checkout hook

	Checkout type: branch
	    prev HEAD: master
	     new HEAD: release-34


### Note on multiple branches

The `git name-rev` operation lists only the first branch name matching the rev. If multiple branches point to the same rev, slightly odd behaviour may result. #YMMV

For example, say we have two branches (*master*, *bugfix-492*) pointing to rev *1824f6*:

	$ git log --graph --decorate
	* commit 1824f6cc45e8b958a5b85daede277ae0062653fd (HEAD, origin/master, master, bugfix-492)

If we do `git checkout master` we get surprising branch names from the post-checkout script:

	$ git checkout master
	Already on 'master'
	Your branch is up-to-date with 'origin/master'.

	post-checkout hook

	Previous: New: Checkout type: branch
	    prev HEAD: bugfix-492
	     new HEAD: bugfix-492
	               ^^^^^^^^^^ 

Why is new HEAD showing *bugfix-492* after we have switched to *master*? Because it's the 'first' branch name (alphabetically) that points to that rev. Internally, this `post-checkout` script uses `git name-rev` to get the readable name of the rev. If we delete the branch (or add commits to the branch to move the tip away from *1824f6*), we get the expected behaviour:

	$ git name-rev 1824f6cc45e8b958a5b85daede277ae0062653fd
	1824f6cc45e8b958a5b85daede277ae0062653fd bugfix-492

	$ git branch -D bugfix-492
	Deleted branch bugfix-492 (was 1824f6c).

	$ git name-rev 1824f6cc45e8b958a5b85daede277ae0062653fd
	1824f6cc45e8b958a5b85daede277ae0062653fd master


(Script originally by @givanse, from http://stackoverflow.com/questions/1011557/is-there-a-way-to-trigger-a-hook-after-a-new-branch-has-been-checked-out-in-git)


## prepare-commit-msg.JIRA-smart-commits

Example `prepare-commit-msg` hook that scans the commit message for a leading JIRA ticket ID in the form `AAA-nnnn`. Fails the commit if the JIRA ticket ID is not present at the start of the commit message.

## Examples

Commit blocked due to commit message not including a JIRA ticket ID:

	$ git commit -m "post-checkout debug script"
	Commit message does not match ^[A-Z]{3}-[0-9]{1,6}[[:space:]] : post-checkout debug script

Commit succeeds with commit message that begins with a JIRA ticket ID:

	$ git commit -m "HOK-12 - post-checkout debug script"
	[master af2dd5f] post-checkout debug script
	 1 file changed, 18 insertions(+)
	 create mode 100644 Git/post-checkout.debug

