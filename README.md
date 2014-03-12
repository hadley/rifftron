# rifftron

[![Build Status](https://travis-ci.org/hadley/rifftron.png?branch=master)](https://travis-ci.org/hadley/rifftron)

rifftron is an R wrapper for [difftron](http://difftron.com), which makes it
easy to detect changes in visual output. To use rifftron you currently need to be using git, github and travis-ci.

## Basic principles

difftron is a web service that makes it easy to compare images over time. This is particularly useful when testing graphical output, because it makes it easy to see if there have been any changes. Images in difftron are organised into projects and imagesets. Rifftron provides a set of conventions to make it easy to use difftron from R:

* a project corresponds to a package.

* an imageset is the git sha1 hash, unless you have uncommited changed, in
  which it's called "draft". (This makes it easy to your draft code to the
  last commit).

* visual tests are R files that live in `tests/rifftron`. You can arrange
  your files however you like, but they will be sourced in alphabetical order,
  and you should use `capture_plot()` to name and capture graphics that you want
  to compare over time.

Use `test_dir("tests/rifftron")` to run tests locally, and compare to the last official commit.

## Getting started

1.  Sign up for an account at https://difftron.com/.

2.  Capture your api key and save it in an env var called `DIFFTRON_KEY`.
    The easiest way to do that is to add it to `~/.Renviron`:

    ```
    DIFFTRON_KEY=mykey
    ```

    If you want to use different keys for different projects/packages
    you can put it an `.Renviron` in the project directory.


## Travis

rifftron is designed to be run from a continuous integration system like
travis. To get this set up, first create `tests/difftron.R`:

```R
library(rifftron)
riff_travis()
```

Next, securely add your difftron key to your travis script by running
`travis encrypt`, then typing `DIFFTRON_KEY="your-key"` and copying the
results into `.travis.yml`, like:

```
env:
  global:
    secure: "output from travis encrpyt..."
```

Now every time that travis runs R CMD check, it will upload your test
graphics to a new imageset labelled with the first 10 characters of the
git sha hash.
