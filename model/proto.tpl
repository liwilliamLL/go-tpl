syntax = "proto3";
package {{.Models}};


{{range .MessageList }}
// {{.Comment}}
message {{.Name}} {
{{range .MessageDetail }}    // {{.Comment}}
    {{.TypeName}} {{.AttrName}} = {{.Num}};       
{{ end }}
}
{{ end }}