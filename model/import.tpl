import (
	{{if .sql}}"database/sql"{{end}}
	"git.orderc.vip/base/gozero-base/provider/mysql"
	{{range .joins -}}
	{{.aliasPackage}} "{{.package}}"
	{{end}}
	{{if .time}}"time"{{end}}
	{{if .gorm}"gorm.io/gorm"{{end}}
)
