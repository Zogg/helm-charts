{{- define "base.argoRollouts" -}}
{{- if .Values.argo.rollouts.enabled }}
{{- if eq .Values.argo.rollouts.type "workloadRef" }}
---
apiVersion: {{ .Values.argo.rollouts.apiVersion }}
kind: {{ .Values.argo.rollouts.kind }}
metadata:
  name: {{ include "base.fullname" . }}
  {{- if .Values.namespace }}
  namespace: {{ .Values.namespace }}
  {{- end }}
  labels:
    {{- include "base.labels" . | trim | nindent 4 }}
spec:
  {{- if .Values.keda.enabled }}
  replicas: {{ .Values.keda.minReplicaCount | default 0 }}
  {{- else if .Values.autoscaling.enabled }}
  replicas: {{ .Values.autoscaling.minReplicas }}
  {{- else }}
  replicas: {{ .Values.replicas }}
  {{- end }}
  workloadRef:
    apiVersion: {{ .Values.apiVersion | default "apps/v1" }}
    kind: {{ include "base.kind" . }}
    name: {{ include "base.fullname" . }}
  {{- with .Values.argo.rollouts.strategy }}
  strategy:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}