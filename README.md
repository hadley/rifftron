# rifftron

rifftron is an R wrapper for [difftron](http://difftron.com), which makes it
easy to detect changes in visual output.

## Getting starting

1.  Sign up for an account at https://difftron.com/.

2.  Capture your api key and save it in an env var called `DIFFTRON_KEY`.
    The easiest way to do that is to add it to `~/.Renviron`:

    ```
    DIFFTRON_KEY=mykey
    ```

    If you want to use different keys for different projects/packages
    you can put it an `.Renviron` in the project directory.
