


func (t *{{.upperStartCamelObject}}) TableName() string{
	return "{{.originTable}}"
}

{{if .withRedis}}
func (t *{{.upperStartCamelObject}}Model) NextInt64Id() (int64, error) {
	return t.redisFlake.NextInt64Id()
}
{{end}}

func New{{.upperStartCamelObject}}Model(conn *mysql.DataSource{{if .withRedis}}, rc *redis.Client{{end}}{{if .withCache}}, c cache.CacheConf{{end}}) (m *{{.upperStartCamelObject}}Model) {
	m = &{{.upperStartCamelObject}}Model{
		{{if .withCache}}CachedConn: sqlc.NewConn(conn, c){{else}}conn:conn{{end}},
		table:      "{{.table}}",
		{{if .withRedis}}redisFlake: redisflake.NewFlakeNode(rc).SetNodeId("_t_{{.originTable}}"),{{end}}
	}

	{{if .withRedis -}}
	var err error
	var result MaxInt64Struct
	err = m.conn.GetEngine().Debug().Table(m.table).Select("max(`{{originalPrimaryKey}}`) as max").Limit(1).Scan(&result).Error
	if err != nil {
		panic(errors.New(fmt.Sprintf("%s: query max err", m.table)))
	}

	var id int64
	id, err = m.redisFlake.CurrentInt64Id()
	if err != nil {
		panic(errors.New(fmt.Sprintf("%s: redisFlask get currentId err", m.table)))
	}

	if id == result.Max {
		return
	}

	if result.Max < id { // 修正
		return
	}

	if result.Max > (1 << 53) {
		result.Max = 100000
	}
	err = m.redisFlake.SetInt64Id(result.Max)
	if err != nil {
		panic(errors.New(fmt.Sprintf("%s: redisFlask set currentId err", m.table)))
	}
	{{end -}}

	return
}
