resque-statistics
========

This is a node module that can be used to get statistical information about your resque instance. It gives you realtime information about your resque queues and workers by querying redis via a lua script.

example
=======

```javascript
var stats = require('node-resque-stats')

stats(function (err, stats) {
  console.log(stats)
})
```


```javascript
{ failing: 5944,
  queues:
   { thumbnails: { working: 0, pending: 0 }
     squeegee: { working: 0, pending: 1 },
     email: { working: 0, pending: 0 } },
  working: 2,
  workers:
   [ 'ip-10-158-39-207:32251+1:squeegee,thumbnails,email',
     'ip-10-158-39-207:32251+2:squeegee,thumbnails,email',
     'ip-10-29-24-24:5373+1:squeegee,thumbnails,email',
     'ip-10-29-24-24:5373+2:squeegee,thumbnails,email' ],
  processing:
   { 'ip-10-158-39-207:32251+2':
      { run_at: 'Sat Feb 07 2015 02:59:51 GMT+0000 (UTC)',
        worker: 'ip-10-158-39-207:32251+2',
        payload: [Object],
        queue: 'squeegee' },
     'ip-10-158-39-207:32251+1':
      { run_at: 'Sat Feb 07 2015 02:59:51 GMT+0000 (UTC)',
        worker: 'ip-10-158-39-207:32251+1',
        payload: [Object],
        queue: 'squeegee' } },
  squeegee: { working: 2, pending: 0 },
  failed: '403435',
  processed: '36896513' }

```


command-line usage
==================

```
resque-stats -h <redis-host> -p <redis-port> -a <redis-password> -n <namespace>
```

All arguments are optional.

Install
=======

To install the library, with [npm](http://npmjs.org) do:
```
$ npm install resque-statistics
```

and to install the command do:
```
$ npm install -g node-resque-stats
```

License
=======

ISC
