


func (t *{{.upperStartCamelObject}}) TableName() string{
	return "{{.originTable}}"
}

{{if .withRedis}}
func (t *{{.upperStartCamelObject}}Model) NextInt64Id() (int64, error) {
	return t.redisFlake.NextInt64Id()
}
{{end}}

func New{{.upperStartCamelObject}}Model(conn *mysql.DataSource{{if .withRedis}}, rc *redis.Client{{end}}{{if .withCache}}, c cache.CacheConf{{end}}) *{{.upperStartCamelObject}}Model {
	return &{{.upperStartCamelObject}}Model{
		{{if .withCache}}CachedConn: sqlc.NewConn(conn, c){{else}}conn:conn{{end}},
		table:      "{{.table}}",
		{{if .withRedis}}redisFlake: redisflake.NewFlakeNode(rc).SetNodeId("_t_{{.originTable}}"),{{end}}
	}
}
