Linked Data Fragments
=====================

A linked data fragment which takes an arbitrary subject and returns a cached
result.

Configuration
=============

Marmotta
--------

If you do not already have a marmotta instance, you can use an instance that runs off of jetty by running the following
generator:

    rails g linked_data_fragments:marmotta

Once that finishes, you here are some commands that can be run to use it:

    rake jetty:stop
    rake jetty:config
    rake jetty:start

