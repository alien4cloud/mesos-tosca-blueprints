# Mesos TOSCA templates

## Description

This project aims at providing a simple, plug-and-play TOSCA definition of a Mesos cluster with support of Apache Aurora & Mesosphere Marathon.  
It is shipped with ready-to-use templates that you can upload into Alien4Cloud. Just adjust the number of Slaves and Masters that fits your needs using the **Scalable** capability of the hosting computes and hit deploy.
Docker support is enabled for both schedulers although Marathon the recommanded solution for use case involving Docker as the dominant technology.

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
Marathon provides a complete HTTP REST API for launching and managing services. When using Marathon in a topology, Docker support is assumed.

## Requirements

- This template is based on the [scalable capability](http://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.0/csprd01/TOSCA-Simple-Profile-YAML-v1.0-csprd01.html#_Toc430015753) 
of the hosting compute. Scalability behavior is still WIP in TOSCA, and Cloudify has a very simple implementation of scalability management.
To workaround this, you will have to update your Cloudify manager. How-to can be found [here](http://alien4cloud.github.io/#/documentation/1.1.0/orchestrators/cloudify3_driver/index.html).
- The Mesos templates currently supports *Ubuntu Trusty 14.04*, *Centos 7 & 6*, *RHEL 7 & 6* and _Debian 8_. However, to provide Aurora support you have to narrow this down to **Centos 7** or **Ubuntu 14.04**.
We recommend the latter.
- Marathon supports the same OS than Mesos, however only Ubuntu Trusty has been implemented ATM.
- In order to properly operate, Marathon requires the Docker Engine to be installed on each and every slave. 

## Known limitations

- As for now, the ASF only provides binaries for Aurora 0.12, which relies on Mesos 0.25.0 and may not work on other versions of Mesos. 
To prevent misuse, we used node-filters on the Mesos version.
- Scheduler authentication and replicated log persistence (using EBS or a similar service) are yet to be implemented.
- The MesosSlave's _containerizers_ property allows Docker support, but this requires installing the Docker daemon on each slave. See this [script](scripts/docker_install.sh) for a simple installation for Centos.
- A proxy system is yet to be implemented in order to resolve the leading master's URL using Zookeeper.

## Notes

- Topology templates are based upon [Alien4Cloud normative types](https://github.com/alien4cloud/tosca-normative-types/blob/master/normative-types.yml).
- As Mesos is designed to make the best use of its resources, it is recommended to use fewer, large instances (such like m4 flavors) instead of many small ones.
- For clusters up to several thousands of nodes, having 3 Masters in HA-mode is perfectly fine. To ensure a proper Zookeeper **quorum**, the number of masters must always be an odd number.
- Provided templates are for testing purposes and may not be fitted for production.
- You can access Aurora & Mesos UI using the Mesos Master Attribute _external_url_.
- About the *scripts* directory : this contains scripts designed at an early stage to install a Mesos cluster. They are kept here for reference but should be removed from this repository in the future.