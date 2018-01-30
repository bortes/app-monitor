version: "2"
services:
  fluentd:
    image: bortes/fluentd-elasticsearch:latest
    labels:
      io.rancher.container.hostname_override:container_name: ''
{{- if ne .Values.HOST_LABEL "" }}
      io.rancher.scheduler.affinity:host_label: ${HOST_LABEL}
{{- end }}
      io.rancher.container.pull_image: always
    ports:
      - "24224:24224"

  elasticsearch:
    cap_add:
      - IPC_LOCK
    environment:
      - "ES_JAVA_OPTS=${ELASTICSEARCH_JAVA_OPTS}"
      - bootstrap.memory_lock=true
      - network.host=_site_
      - discovery.zen.ping.unicast.hosts=elasticsearch
      - cluster.name=app-monitor
      - ELASTIC_PASSWORD=p0o9I*U&
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:6.0.0
    labels:
      io.rancher.container.hostname_override:container_name: ''
{{- if ne .Values.HOST_LABEL "" }}
      io.rancher.scheduler.affinity:host_label: ${HOST_LABEL}
{{- end }}
      io.rancher.sidekicks:elasticsearch-sysctl: ''
    ulimits:
      memlock:
        soft: -1
        hard: -1

  sysctl:
    environment: 
      - SYSCTL_KEY=vm.max_map_count
      - SYSCTL_VALUE=262144
    image: rawmind/alpine-sysctl:0.1
    labels:
      io.rancher.container.hostname_override:container_name: ''
{{- if ne .Values.HOST_LABEL "" }}
      io.rancher.scheduler.affinity:host_label: ${HOST_LABEL}
{{- end }}
      io.rancher.container.start_once: true
    network_mode: none
    privileged: true

  kibana:
    image: docker.elastic.co/kibana/kibana-oss:6.0.0
    labels:
      io.rancher.container.hostname_override:container_name: ''
{{- if ne .Values.HOST_LABEL "" }}
      io.rancher.scheduler.affinity:host_label: ${HOST_LABEL}
{{- end }}
    ports:
      - "5601:5601"
