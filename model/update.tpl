
func (m *{{.upperStartCamelObject}}Model)UpdateByMap({{.lowerStartCamelPrimaryKey}} {{.dataType}} , maps map[string]interface{}) (err error){
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Updates(maps).Error
	return
}


