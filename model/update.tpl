
func (m *{{.upperStartCamelObject}}Model)UpdateByMap({{.lowerStartCamelPrimaryKey}} {{.dataType}} , maps map[string]interface{}) (err error){
	err = m.conn.GetEngine().Debug().Table(m.table).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Updates(maps).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) UpdateByMapReCount({{.lowerStartCamelPrimaryKey}} {{.dataType}} , maps map[string]interface{}) (updateNum int64, err error) {
	ret := m.conn.GetEngine().Debug().Table(m.table).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Updates(maps)
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected , ret.Error 
}


func (m *{{.upperStartCamelObject}}Model) UpdateById({{.lowerStartCamelPrimaryKey}} {{.dataType}} , data *{{.upperStartCamelObject}}) (err error) {
	err = m.conn.GetEngine().Debug().Table(m.table).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Updates(data).Error
	return
}


func (m *{{.upperStartCamelObject}}Model) UpdateByIdReCount({{.lowerStartCamelPrimaryKey}} {{.dataType}} , data *{{.upperStartCamelObject}}) (updateNum int64, err error) {
	ret := m.conn.GetEngine().Debug().Table(m.table).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Updates(data)
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected , ret.Error 
}


func (m *{{.upperStartCamelObject}}Model) Update( data *{{.upperStartCamelObject}}) (err error) {
	err = m.conn.GetEngine().Debug().Table(m.table).Updates(data).Error
	return
}


func (m *{{.upperStartCamelObject}}Model) UpdateMapByWhere(filters map[string]interface{}, maps map[string]interface{}) (err error) {
	bean := make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, m.table, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	err = m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).Updates(maps).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) UpdateMapByWhereReCount(filters map[string]interface{}, maps map[string]interface{}) (updateNum int64, err error) {
	bean := make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, m.table, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	ret := m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).Updates(maps)
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected , ret.Error 
}


func (m *{{.upperStartCamelObject}}Model) UpdateDataByWhere(filters map[string]interface{}, data *{{.upperStartCamelObject}}) (err error) {
	bean := make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, m.table, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	err = m.conn.GetEngine().Debug().Table(m.table).Where(cond, values...).Updates(data).Error
	return
}