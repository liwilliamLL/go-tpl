func (m *{{.upperStartCamelObject}}Model)FindOne({{.lowerStartCamelPrimaryKey}} {{.dataType}}) (resp *{{.upperStartCamelObject}}, err error){
	resp = &{{.upperStartCamelObject}}{}
	err =  m.conn.GetEngine().Debug().Table(m.table).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).First(resp).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) FindInBatches(ids []int64) (resp []*{{.upperStartCamelObject}}, err error) {
	resp = make([]*{{.upperStartCamelObject}}, 0)
	err = m.conn.GetEngine().Debug().Table(m.table).Where("`id` IN ?", ids).Find(&resp).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) FindOneByWhere(filters map[string]interface{}) (resp *{{.upperStartCamelObject}}, err error) {

	columns, err := mysql.GetTableColumns(m.conn, m.table, &{{.upperStartCamelObject}}{})
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	resp = &{{.upperStartCamelObject}}{}
	err =  m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).First(resp).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) Count(filters map[string]interface{}) (count int64, err error) {
	columns, err := mysql.GetTableColumns(m.conn, m.table, &{{.upperStartCamelObject}}{})
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}

	err = m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).Count(&count).Error
	return
}


func (m *{{.upperStartCamelObject}}Model) QuerySum(filters map[string]interface{},sumKey string) (num int, err error) {
	columns, err := mysql.GetTableColumns(m.conn, m.table, &{{.upperStartCamelObject}}{})
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}


	err = m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).Pluck("COALESCE(SUM("+sumKey+"), 0) as num", &num).Error
	return
}


func (m *{{.upperStartCamelObject}}Model) Query(filters map[string]interface{}, sort []*model.SortSpec, limit int) (bean []*{{.upperStartCamelObject}}, err error) {
	bean = make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, m.table, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	
	{{if .status}}
	if sort == nil || len(sort) == 0 {
		sort = []*model.SortSpec{
			{
				Property: "{{.lowerStartCamelPrimaryKey}}",
				Type: model.SortType_DSC,
				IgnoreCase: false,
			},
		}
	}
	{{end}}
	limit = mysql.LimitMax(limit)
	sorts, err := mysql.BuildSort(sort, columns)
	if err != nil {
		return
	}
	sess := m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).Limit(limit)
	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}
	err = sess.Find(&bean).Error
	return
}


func (m *{{.upperStartCamelObject}}Model)Page(query *model.PageQuery, bean *[]*{{.upperStartCamelObject}}) (page *model.Page, err error) {
	if bean == nil {
		bean = &[]*{{.upperStartCamelObject}}{}
	}
	columns, err := mysql.GetTableColumns(m.conn, m.table, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(query.Filters, columns)
	if err != nil {
		return
	}
	
	{{if .status}}
	if query.Sort == nil || len(query.Sort) == 0 {
		query.Sort = []*model.SortSpec{
			{
				Property: "{{.lowerStartCamelPrimaryKey}}",
				Type: model.SortType_DSC,
				IgnoreCase: false,
			},
		}
	}
	{{end}}
	limit, offset := mysql.BuildLimit(query)
	sorts, err := mysql.BuildSort(query.Sort, columns)
	if err != nil {
		return
	}
	sess := m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...)
	if sorts != nil {
		for _, s := range sorts {
			sess = sess.Order(s)
		}
	}

	err = sess.Limit(limit).Offset(offset).Find(&bean).Error
	//content := reflectUtils.MakeSlicePtr(bean, 0, 0)
	//total, err := sess.FindAndCount(content)
	if err != nil {
		err = xerr.NewError(xerr.ERR_DB_QUERY, err, err.Error())
		return
	}
	var maxCount int64
	err = sess.Limit(-1).Offset(-1).Count(&maxCount).Error
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
func (m *{{.upperStartCamelObject}}Model) CursorAll(filters map[string]interface{}, sort []*model.SortSpec) (bean []*{{.upperStartCamelObject}}, err error) {
	var cursor *model.Cursor
	bean = make([]*{{.upperStartCamelObject}}, 0)
	current, hasMore, maxCursor := 0, true, int64(0)

	for current < 1000 && hasMore {
		_bean := make([]*{{.upperStartCamelObject}}, 0)
		query := &model.CursorQuery{
			Filters:    filters,
			Cursor:     maxCursor,
			CursorSort: sort,
			Size:       1000,
			Direction:  0,
		}
		cursor, err = m.Cursor(query, &_bean)
		if err != nil {
			return nil, err
		}
		bean = append(bean, _bean...)
		if !cursor.HasMore {
			break
		}

		max, ok := cursor.MaxCursor.(int64)
		if ok {
			maxCursor = max
		} else {
			break
		}

		current += 1
	}

	return
}

func (m *{{.upperStartCamelObject}}Model) Cursor(query *model.CursorQuery, bean *[]*{{.upperStartCamelObject}}) (cursor *model.Cursor, err error) {
	if bean ==nil{
		bean = &[]*{{.upperStartCamelObject}}{}
	}
	columns, err := mysql.GetTableColumns(m.conn, m.table, bean)

	if query.CursorSort == nil || len(query.CursorSort) == 0 {
		query.Direction = 0
		query.CursorSort = []*model.SortSpec{
			&model.SortSpec{
				Property: "{{.lowerStartCamelPrimaryKey}}",
				Type:     model.SortType_ASC,
			},
		}
	}

	if err != nil {
		return
	}
	cond,values, err := mysql.BuildWhere(query.Filters, columns)
	if err != nil {
		return
	}
	var orderBy string

	sess := m.conn.GetEngine().Debug().Table(m.table).Where(cond,values...)

	if query.Direction == 0 {
		sess.Where("{{.originalPrimaryKey}} > ?", query.Cursor)
		for _, k := range query.CursorSort {
			if _, ok := columns[k.Property]; !ok {
				err = xerr.NewError(xerr.ERR_DB_UNKNOWN_FIELD, nil, k.Property)
				return
			}
			switch k.Type {
			case model.SortType_ASC:
				orderBy = fmt.Sprintf("%s %s", k.Property, "ASC")

			default:
				orderBy = fmt.Sprintf("%s %s", 
				k.Property, "DESC")

			}
			sess = sess.Order(orderBy)
		}

	} else {
		sess.Where("{{.originalPrimaryKey}} < ?", query.Cursor)
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

	sess.Limit(int(query.Size) + 1)
	err = sess.Find(bean).Error

	var maxCount int64
	err = sess.Count(&maxCount).Error
	if err != nil {
		err = xerr.NewError(xerr.ERR_DB_QUERY, err, err.Error())
		return
	}

	var hasMore bool
	if int32(len(*bean)) > query.Size {
		hasMore = true
		*bean = (*bean)[0:query.Size]
	}

	var maxId int64 = 0
	var minId int64 = 9223372036854775807

	for _, k := range *bean {
		if k.{{.uperStartCamelPrimaryKey}} < minId {
			minId = k.{{.uperStartCamelPrimaryKey}}
		}
		if k.{{.uperStartCamelPrimaryKey}} > maxId {
			maxId = k.{{.uperStartCamelPrimaryKey}}
		}
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

