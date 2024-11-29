### Bash Profile: Git Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have git installed

if [ -z $(which git 2> /dev/null) ]; then
	echo "git is not installed. Not loading source.";
	exit 1;
fi

alias gdiff='diff -burN';
# ensure we always rebase on a 'git pull'
git config --global pull.rebase true

# git aliases
git config --global alias.mod 'diff --cacheed --name-only --diff-filter=ACM';
git config --global alias.grep 'log -p -q -S';
git config --global alias.s status;
git config --global alias.d diff;
git config --global alias.co checkout;
git config --global alias.br branch;
git config --global alias.last 'log -1 HEAD';
git config --global alias.cane 'commit --amend --no-edit';
git config --global alias.pr 'pull --rebase';
git config --global alias.lo 'log --oneline -n 10';

function gitmerged() {
if [ -d .git ]; then
    if [ "$1" == "--help" -o "$1" == "-h" ]; then
        echo "List and delete branches in git that have been merged to master";
        echo "USAGE: gitmerge [--delete]";
        return 0;
    elif [ "$1" == "--delete" ] ; then
        git branch -r --merged origin/master | grep -v "^.*master" | grep -v "^.*upstream" | grep -v "^.*develop" | sed s:origin/:: | xargs -n 1 git push origin --delete;
    else
        git branch -r --merged origin/master | grep -v "^.*master" | grep -v "^.*upstream" | grep -v "^.*develop" | sed s:origin/:: | xargs -n 1 echo;
    fi
else
    echo "Not a git repository";
    return 1;
fi
}

function branchup() {
	if [ "$1" == "--help" -o "$1" == "-h" ]; then
		echo "Run git pull on all branches in $(pwd)";
	else
		if [ -d .git ]; then
		    for branch in $(git branch | awk '{print $NF}'); do
		        git checkout ${branch};
		        git pull;
		    done
		else
		    echo "Not a git repository";
		fi
 fi
}

function repoup() {
	if [ "$1" == "--help" -o "$1" == "-h" ]; then
		echo "Run git pull in all repos under $(pwd)";
	else
        LNBREAK="----------------";
		for dir in $(find . -maxdepth 2 -type d -name .git | cut -d '/' -f2); do
			if [ -d ${dir}/.git ]; then
				cd ${dir};
				echo -e "${LNBREAK}\n${dir}\n${LNBREAK}";
				git pull;
				cd ..;
			fi
		done
	fi
}

function git_release_notes () {
if [ -d .git ]; then
    if [ "$1" == "--help" -o "$1" == "-h" ]; then
        echo "USAGE: git_release_notes [start_tag] [end_tag]";
    else
        if [ -z "$1" ]; then
            last_release=$(git tag | tail -1);
        else
            last_release="$1";
        fi
        if [ -z "$2" ]; then
            this_release="";
            echo "# Release" $(git branch | grep '^*' | awk '{print $NF}');
        else
            this_release="refs/tags/$2";
            echo "# Release $2";
        fi
        # The markdown links are still not working as nicely as I'd like.  Due to commits vs commit.
        git shortlog --no-merges refs/tags/${last_release}..${this_release} --format="* %s [%h]" | sed 's/      / /';
    fi
fi
}
