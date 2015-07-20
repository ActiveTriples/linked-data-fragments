Linked Data Fragments
=====================

A linked data fragment which takes an arbitrary subject and returns a cached
result.

Configuration
=============

YAML
----

There is a ldf.yml.sample that you need to configure as ldf.yml. There are default values already entered into the
file.

Marmotta
--------

If you do not already have a marmotta instance, you can use an instance that runs off of jetty by running the following
generator:

    rails g linked_data_fragments:marmotta

Once that finishes, please copy config/jetty.yml.sample to config/jetty.yml. You can change the defaults.

Once that is all setup, here are some commands that can be run to use the marmotta instance:

    rake jetty:stop
    rake jetty:config
    rake jetty:start


Usage
=====

Dataset Response
----------------

In the default config, this is [http://localhost:3000?format=jsonld](http://localhost:3000?format=jsonld)

Resolving a subject uri
-----------------------

In the default config, this would be something like [http://localhost:3000/http://dbpedia.org/resource/Berlin?format=jsonld](http://localhost:3000/http://dbpedia.org/resource/Berlin?format=jsonld)
 assuming that you have marmotta running and that linked data source configured in marmotta.