


func (t *{{.upperStartCamelObject}}) TableName() string{
	return "{{.originTable}}"
}



func New{{.upperStartCamelObject}}Model(conn *mysql.DataSource{{if .withCache}}, c cache.CacheConf{{end}}) *{{.upperStartCamelObject}}Model {
	return &{{.upperStartCamelObject}}Model{
		{{if .withCache}}CachedConn: sqlc.NewConn(conn, c){{else}}conn:conn{{end}},
		table:      "{{.table}}",
	}
}
