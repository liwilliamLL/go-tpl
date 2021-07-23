package {{.pkg}}

import (
	"dao.erp/{{.pkg}}/dto"
	"git.orderc.vip/base/gozero-base/provider/mysql"
	{{if .withRedis}}"git.orderc.vip/base/gozero-base/provider/redisclient"{{end}}
)


type (
	{{.upperStartCamelObject}}Dao struct {
		{{range .fields -}}
		{{.name}}Model                  *dto.{{.structName}}Model // {{.comment}}
		{{end}}
		{{if .withMerge}}
		Tables map[string]*dto.{{ with $n := index .fields 0 }}{{ $n.structName }}{{ end }}Model
		{{end}}
	}
)

func New{{.upperStartCamelObject}}Dao(config *mysql.Config{{if .withRedis}}, redisCfg *redisclient.Config{{end}}) *{{.upperStartCamelObject}}Dao {
	dataSource, err := mysql.NewDataSource(config)
	if err != nil{
		panic(err)
	}
    {{if .withRedis}}
    redisCli := redisclient.NewRedisClient(redisCfg.Addr, redisCfg.Pass, redisCfg.DbName)
	if err != nil {
		panic(err)
	}
    {{end}}
	dao := &{{.upperStartCamelObject}}Dao{
		{{range .fields -}}
		{{.name}}Model: dto.New{{.structName}}Model("{{.tableName}}", dataSource{{if .withRedis}}, redisCli{{end}}),
		{{end }}
	}
	{{if .withMerge}}
	dao.Tables = map[string]*{{ with $n := index .fields 0 }}{{ $n.structName }}{{ end }}Model{
		{{range .fields -}}
		"{{.tableName}}": dao.{{.name}}Model,
		{{end }}
	}
	{{end}}
	
	return dao
}