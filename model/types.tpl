
type (
	{{.upperStartCamelObject}}Model struct {
		{{if .withCache}}}conn *mysql.DataSource{{else}}conn *mysql.DataSource{{end}}
		table string
	}

	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}
)



