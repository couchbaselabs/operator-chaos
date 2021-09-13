# Chaos Testing With Couchbase Autonomous Operator

This repository is to support the Couchbase CONNECT 2021 talk: "How We Don’t Break Your Toys: Chaos Testing With Couchbase Autonomous Operator".

It includes all the supporting scripts, examples and the like to use with the presentation.

## Abstract

Take a peek behind the scenes of qualification testing of every Couchbase Autonomous Operator release. See how we combine fully automated testing with chaos-generating tools like Chaos Mesh to test and improve the resilience of clusters managed by the operator, while also making use of the Couchbase observability stack to provide monitoring.

Via the power of live demos, you’ll get a brief introduction to Chaos testing tools and how Couchbase uses them, plus how these tools can help others.

# Usage

A simple [run](./run.sh) script is provided that will spin up a full cluster and deploy both Couchbase Server as well as various chaos testing tools discussed in the presentation.
Note that this runs on Kubernetes-in-docker or [KIND](https://kind.sigs.k8s.io/) so requires Docker plus a fairly chunky amount of resource to do it all locally.
