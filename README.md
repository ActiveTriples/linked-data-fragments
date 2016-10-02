Linked Data Fragments
=====================

A linked data fragment which takes an arbitrary subject and returns a cached
result.

Configuration
=============

YAML
----

You need a ldf.yml file configured. There are currently two sample files for configurations of two different backend
caching layers: ldf.yml.sample_marmotta and ldf.yml.sample_repository. 

Marmotta
--------

If you do not already have a marmotta instance, you can use an instance that runs off of jetty by running the following
rake task:

    rake ldfjetty:install

Once that finishes, please copy config/jetty.yml.sample to config/jetty.yml. You can change the defaults.

Once that is all setup, here are some commands that can be run to use the marmotta instance:

    rake ldfjetty:stop
    rake ldfjetty:config
    rake ldfjetty:start

Blazegraph
-----------

If you do not already have a blazegraph instance, you can use an instance that runs off of jetty by running the following
rake task:

    rake ldfjetty:install

Once that finishes, please copy config/ldfjetty.yml.sample to config/ldfjetty.yml. You can change the defaults.

It is recommended that you populate Blazegraph with LoC for terms to work. To do this:

* Download the latest subjects vocab from: [http://id.loc.gov/download/](http://id.loc.gov/download/) (the nt version of “LC Subject Headings (SKOS/RDF only)”)

* Extract the above download into a directory.

* Run the following command from that extraction directory:
    curl -H 'Content-Type: text/turtle' --upload-file subjects-skos-20140306.nt -X POST "http://localhost:8988/blazegraph/sparql?context-uri=http://id.loc.gov/static/data/authoritiessubjects.nt.skos.zip"

Once that is all setup, here are some commands that can be run to use the blazegraph instance:

    rake ldfjetty:stop
    rake ldfjetty:config
    rake ldfjetty:start

Usage
=====

Dataset Response
----------------

In the default config, this is [http://localhost:3000?format=jsonld](http://localhost:3000?format=jsonld)

Resolving a subject uri
-----------------------

In the default config, this would be something like [http://localhost:3000/http://dbpedia.org/resource/Berlin?format=jsonld](http://localhost:3000/http://dbpedia.org/resource/Berlin?format=jsonld)
 assuming that you have marmotta running and that linked data source configured in marmotta.
