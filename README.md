A Makefile website? It's more likely than you think
===================================================

Motivation
----------

Static websites are great for performance. For most of what people want to do with their personal websites, static content is all they need. However managing raw HTML can be unwieldy, as a lot of code needs to be repeated. Templating engines solve this problem by generating HTML from data files, but usually these templates are generated when a page is accessed, which can't be done on a static website. So why not pre-generate everything?


Directory Structure
-------------------

There are three main directory trees for this website.

 - `content` contains [YAML](https://yaml.org/) files with the actual information for each page: the text, images, links, etc.
 - `templates` contains the layout files for each page. These are [Jinja](https://jinja.palletsprojects.com/) templates that are populated with the variables stored in the `content` directory.
 - `out` contains the generated website files. These are generated using the Makefile and ignored by git.

For a page to exist, it must have a layout file (and an optional content file) with the same name in the same subdirectory of each tree. This will generate an output HTML file with the corresponding name and subdirectory in the `out` directory.


Build System
------------

### Make

[Make](https://www.gnu.org/software/make/) is an incremental build system, which means that it will only re-build an output file if the input files it was created from have changed. In this case, each output HTML file is considered dependent on:
 - Its content file in `content`.
 - Its layout file in `templates`.
 - The base template file called `base.html` in `templates`.

To generate the website files locally, run this command from the root directory of the repository:

```shell
make
```

The default command uses symlinks (shortcuts) to the CSS files instead of copying them, which doesn't work in some cases. To copy the CSS files, run this instead:

```shell
make pages
```


### Jinja

Jinja is a python library, so it can't be invoked directly from the command line. The `render-template.py` file is a wrapper that sends the contents of a YAML file to JINJA and prints the resulting HTML to standard output.

### GitHub Pages

[GitHub Pages](https://pages.github.com/) is a great option for deploying static websites. Traditionally, all of the HTML would need to be hosted in the repository itself. Recently, GitHub has allowed for [GitHub Actions](https://github.com/features/actions) to be used to push content to GitHub Pages.

Free accounts get 2000 minutes per month of actions, and each deployment of this site takes 20–30 seconds, so that gives a budget of around 4000 pushes to the website per month, or over 130 per day on average. The website can be tested locally, so there's no need to waste those minutes troubleshooting. either
