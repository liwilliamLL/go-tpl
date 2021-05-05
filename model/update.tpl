
func (m *{{.upperStartCamelObject}}Model) Update(data {{.upperStartCamelObject}}) error {
	{{if .withCache}}{{.primaryCacheKey}}
    _, err := m.Exec(func(conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = ?", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
		return conn.Exec(query, {{.expressionValues}})
	}, {{.primaryKeyVariable}}){{else}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = ?", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
    _,err:=m.conn.Exec(query, {{.expressionValues}}){{end}}
	return err
}
