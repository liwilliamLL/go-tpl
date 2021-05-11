
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
