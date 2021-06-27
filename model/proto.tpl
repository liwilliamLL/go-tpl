syntax = "proto3";
package {{.Models}};

// {{.TableName}}.proto
{{range .MessageList }}
// {{.Comment}}
message T_{{.Name}} {
{{range .MessageDetail }}    // {{.Comment}}
    // @inject_tag: json:"{{.AttrName -}}"
    {{.TypeName}} {{.AttrName}} = {{.Num}};       
{{ end }}
}
{{ end }}

// {{.TableName}}.proto
{{range .MessageList }}
// {{.Comment}}
message T_Update_{{.Name}} {
{{range .MessageDetail }}    // {{.Comment}}
    {{if .NotKey}}optional {{end}}{{.TypeName}} {{.AttrName}} = {{.Num}};       
{{ end }}
}
{{ end }}