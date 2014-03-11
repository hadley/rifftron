# rifftron

[![Build Status](https://travis-ci.org/hadley/rifftron.png?branch=master)](https://travis-ci.org/hadley/rifftron)

rifftron is an R wrapper for [difftron](http://difftron.com), which makes it
easy to detect changes in visual output.

## Getting started

1.  Sign up for an account at https://difftron.com/.

2.  Capture your api key and save it in an env var called `DIFFTRON_KEY`.
    The easiest way to do that is to add it to `~/.Renviron`:

    ```
    DIFFTRON_KEY=mykey
    ```

    If you want to use different keys for different projects/packages
    you can put it an `.Renviron` in the project directory.

## Running locally

Your visual tests should go in `tests/rifftron`. You can arrange your files
however you like, but they will be sourced in alphabetical order, and you
should use `capture_plot()` to name and capture graphics that you want to
compare over time.  Use `test_dir("tests/rifftron")` to run locally and
upload to difftron.

## Travis

rifftron is designed to be run from a continuous integration system like
travis. To get this set up, first create `tests/difftron.R`:

```R
library(rifftron)
riff_travis()
```

Next, securely add your difftron key to your travis script by running
`travis encrypt`, then typing `DIFFTRON_API="your-key"` and copying the
results into `.travis.yml`, like:

```
env:
  global:
    secure: "output from travis encrpyt..."
```

Now every time that travis runs R CMD check, it will upload your test
graphics to a new imageset labelled with the first 10 characters of the
git sha hash.
