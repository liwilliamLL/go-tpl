
func (m *{{.upperStartCamelObject}}Model)UpdateByMap({{.lowerStartCamelPrimaryKey}} {{.dataType}} , maps map[string]interface{}) (err error){
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Updates(maps).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) UpdateById(id int64, data *{{.upperStartCamelObject}}) (err error) {
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("`id` = ?", id).Updates(data).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) Update( data *{{.upperStartCamelObject}}) (err error) {
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Updates(data).Error
	return
}


func (m *{{.upperStartCamelObject}}Model) UpdateMapByWhere(filters map[string]interface{}, maps map[string]interface{}) (err error) {
	bean := make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where(cond, values...).Updates(maps).Error
	return
}

func (m *{{.upperStartCamelObject}}Model) UpdateDataByWhere(filters map[string]interface{}, data *DicCity) (err error) {
	bean := make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where(cond, values...).Updates(data).Error
	return
}