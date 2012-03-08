CFGIST
======

Pulls a gist from github and turns it into html on the server side

Example
-------

```ColdFusion
<cfimport taglib="cfgist" prefix="gh" />
<gh:gist id="1978698" cachepath="ram://" />
```