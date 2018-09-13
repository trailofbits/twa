twa
===

A **t**iny **w**eb **a**uditor with strong opinions.

## Usage

### Dependencies

You'll need `bash`, `awk`, `curl`, and `nc`, along with a fairly POSIX system.

### Auditing

```bash
# Audit a site.
$ twa google.com
> FAIL(google.com): HTTP redirects to HTTP (not secure)
> FAIL(google.com): Strict-Transport-Security missing
> MEH(google.com): X-Frame-Options is 'sameorigin', consider 'deny'?
> FAIL(google.com): X-Content-Type-Options missing
> PASS(google.com): X-XSS-Protection specifies mode=block
> FAIL(google.com): Referrer-Policy missing
> FAIL(google.com): Content-Security-Policy missing
> FAIL(google.com): Feature-Policy missing
> PASS(google.com): Site sends 'Server', but probably only a vendor ID: gws
> PASS(google.com): Site doesn't send 'X-Powered-By'
> PASS(google.com): Site doesn't send 'Via'
> PASS(google.com): Site doesn't send 'X-AspNet-Version'
> PASS(google.com): Site doesn't send 'X-AspNetMvc-Version'
> PASS(google.com): No SCM repository at: http://google.com/.git/HEAD
> PASS(google.com): No SCM repository at: http://google.com/.hg/store/00manifest.i
> PASS(google.com): No SCM repository at: http://google.com/.svn/entries

# Audit a site, and be verbose.
$ twa -v google.com

# Audit a site and its www subdomain.
$ twa -w google.com
```

`twa` takes one domain at a time, and only audits more than one domain at once in the `-w` case.
If you need to audit multiple domains, run it multiple times.

Each result line comprises a test result, and looks like this:

```
TYPE($domain): explanation
```

where `TYPE` is one of `PASS`, `MEH`, `FAIL`, `UNK`, `SKIP`, and `FATAL`:

* `PASS`: The test passed with flying colors.
* `MEH`: The test passed, but with one or more things that could be improved.
* `FAIL`: The test failed, and should be fixed.
* `UNK`: The server gave us something we didn't understand.
* `SKIP`: The server gave us something we understood, but that we don't handle yet.
* `FATAL`: A really important test failed, and should be fixed immediately.

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

Like `twa`, `tscore` is opinionated. You can change its opinions (i.e., it's score weights)
by editing it.

## Contributing

New checks and refinements to existing ones are welcome and appreciated.
