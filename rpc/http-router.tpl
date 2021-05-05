{{if .hasComment}}{{.comment}}{{end}}
router.Any("/{{.method}}", s.{{.method}}Http)