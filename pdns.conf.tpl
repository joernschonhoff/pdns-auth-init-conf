{{- range $key, $value := .Env -}}
{{ if ($key | strings.HasPrefix "PDNS_") }}
{{- $name := $key | strings.TrimPrefix "PDNS_" | strings.ReplaceAll "_" "-" | strings.ToLower -}}
{{ $name }}={{ $value }}
{{ end -}}
{{ end }}
