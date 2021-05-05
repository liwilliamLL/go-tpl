{{if .hasComment}}{{.comment}}{{end}}

func (s  *{{.server}}Server) {{.method}}Http (ctx *gin.Context){
	var in {{.request}}
	err := ctx.BindJSON(&in)
	if err!=nil{
		return
	}
	var rsp {{.response}}
	rsp ,err = s.{{.method}}(ctx,in)
	if err!=nil{
		ctx.JSON(http.StatusOK,err)
		return
	}
	ctx.JSON(http.StatusOK, rsp)
	return
}
