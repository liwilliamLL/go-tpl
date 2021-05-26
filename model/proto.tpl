syntax = "proto3";
package {{.Models}};

// {{.TableName}}.proto
{{range .MessageList }}
// {{.Comment}}
message T_{{.Name}} {
{{range .MessageDetail }}    // {{.Comment}}
    {{.TypeName}} {{.AttrName}} = {{.Num}};       
{{ end }}
}
{{ end }}