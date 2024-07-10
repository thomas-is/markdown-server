import os
import sys
import markdown

from flask import Flask, abort, request, jsonify
from markdown.extensions.toc import TocExtension

app = Flask(__name__)


@app.route('/markdown/<name>', methods=['GET'])
def markdown_view(name):

    filename = f"/src/md/{name}.md"
    if not os.path.isfile(filename):
        abort(404)
    with open(filename, "r") as f:
        md_text = f.read()
        f.close()

    theme = "github-markdown"
    syntax = "one-dark"
    extensions = [
        TocExtension(toc_depth="2-6"),
        'fenced_code',
        'codehilite',
        'tables',
    ]
    html_main = markdown.markdown(md_text, extensions=extensions)

    html = f"""
<!DOCTYPE html>
<html>
<head>
<title>{name}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link rel="stylesheet" href="/css/main.css">
<link rel="stylesheet" href="/css/github/{theme}.css">
<link rel="stylesheet" href="/css/pygments/{syntax}.css">
</head>
<body>
<main class="markdown-body">{html_main}</main>
</body>
</html>
"""
    return html

