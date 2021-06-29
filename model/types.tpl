
type (
	{{.upperStartCamelObject}}Model struct {
		{{if .withCache}}}conn *mysql.DataSource{{else}}conn *mysql.DataSource{{end}}
		table string
		{{if .withRedis}}redisFlake *redisflake.Node{{end}}
	}

	// {{.upperStartCamelObject}} {{.comment}}
	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}
)



