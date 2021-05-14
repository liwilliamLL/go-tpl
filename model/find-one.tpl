func (m *{{.upperStartCamelObject}}Model)FindOne({{.lowerStartCamelPrimaryKey}} {{.dataType}}) (resp *{{.upperStartCamelObject}}, err error){
	resp = &{{.upperStartCamelObject}}{}
	err =  m.conn.GetEngine().Model(resp).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).First(resp).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) FindInBatches(ids []int64) (resp []*{{.upperStartCamelObject}}, err error) {
	resp = make([]*{{.upperStartCamelObject}}, 0)
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("`id` IN ?", ids).Find(&resp).Error
	return
}



func (m *{{.upperStartCamelObject}}Model) Query(filters map[string]interface{}, sort []*model.SortSpec, limit int) (bean []*{{.upperStartCamelObject}}, err error) {
	bean = make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	
	limit = mysql.LimitMax(limit)
	sorts, err := mysql.BuildSort(sort, columns)
	if err != nil {
		return
	}
	sess := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where(cond, values...).Limit(limit)
	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}
	err = sess.Find(&bean).Error
	return
}


func (m *{{.upperStartCamelObject}}Model)Page(query *model.PageQuery, bean []*{{.upperStartCamelObject}}) (page *model.Page, err error) {
	bean = make([]*{{.upperStartCamelObject}},0)
	columns, err := mysql.GetTableColumns(m.conn, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(query.Filters, columns)
	if err != nil {
		return
	}
	
	limit, offset := mysql.BuildLimit(query)
	sorts, err := mysql.BuildSort(query.Sort, columns)
	if err != nil {
		return
	}
	sess := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where(cond, values...).Limit(limit).Offset(offset)
	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}
	err = sess.Find(&bean).Error
	var maxCount int64
	err = sess.Count(&maxCount).Error
	//content := reflectUtils.MakeSlicePtr(bean, 0, 0)
	//total, err := sess.FindAndCount(content)
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


{{if .status}}
func (m *{{.upperStartCamelObject}}Model) Cursor(query *model.CursorQuery, bean []*{{.upperStartCamelObject}}) (cursor *model.Cursor, err error) {
	bean = make([]*{{.upperStartCamelObject}},0)
	columns, err := mysql.GetTableColumns(m.conn, bean)

	if err != nil {
		return
	}
	cond,values, err := mysql.BuildWhere(query.Filters, columns)
	if err != nil {
		return
	}
	var orderBy string

	sess := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where(cond,values...).Limit(int(query.Size) + 1)

	if query.Direction == 0 {
		for _, k := range query.CursorSort {
			if _, ok := columns[k.Property]; !ok {
				err = xerr.NewError(xerr.ERR_DB_UNKNOWN_FIELD, nil, k.Property)
				return
			}
			switch k.Type {
			case model.SortType_DSC:
				orderBy = fmt.Sprintf("%s %s", k.Property, "ASC")

			default:
				orderBy = fmt.Sprintf("%s %s", k.Property, "DESC")

			}
			sess = sess.Order(orderBy)
		}

	} else {
		for _, k := range query.CursorSort {
			if _, ok := columns[k.Property]; !ok {
				err = xerr.NewError(xerr.ERR_DB_UNKNOWN_FIELD, nil, k.Property)
				return
			}
			switch k.Type {
			case model.SortType_DSC:
				orderBy = fmt.Sprintf("%s %s", k.Property, "DESC")

			default:
				orderBy = fmt.Sprintf("%s %s", k.Property, "ASC")

			}
			sess = sess.Order(orderBy)
		}
	}

	err = sess.Find(bean).Error

	var maxCount int64
	err = sess.Count(&maxCount).Error
	if err != nil {
		err = xerr.NewError(xerr.ERR_DB_QUERY, err, err.Error())
		return
	}

	var maxId int64 = 0
	var minId int64 = 9223372036854775807

	for _, k := range bean {
		if k.{{.uperStartCamelPrimaryKey}} < minId {
			minId = k.{{.uperStartCamelPrimaryKey}}
		}
		if k.{{.uperStartCamelPrimaryKey}} > maxId {
			maxId = k.{{.uperStartCamelPrimaryKey}}
		}
	}

	var hasMore bool
	if int32(len(bean)) > query.Size {
		hasMore = true
	}

	cursor = &model.Cursor{
		Direction: query.Direction,
		Size:      query.Size,
		HasMore:   hasMore,
		Content:   bean,
		MinCursor: minId,
		MaxCursor: maxId,
	}
	return
}
{{end}}

