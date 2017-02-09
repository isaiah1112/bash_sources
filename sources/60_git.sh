### Bash Profile: Git Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have git installed

if [ -z $(which git 2> /dev/null) ]; then
	echo "git binary not found. Please install it";
	return 1;
fi

alias gitmod='git diff --cached --name-only --diff-filter=ACM';
alias gitgrep='git log -p -q -S';

function gitmerged() {
if [ -d .git ]; then
    if [ "$1" == "--help" -o "$1" == "-h" ]; then
        echo "List and delete branches in git that have been merged to master";
        echo "gitmerge [--delete]";
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

function gitup() {
if [ -d .git ]; then
    for branch in $(git branch | awk '{print $NF}'); do
        git checkout ${branch};
        git pull;
    done
else
    echo "Not a git repository";
fi
}

function repoup() {
if [ "$1" == "--help" -o "$1" == "-h" ]; then
	echo "Run git pull in all repos under $(pwd)";
else
	for dir in $(find . -maxdepth 2 -type d -name .git | cut -d '/' -f2); do
		if [ -d ${dir}/.git ]; then
			cd ${dir};
			echo "Processing ${dir}";
			git pull;
			cd ..;
		fi
	done
fi
}

function git_release_notes () {
if [ -d .git ]; then
    if [ "$1" == "--help" -o "$1" == "-h" ]; then
        echo "git_release_notes [starting_tag] [ending_tag]";
    else
        if [ -z "$1" ]; then
            last_release=$(git tag | tail -1);
        else
            last_release="$1";
        fi
        if [ -z "$2" ]; then
            this_release="";
            echo "## Release" $(git branch | grep '^*' | awk '{print $NF}');
        else
            this_release="refs/tags/$2";
            echo "## Release $2";
        fi
        git shortlog --no-merges refs/tags/$last_release..$this_release --format="* %s (%h)";
    fi
fi
}
