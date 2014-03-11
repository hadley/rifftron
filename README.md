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

## Travis

rifftron is fundamentally designed to be run from a continuous integration
system like travis. It provides tools to help you test locally, but I
expect the majority of visual tests will be triggered automatically by
travis.  To this end, you should add a `tests/difftron.R` to your package
containing:

```R
library(rifftron)
riff_travis()
```

You'll also need to securely add your difftron key to your travis script by
running `travis encrypt`, then typing `DIFFTRON_API="your-key"` and copying the
results into `.travis.yml`, like:

```
env:
  global:
    secure: "output from travis encrpyt...
```
