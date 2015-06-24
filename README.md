## IMPORTANT NOTE: BigCouch is no longer supported by Cloudant

## Overview

BigCouch is a highly available, fault-tolerant, clustered, mostly api-compliant
version of [Apache CouchDB][1]. While it appears to the end-user as one CouchDB
instance, it is in fact one or more BigCouch nodes in an elastic cluster,
acting in concert to store and retrieve documents, index and serve views, and
serve CouchApps. BigCouch has been developed and is continually maintained by
[Cloudant][2].

Clusters behave according to concepts outlined in [Amazon's Dynamo paper][4],
namely that each BigCouch node can accept requests, data is placed on
partitions based on a consistent hashing algorithm, and quorum protocols are
used for read/write operations.

BigCouch is made available under an Apache 2.0 license. See the LICENSE file
for details.

## Getting Started

If your main intent is to use BigCouch, you can follow [this
guide](http://bigcouch.cloudant.com/use).  If you’re interested in extending
BigCouch, patching bugs, etc., you should follow [these
instructions](http://bigcouch.cloudant.com/develop) instead.

More information can be found on the official [BigCouch
website](http://bigcouch.cloudant.com/). You can also ask questions on or
subscribe to [the mailing list](http://groups.google.com/group/bigcouch-user).

## Troubleshooting

Please see http://bigcouch.cloudant.com/troubleshoot

## Contact

Cloudant folks are usually hanging out in IRC. Freenode, channel #cloudant.
There's also a [Google Group](http://groups.google.com/group/bigcouch-user).

[1]: http://couchdb.apache.org
[2]: http://cloudant.com
[4]: http://www.allthingsdistributed.com/2007/10/amazons_dynamo.html
