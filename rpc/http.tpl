{{.head}}

package server

import (
	"github.com/gin-gonic/gin"
	"net/http"
	{{.imports}}
)




func (s *{{.server}}Server)CreateRouter(router *gin.Engine,c config.Config)(){
	if c.HttpStatus {
        {{.routers}}
		router.Run(c.HttpPort)
	}
}


{{.funcs}}
