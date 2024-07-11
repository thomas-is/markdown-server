import os
import markdown
from flask import Flask, abort

from markdown.extensions.toc import TocExtension

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index() :
    md_dir = "/src/md"
    md_files = []
    entries = os.listdir(md_dir)
    for entry in entries:
        if not os.path.isfile(f"{md_dir}/{entry}"):
            continue
        md_files.append(entry)
    html_nav = "<nav>\n"
    for file in sorted(md_files):
        file = os.path.splitext(file)[0]
        html_nav += f"<a href=\"/markdown/{file}\">{file}</a>\n"
    html_nav += "</nav>"

    name = "index"
    html = f"""
<!DOCTYPE html>
<html>
<head>
    <title>{name}</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/main.css">
</head>
<body>
    <main>{html_nav}</main>
</body>
</html>
"""
    return html

@app.route('/markdown/<name>', methods=['GET'])
def markdown_view(name):

    filename = f"/src/md/{name}.md"

    if not os.path.isfile(filename):
        abort(404)

    with open(filename, "r", encoding="utf-8") as f:
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
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/github/{theme}.css">
    <link rel="stylesheet" href="/css/pygments/{syntax}.css">
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>
<body>
    <main class="markdown-body">{html_main}</main>
</body>
</html>
"""
    return html

if __name__ == '__main__':
    app.run(debug=True)

