


func (m *{{.upperStartCamelObject}}Model) CursorAll(filters map[string]interface{}, sort []*model.SortSpec) (bean []*{{.upperStartCamelObject}}, err error) {
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

	cond, values, err := mysql.BuildWhere(filters, columns, "{{.snakeStartCamelObject}}")
	if err != nil {
		return
	}

	//fmt.Printf("%+v", p_columns)
	//limit, offset := mysql.BuildLimit(query)
	sorts, err := mysql.BuildSort(sort, columns, "{{.snakeStartCamelObject}}")
	if err != nil {
		return
	}

	var joinColumns string
	selectColumns := []string{fmt.Sprintf("%s.*", (&{{.upperStartCamelObject}}{}).TableName())}
	{{range .joins -}}
	{
		joinColumns, err = mysql.GetTableColumnsStr(m.conn, &{{.dataType}}{}, "{{.upperStartCamelObject}}", true)
		if err != nil {
			return
		}

		selectColumns = append(selectColumns, joinColumns)
	}
	{{end}}

	sess := m.conn.GetEngine().Debug().Model(&{{.upperStartCamelObject}}{}).
		Select(strings.Join(selectColumns, ",")).
		{{range .joins -}}
		Joins("{{.joinType}} JOIN `{{.snakeStartCamelObject}}` `{{.upperStartCamelObject}}` ON `{{$.snakeStartCamelObject}}`.`{{.foreignKey}}` = `{{.upperStartCamelObject}}`.`{{.references}}` AND {{.upperStartCamelObject}}.deleted_at is NUll").
		{{end}}
		{{.group}}Where(cond, values...)

	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}

	if bean == nil {
		bean = []*{{.upperStartCamelObject}}{}
	}

	err = sess.Find(&bean).Error
	if err != nil {
		err = xerr.NewError(xerr.ERR_DB_QUERY, err, err.Error())
		return
	}
	return
}

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
	sorts, err := mysql.BuildSort(query.Sort, columns, "{{.snakeStartCamelObject}}")
	if err != nil {
		return
	}

	var joinColumns string
	selectColumns := []string{fmt.Sprintf("%s.*", (&{{.upperStartCamelObject}}{}).TableName())}
	{{range .joins -}}
	{
		joinColumns, err = mysql.GetTableColumnsStr(m.conn, &{{.dataType}}{}, "{{.upperStartCamelObject}}", true)
		if err != nil {
			return
		}

		selectColumns = append(selectColumns, joinColumns)
	}
	{{end}}

	sess := m.conn.GetEngine().Debug().Model(&{{.upperStartCamelObject}}{}).
		Select(strings.Join(selectColumns, ",")).
		{{range .joins -}}
		Joins("{{.joinType}} JOIN `{{.snakeStartCamelObject}}` `{{.upperStartCamelObject}}` ON `{{$.snakeStartCamelObject}}`.`{{.foreignKey}}` = `{{.upperStartCamelObject}}`.`{{.references}}` AND {{.upperStartCamelObject}}.deleted_at is NUll").
		{{end}}
		{{.group}}Where(cond, values...)

	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}

	if bean == nil {
		bean = &[]*{{.upperStartCamelObject}}{}
	}

	err = sess.Limit(limit).Offset(offset).Find(&bean).Error
	if err != nil {
		err = xerr.NewError(xerr.ERR_DB_QUERY, err, err.Error())
		return
	}
	var maxCount int64
	err = sess.{{.distinct}}Limit(-1).Offset(-1).Count(&maxCount).Error
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

