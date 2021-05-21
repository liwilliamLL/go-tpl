
func (m *{{.upperStartCamelObject}}Model) Delete({{.lowerStartCamelPrimaryKey}} {{.dataType}}) (rowsAffected int64, err error) {
	ret := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("1=1 AND  {{.originalPrimaryKey}} = ?", {{.lowerStartCamelPrimaryKey}}).Delete(&{{.upperStartCamelObject}}{})
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected, err
}


func (m *{{.upperStartCamelObject}}Model) DeleteBatches(ids []int64) (rowsAffected int64, err error) {
	if len(ids) > 100 {
		return 0, xerr.NewError(xerr.ERR_DB_QUERY, "ids length error")
	}

	ret := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where("1=1 AND {{.originalPrimaryKey}} IN ?", ids).Delete(&{{.upperStartCamelObject}}{})
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected, err
}


func (m *{{.upperStartCamelObject}}Model) DeleteByWhere(filters map[string]interface{}) (rowsAffected int64, err error) {

	if filters == nil || len(filters) == 0 {
		return 0, xerr.NewError(xerr.ResCodeIllegalOp)
	}

	bean := make([]*{{.upperStartCamelObject}}, 0)
	columns, err := mysql.GetTableColumns(m.conn, bean)
	if err != nil {
		return
	}

	cond, values, err := mysql.BuildWhere(filters, columns)
	if err != nil {
		return
	}

	ret := m.conn.GetEngine().Model(&{{.upperStartCamelObject}}{}).Where(cond, values...).Delete(&{{.upperStartCamelObject}}{})
	if ret.Error != nil {
		return 0, err
	}
	return ret.RowsAffected, err
}
