# elasticsearch-script-plugin

This project is a super simple example of an Elasticsearch script plugin.

See: https://www.elastic.co/guide/en/elasticsearch/reference/6.6/modules-scripting-engine.html

Runs on Elasticsearch 6.6.0 and Java 1.8.

## Quick Start

Gradle and Java info.

```sh
elasticsearch-script-plugin $ gradle -v

------------------------------------------------------------
Gradle 5.2.1
------------------------------------------------------------

Build time:   2019-02-08 19:00:10 UTC
Revision:     f02764e074c32ee8851a4e1877dd1fea8ffb7183

Kotlin DSL:   1.1.3
Kotlin:       1.3.20
Groovy:       2.5.4
Ant:          Apache Ant(TM) version 1.9.13 compiled on July 10 2018
JVM:          1.8.0_202 (Oracle Corporation 25.202-b08)
OS:           Mac OS X 10.14.3 x86_64
```

### Build Docker Container

The following will build the plugin and build a docker container with
the plugin installed.

```sh
gradle docker
```

### Run Docker Image

The following will spin up a two node ES cluster in docker.

```sh
docker-compose -f misc/docker-compose.yml up
```

To shut down run

```sh
docker-compose -f misc/docker-compose.yml down
```

### Create Some Documents

The following curl commands will create two documents that have the
term 'foo' in the 'body' field.

```sh
curl -X PUT "localhost:9200/some/doc/1" -H 'Content-Type: application/json' -d'
{
    "body" : "foo bar zoo baz moo foo foo foo"
}
'
curl -X PUT "localhost:9200/some/doc/2" -H 'Content-Type: application/json' -d'
{
    "body" : "foo bar baz"
}
'
```

### Run Search and Trigger Script Plugin

The following search will trigger our custom script plugin because
it's looking for documents that have 'foo' in the 'body' field. The
more 'foo' you have in your 'body' the higher your `_score`.

You can change / add / remove `params` passed to the script below to prove
that the script is actually being called and does different things based
on different params. If you remove either params, the script will throw an
error.

```sh
curl -X POST "localhost:9200/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "function_score": {
      "query": {
        "match": {
          "body": "foo"
        }
      },
      "functions": [
        {
          "script_score": {
            "script": {
                "source": "pure_df",
                "lang" : "expert_scripts",
                "params": {
                    "field": "body",
                    "term": "foo"
                }
            }
          }
        }
      ]
    }
  }
}
'
```

Here's the output from the above search. You can see that the score is higher
for doc 1 than for doc 2.

```json
{
    "took": 256,
    "timed_out": false,
    "_shards": {
        "total": 5,
        "successful": 5,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": 2,
        "max_score": 1.9473865,
        "hits": [
            {
                "_index": "some",
                "_type": "doc",
                "_id": "1",
                "_score": 1.9473865,
                "_source": {
                    "body": "foo bar zoo baz moo foo foo foo",
                    "post_date": "2009-11-15T14:12:12",
                    "message": "trying out Elasticsearch"
                }
            },
            {
                "_index": "some",
                "_type": "doc",
                "_id": "2",
                "_score": 0.2876821,
                "_source": {
                    "body": "foo bar zoo"
                }
            }
        ]
    }
}
```
