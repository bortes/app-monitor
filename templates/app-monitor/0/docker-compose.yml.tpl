version: "2"
services:
  fluentd:
    image: bortes/fluentd:v0.14
    build:
      context: ./fluent
      dockerfile: Dockerfile
    labels:
      - io.rancher.container.hostname_override:container_name
{{- if ne .Values.FLUENTD_HOST_LABEL ""}}
      - io.rancher.scheduler.affinity:host_label:server=${FLUENTD_HOST_LABEL}
{{- end}}
{{- if ne .Values.FLUENTD_PORT}}
    ports:
      - "24224:24224"
{{- end}}

  elasticsearch:
    cap_add:
      - IPC_LOCK
    environment:
      - "ES_JAVA_OPTS=${ELASTICSEARCH_JAVA_OPTS}"
      - bootstrap.memory_lock=true
      - network.host=_site_
      - discovery.zen.ping.unicast.hosts=elasticsearch
      - cluster.name=app-monitor
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:6.0.0
    labels:
      - io.rancher.container.hostname_override:container_name
{{- if ne .Values.ELASTICSEARCH_HOST_LABEL ""}}
      - io.rancher.scheduler.affinity:host_label:server=${ELASTICSEARCH_HOST_LABEL}
{{- end}}
      - io.rancher.sidekicks:elasticsearch-sysctl
    ulimits:
      memlock:
        soft: -1
        hard: -1
{{- if ne .Values.ELASTICSEARCH_PORT}}
    ports:
      - "9200:9200"
{{- end}}
{{- if .Values.ELASTICSEARCH_VOLUME_NAME}}
volumes:
  {{.Values.ELASTICSEARCH_VOLUME_NAME}}:
    {{- if .Values.ELASTICSEARCH_STORAGE_DRIVER}}
    driver: {{.Values.ELASTICSEARCH_STORAGE_DRIVER}}
    {{- if .Values.ELASTICSEARCH_STORAGE_DRIVER_OPT}}
    driver_opts:
      {{.Values.ELASTICSEARCH_STORAGE_DRIVER_OPT}}
    {{- end }}
    {{- end }}
{{- end }}

  sysctl:
    environment: 
      - SYSCTL_KEY=vm.max_map_count
      - SYSCTL_VALUE=262144
    image: rawmind/alpine-sysctl:0.1
    labels:
      - io.rancher.container.hostname_override:container_name
{{- if ne .Values.ELASTICSEARCH_HOST_LABEL ""}}
      - io.rancher.scheduler.affinity:host_label:server=${ELASTICSEARCH_HOST_LABEL}
{{- end}}
      - io.rancher.container.start_once:true
    network_mode: none
    privileged: true

  kibana:
    image: docker.elastic.co/kibana/kibana-oss:6.0.0
    labels:
      - io.rancher.container.hostname_override:container_name
{{- if ne .Values.KIBANA_HOST_LABEL ""}}
      - io.rancher.scheduler.affinity:host_label:server=${KIBANA_HOST_LABEL}
{{- end}}
{{- if ne .Values.KIBANA_PORT}}
    ports:
      - "5601:5601"
{{- end}}

  grafana:
    environment: 
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    image: grafana/grafana:4.6.0
    labels:
      - io.rancher.container.hostname_override:container_name
{{- if ne .Values.GRAFANA_HOST_LABEL ""}}
      - io.rancher.scheduler.affinity:host_label:server=${GRAFANA_HOST_LABEL}
{{- end}}
{{- if ne .Values.GRAFANA_PORT}}
    ports:
      - "3000:3000"
{{- end}}