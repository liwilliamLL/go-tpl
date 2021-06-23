
func (m *{{.upperStartCamelObject}}Model)Page(query *model.PageQuery, bean *[]*{{.upperStartCamelObject}}) (page *model.Page, err error) {
	columns := make(map[string]bool, 0)
	for k, v := range map[string]interface{}{
		"{{.snakeStartCamelObject}}": &{{.upperStartCamelObject}}{},
		{{range .joins -}}
		"{{.upperStartCamelObject}}":     &{{.dataType}}{},
		{{end}}
	} {
		cs, xerr := mysql.GetTableColumns(m.conn, v, k)
		if xerr != nil {
			return
		}

		for k, v := range cs {
			columns[k] = v
		}
	}

	cond, values, err := mysql.BuildWhere(query.Filters, columns, "{{.snakeStartCamelObject}}")
	if err != nil {
		return
	}

	//fmt.Printf("%+v", p_columns)
	limit, offset := mysql.BuildLimit(query)
	sorts, err := mysql.BuildSort(query.Sort, columns)
	if err != nil {
		return
	}

	sess := m.conn.GetEngine().Debug().Model(&{{.upperStartCamelObject}}{}).
		{{range .joins -}}
		Joins("{{.upperStartCamelObject}}").
		{{end}}
		Where(cond, values...).
		{{.group}}Limit(limit).Offset(offset)

	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}

	if bean == nil {
		bean = &[]*{{.upperStartCamelObject}}{}
	}
	err = sess.Find(&bean).Error
	var maxCount int64
	err = sess.{{.distinct}}Count(&maxCount).Error
	if err != nil {
		err = xerr.NewError(xerr.ERR_DB_QUERY, err, err.Error())
		return
	}
	page = &model.Page{
		Content:  bean,
		Total:    maxCount,
		PageNo:   query.PageNo,
		PageSize: query.PageSize,
	}
	return
}

