func (m *{{.upperStartCamelObject}}Model)Insert(data *{{.upperStartCamelObject}})(err error){
	return m.conn.GetEngine().Debug().Table(m.table).Create(data).Error
}


func (m *{{.upperStartCamelObject}}Model)InsertList(data []*{{.upperStartCamelObject}})(err error){
	return m.conn.GetEngine().Debug().Table(m.table).Create(data).Error
}
