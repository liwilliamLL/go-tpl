import (
    {{if .withRedis}}"errors"{{end}}
	{{if .sql}}"database/sql"{{end}}
	"git.orderc.vip/base/gozero-base/model"
	"git.orderc.vip/base/gozero-base/provider/mysql"
	"git.orderc.vip/base/gozero-base/xerr"
	{{if .withRedis}}"github.com/go-redis/redis/v8"{{end}}
	{{if .withRedis}}"git.orderc.vip/base/gozero-base/redisflake"{{end}}
	{{range .joins -}}
	{{.aliasPackage}} "{{.package}}"
	{{end -}}
	{{if .status}}"fmt"{{end}}
	{{if .time}}"time"{{end}}
	{{if .gorm}}"gorm.io/gorm"{{end}}
)
