# app-monitor
A dockerized application monitor.

The event data will be collected with [Docker Logging Driver](https://docs.fluentd.org/v0.12/articles/docker-logging) and delivery by [fluentd-elasticsearch](/bortes/fluentd-elasticsearch/README.md).

Once data was store on Elasticsearch you can use Kibana and/or Grafana to display your dockerized application event history.


# hands-on
Run multi-container Docker application:

```bash
docker-compose up
```


After that, just run a application and setting log driver:

```bash
docker run --name webapp -p 8080:80 --log-driver=fluentd --log-opt fluentd-address=localhost:24224 nginx:alpine
```


# next steps
Change Elasticsearch data path to enable scale persisted container.

Enable Kibana security with X-Pack or some kind of basic authentication.


# more info
About [Kibana](https://www.elastic.co/guide/en/kibana/current/dashboard.html) output and [Grafana](https://grafana.com/dashboards).


# thanks
Icon made by [Freepik](http://www.freepik.com) from [www.flaticon.com](https://www.flaticon.com/) is licensed by [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/).