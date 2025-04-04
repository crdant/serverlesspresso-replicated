{{/*
Expand the name of the chart.
*/}}
{{- define "cloud-providers.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloud-providers.fullname" -}}
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
{{- define "cloud-providers.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloud-providers.labels" -}}
helm.sh/chart: {{ include "cloud-providers.chart" . }}
{{ include "cloud-providers.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloud-providers.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloud-providers.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
AWS credentials in the format expected by Crossplane
*/}}
{{- define "cloud-providers.awsCredentials" -}}
[default]
aws_access_key_id = {{ .Values.providers.aws.providerConfig.credentials.accessKeyId }}
aws_secret_access_key = {{ .Values.providers.aws.providerConfig.credentials.secretAccessKey }}
{{- if .Values.providers.aws.providerConfig.credentials.sessionToken }}
aws_session_token = {{ .Values.providers.aws.providerConfig.credentials.sessionToken }}
{{- end }}
{{- end }}
