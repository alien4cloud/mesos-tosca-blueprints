# Mesos TOSCA templates

## Description

This project aims at providing a simple, plug-and-play TOSCA definition of an [Apache Mesos](http://mesos.apache.org) cluster with support of [Apache Aurora](http://aurora.apache.org) & [Mesosphere Marathon](https://mesosphere.github.io/marathon).  
It is shipped with ready-to-use templates that you can upload into Alien4Cloud. Just adjust the number of Slaves and Masters that fits your needs using the **Scalable** capability of the hosting computes and hit deploy.
Docker support is enabled for both schedulers although Marathon is the recommended solution for use cases involving Docker as the dominant technology. We created a TOSCA archive for the Docker engine [here](https://github.com/alien4cloud/samples/tree/master/docker-engine).

We made a [video](https://www.youtube.com/watch?v=IoOzf7wwCnM) showcasing the composition and deployment of a fully scalable Marathon + Mesos cluster using [Alien4Cloud](http://alien4cloud.github.io).

## Components

As Mesos and Aurora are both made of a master and a slave components, so does their tosca reprensation. Marathon, however, is more of a "meta-framework" for Mesos, and does not define a custom Executor.
Both schedulers are hosted on MesosMaster components and use the same Zookeeper quorum for HA. :

- MesosMaster : A Mesos Master component. This is the core of the cluster. It is in charge of managing the slaves' resources and sends offers to the registered frameworks.
It can be scaled up to 3 or 5 nodes to work in [High-Availability mode](http://mesos.apache.org/documentation/latest/high-availability/) using **Zookeeper**.
- MesosSlave : A Mesos Slave component. Those are the cluster's workers. A MesosSlave node will report back resources to the Master and run containerized tasks. It can be scaled up to thousands of nodes.
- AuroraScheduler : The Aurora Master component. It is a Mesos framework and as such, it is offered resources and can run tasks on the slaves. Provided a Job, the scheduler will insure
that it is always up and will gracefully handle failures. It is installed on the same compute as the Mesos Master - a behavior we implemented using a _HostedOn_ TOSCA relationship - and is scaled up using Zookeeper identically.
- AuroraExecutor : The Aurora Worker component. It is Aurora's own custom Executor (See [Mesos Framework Development Guide](http://mesos.apache.org/documentation/latest/app-framework-development-guide/) for more info).
Jobs' tasks are run within this component.
- Marathon: The Marathon master component. It is a Mesos framework and as such, it is offered resources and can run tasks on the slaves. Provided a Service, the scheduler will insure
that it is always up and will gracefully handle failures. It is installed on the same compute as the Mesos Master - a behavior we implemented using a _HostedOn_ TOSCA relationship - and is scaled up using Zookeeper identically.
Marathon provides a complete HTTP REST API for launching and managing services. Marathon relies on the Docker engine for Docker support.
- MesosDNS: A DNS server for Mesos slaves. It enables DNS resolution of tasks within the cluster. When used with Marathon, applications can be resolved through DNS following the following host pattern:  **app_name.marathon.mesos**. Please note that we currently use Marathon to launch MesosDNS (to ensure fault-tolerance).
- MarathonLB: A load balancer for Marathon. In conjunction with MesosDNS, it enables internal service discovery within the cluster, provided that Marathon apps are launched using the label : `{ "HAPROXY_GROUP": "internal" }`.

## Requirements

- This template is based on the [scalable capability](http://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.0/csprd01/TOSCA-Simple-Profile-YAML-v1.0-csprd01.html#_Toc430015753)
of the hosting compute. Scalability behavior is still WIP in TOSCA, and Cloudify has a very simple implementation of scalability management.
To workaround this, you will have to update your Cloudify manager. How-to can be found [here](http://alien4cloud.github.io/#/documentation/1.1.0/orchestrators/cloudify3_driver/index.html).
- The Mesos templates currently supports *Ubuntu Trusty 14.04*, *Centos 7 & 6*, *RHEL 7 & 6* and _Debian 8_. However, to provide Aurora support you have to narrow this down to **Centos 7** or **Ubuntu 14.04**.
We recommend the latter.
- Marathon supports the same OS than Mesos, however only **Ubuntu Trusty** has been implemented ATM.
- In order to properly operate, Marathon requires the Docker Engine. A [CSAR](https://github.com/alien4cloud/samples/tree/master/docker-engine) is available for your convenience.

## Known limitations

- As for now, the ASF only provides binaries for Aurora 0.12, which relies on Mesos 0.25.0 and may not work on other versions of Mesos.
To prevent misuse, we used node-filters on the Mesos version.
- To use Docker images in Aurora jobs, libmesos prerequisites must be installed inside the Docker container.
- Scheduler authentication and replicated log persistence (using EBS or a similar service) are yet to be implemented.

## Notes

- Topology templates are based upon [Alien4Cloud normative types](https://github.com/alien4cloud/tosca-normative-types/blob/master/normative-types.yml).
- As Mesos is designed to make the best use of its resources, it is recommended to use fewer, large instances (such like m4 flavors) instead of many small ones.
- For clusters up to several thousands of nodes, having 3 Masters in HA-mode is perfectly fine. To ensure a proper Zookeeper **quorum**, the number of masters must always be an odd number.
- Provided templates are for testing purposes and may not be fitted for production.
- You can access Aurora, Mesos and Marathon UIs using the Attribute *external_url*.

## Alien templates for Mesos

This repository contains 3 ready-to-use templates of Mesos topologies for [Alien4Cloud](http://alien4cloud.github.io).
They all are fully scalable and leverage Zookeeper for high-availability. We provide:
 - A simple [Mesos cluster](topology-mesos/mesos-ha-template.yml) with scalable slaves and masters,
 - An [Aurora cluster template](topology-aurora/aurora-template.yml),
 - A complete [Marathon cluster](topology-marathon/marathon-template) with built-in DNS and service discovery.
