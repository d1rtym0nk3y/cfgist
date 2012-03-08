CFGIST
======

Pulls a gist from github and turns it into html on the server side

Uses the rhino Javascript engine to execute the javascript that would have been run in the browser and captures the output.

Example
-------

```ColdFusion
<cfimport taglib="cfgist" prefix="gh" />
<gh:gist id="1978698" cachepath="ram://" />
```

The gists will be cached to cachePath if provided, to clear the cache just delete the files