{{/*
Expand the name of the chart.
*/}}
{{- define "ds-sim.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/* define the dis-sim image tag
*/}}
{{- define "ds-sim.tag" -}}
{{- default .Chart.Version .Values.image.tag }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ds-sim.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ds-sim.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ds-sim.labels" -}}
helm.sh/chart: {{ include "ds-sim.chart" . }}
{{ include "ds-sim.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{/*
Test-labels
*/}}
{{- define "ds-sim.test-labels" -}}
helm.sh/chart: {{ include "ds-sim.chart" . }}
app.kubernetes.io/name: {{ include "ds-sim.name" . }}-test-connection
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{/*
Selector labels
*/}}
{{- define "ds-sim.selectorLabels" -}}
app: {{ include "ds-sim.name" . }}
app.kubernetes.io/name: {{ include "ds-sim.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ds-sim.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ds-sim.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
set the image pull policy based on the current environment
in dev environment image pull policy will always be never
*/}}
{{- define "ds-sim.pullPolicy" }}
{{- if .Values.imageoverride -}}
IfNotPresent
{{- else if eq .Values.env.type "production" -}}
{{ .Values.imagePullPolicy }}
{{- else if eq .Values.env.type "ci" -}}
Always
{{- else -}}
Never
{{- end }}
{{- end }}

{{/*
set the ds-sim-app image
*/}}
{{- define "ds-sim.image" -}}
{{- $tag := (include "ds-sim.tag" .) -}}
{{- if .Values.imageoverride -}}
{{ .Values.imageoverride }}
{{- else if .Values.image.repository  -}}
'{{ .Values.image.repository }}/{{ .Values.image.name }}:{{ $tag }}'
{{- else -}}
'{{ .Values.image.name }}:{{ $tag }}'
{{- end }}
{{- end }}
{{/*
ds-sim paths
*/}}
{{- define "ds-sim.path" }}
{{- end }}
