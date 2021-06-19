import (
	{{if .sql}}"database/sql"{{end}}
	"git.orderc.vip/base/gozero-base/model"
	"git.orderc.vip/base/gozero-base/provider/mysql"
	"git.orderc.vip/base/gozero-base/xerr"
	{{range .joins -}}
	{{.aliasPackage}} "{{.package}}"
	{{end -}}
	{{if .status}}"fmt"{{end}}
	{{if .time}}"time"{{end}}
	{{if .gorm}}"gorm.io/gorm"{{end}}
)
