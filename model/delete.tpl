
func (m *{{.upperStartCamelObject}}Model) Delete({{.lowerStartCamelPrimaryKey}} {{.dataType}})(err error) {
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("{{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Delete(&{{.upperStartCamelObject}}{}).Error
	return
}


