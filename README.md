twa
===

[![Build Status](https://travis-ci.org/trailofbits/twa.svg?branch=master)](https://travis-ci.org/trailofbits/twa)
![Docker Build Status](https://img.shields.io/docker/build/trailofbits/twa.svg)


A **t**iny **w**eb **a**uditor with strong opinions.

## Usage

### Dependencies

You'll need `bash` 4, `curl`, `dig`, `jq`, and `nc`, along with a fairly POSIX system.

[`testssl.sh`](https://github.com/drwetter/testssl.sh) is an optional dependency.

### Auditing

```bash
# Audit a site.
$ twa google.com
> FAIL(google.com): TWA-0102: HTTP redirects to HTTP (not secure)
> FAIL(google.com): TWA-0205: Strict-Transport-Security missing
> MEH(google.com): TWA-0206: X-Frame-Options is 'sameorigin', consider 'deny'
> FAIL(google.com): TWA-0209: X-Content-Type-Options missing
> PASS(google.com): X-XSS-Protection specifies mode=block
> FAIL(google.com): TWA-0214: Referrer-Policy missing
> FAIL(google.com): TWA-0219: Content-Security-Policy missing
> FAIL(google.com): TWA-0220: Feature-Policy missing
> PASS(google.com): Site sends 'Server', but probably only a vendor ID: gws
> PASS(google.com): Site doesn't send 'X-Powered-By'
> PASS(google.com): Site doesn't send 'Via'
> PASS(google.com): Site doesn't send 'X-AspNet-Version'
> PASS(google.com): Site doesn't send 'X-AspNetMvc-Version'
> PASS(google.com): No SCM repository at: http://google.com/.git/HEAD
> PASS(google.com): No SCM repository at: http://google.com/.hg/store/00manifest.i
> PASS(google.com): No SCM repository at: http://google.com/.svn/entries
> PASS(google.com): No environment file at: http://google.com/.env
> PASS(google.com): No environment file at: http://google.com/.dockerenv

# Audit a site, and be verbose (on stderr)
$ twa -v example.com

# Audit a site and emit results in CSV
$ twa -c example.com

# Audit a site and its www subdomain
$ twa -w example.com

# Audit a site and include testssl
# Requires either `testssl` or `testssl.sh` on your $PATH
$ twa -s example.com
```

`twa` takes one domain at a time, and only audits more than one domain at once in the `-w` case.
If you need to audit multiple domains, run it multiple times.

Each result line comprises a test result, and looks like this:

```
TYPE(domain): explanation
```

where `TYPE` is one of `PASS`, `MEH`, `FAIL`, `UNK`, `SKIP`, and `FATAL`:

* `PASS`: The test passed with flying colors.
* `MEH`: The test passed, but with one or more things that could be improved.
* `FAIL`: The test failed, and should be fixed.
* `UNK`: The server gave us something we didn't understand.
* `SKIP`: The server gave us something we understood, but that we don't handle yet.
* `FATAL`: A really important test failed, and should be fixed immediately.

If the `TYPE` is negative (i.e. `MEH`, `FAIL`, or `FATAL`), the explanation will be prefixed with
a reference code with the format `TWA-XXYY`, where `XX` is the stage that the result occurred in
and `YY` is a unique identifier for the result.

### Scoring

`twa` can be used alongside `tscore`, which provides a basic scoring mechanism:

```bash
$ twa google.com | tscore
> 35 9 1 6 0 0 0
```

The score format is `score npasses nmehs nfailures nunknowns nskips totally_screwed`, so you can do:

```bash
$ read -r score npasses nmehs nfailures nunknowns nskips totally_screwed < <(twa google.com | tscore)
$ echo "score: ${score}"
```

Like `twa`, `tscore` is opinionated. You can change its opinions (i.e., its score weights)
by editing it.

### Docker

`twa` can be used from a lightweight (29MB) Alpine Docker container.

To run it from a Docker container:

```bash
$ docker run --rm -t trailofbits/twa -vw google.com
```

or, to build it manually:

```bash
$ git clone https://github.com/trailofbits/twa.git
$ cd twa
$ docker build -t trailofbits/twa .
$ docker run --rm -t trailofbits/twa -vw google.com
```


## Contributing

Check out the [contributing guidelines](CONTRIBUTING.md).
