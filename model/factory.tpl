package {{.pkg}}

import (
	"dao.erp/{{.pkg}}/dto"
	"git.orderc.vip/base/gozero-base/provider/mysql"
	{{if .withRedis}}"git.orderc.vip/base/gozero-base/provider/redisclient"{{end}}
)


type (
	{{.upperStartCamelObject}}Dao struct {
		{{.def_fields}}
	}
)

func New{{.upperStartCamelObject}}Dao(config *mysql.Config{{if .withRedis}}, redisCfg *redisclient.Config{{end}}) *{{.upperStartCamelObject}}Dao {
	dataSource,err := mysql.NewDataSource(config)
	if err !=nil{
		panic(err)
	}
    {{if .withRedis}}
    redisCli := redisclient.NewRedisClient(redisCfg.Addr, redisCfg.Pass, redisCfg.DbName)
	if err != nil {
		panic(err)
	}
    {{end}}
	return &{{.upperStartCamelObject}}Dao{
		{{.fields}}
	}
}