
func (m *{{.upperStartCamelObject}}Model) FindOneBy{{.upperField}}({{.in}}) (resp *{{.upperStartCamelObject}}, err error) {
	resp = &{{.upperStartCamelObject}}{}
	err =  m.conn.GetEngine().Model(resp).Where("{{.originalField}} = ? limit 1",{{.lowerStartCamelField}}).First(resp).Error
	return
}

