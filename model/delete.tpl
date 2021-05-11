
func (m *{{.upperStartCamelObject}}Model) Delete({{.lowerStartCamelPrimaryKey}} {{.dataType}})(err error) {
	err = m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("1=1 AND  {{.originalPrimaryKey}} = ?",{{.lowerStartCamelPrimaryKey}}).Delete(&{{.upperStartCamelObject}}{}).Error
	return
}


func (m *{{.upperStartCamelObject}}Model) DeleteBatches(ids []int64) (rowsAffected int64, err error) {
	if len(ids)>100{
		return 0,xerr.NewError(xerr.ERR_DB_QUERY,"ids length error")
	}
	ret := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("1= 1 AND {{.originalPrimaryKey}} IN ?", ids).Delete(&{{.upperStartCamelObject}}{})
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected, err
}



