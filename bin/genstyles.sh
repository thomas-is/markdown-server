#!/bin/sh

base=$( realpath $( dirname $0 ) )

dst=/src/html/css/github
mkdir -p $dst
url="https://raw.githubusercontent.com/sindresorhus/github-markdown-css/main"
github_css=$( cat << EOF
github-markdown.css
github-markdown-dark.css
github-markdown-light.css
EOF
)
for css in $github_css; do
  echo "$dst/$css"
  curl -s -L $url/$css -o $dst/$css
done

dst=/src/html/css/pygments
mkdir -p $dst
styles=$( /venv/bin/pygmentize -L style | grep ^\* | awk '{ print $2 }' | cut -f1 -d":" )
for style in $styles; do
  echo "$dst/$style.css"
  /venv/bin/pygmentize -S $style -f html > $dst/$style.css
done

