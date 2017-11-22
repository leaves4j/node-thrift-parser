
start = Document

Document       
  = __ headers:(__ v:Header __ {return v})* definitions:(__ v:Definition __ {return v})* __ {
    return {headers, definitions}
  }

//Header
Header          
  =  Include / Namespace

Include         
  = 'include' _ path:Literal {
    return {type: 'include', path}
  }

Namespace       
  = 'namespace' _ namespaceScope:NamespaceScope _ identifier:Identifier {
    return {type: 'namespace', namespaceScope, identifier}
  }
NamespaceScope 'namespaceScope'
  = '*' / Identifier

//Definition
Definition     
   =  Const / Typedef / Enum /  Struct / Union / Exception / Service

Const           
  =  'const' _ fieldType:FieldType _ identifier:Identifier _* '=' _* value:ConstValue _? ListSeparator? {
    return {
      type: 'const',
      fieldType,
      identifier,
      value
    }
  }

Typedef         
  = 'typedef' _ definitionType:DefinitionType _ identifier:Identifier {
    return {
      type: 'typedef',
      definitionType,
      identifier
    }
  }

Enum            
  = 'enum' _ identifier:Identifier __ '{' enumFields:EnumField* '}' {
    return {
      type: 'enum',
      identifier,
      enumFields
    }
  }

Struct         
  = 'struct' _ identifier:Identifier (_ 'xsd_all')? __ '{' fields:Field* '}' {
    return {
      type: 'struct',
      identifier,
      fields
    }
  }
Union          
  = 'union' _ identifier:Identifier (_ 'xsd_all')? __ '{' fields:Field* '}' {
    return {
      type: 'union',
      identifier,
      fields
    }  
  }
Exception      
  = 'exception' _ identifier:Identifier __ '{' fields:Field* '}' {
    return {
      type: 'exception',
      identifier,
      fields
    }  
  }
Service         
  = 'service' _ identifier:Identifier extendIdentifier:(_ 'extends' _ v:Identifier {return v})? __ '{' functions:Function* '}' {
    return {
      type: 'service',
      identifier,
      extendIdentifier,
      functions
    }
  }

//Field
Field          
  =  __ id:FieldID? option:FieldReq? fieldType:FieldType __ identifier:Identifier defaultValue:(_* '=' _* v:ConstValue {
    return v
  })? (_ XsdFieldOptions)?  ListSeparator? __ {
    return {id, option, fieldType, identifier, defaultValue}
  }

EnumField
  = __ identifier:Identifier enumValue:(_* '=' _* value:Int {
    return value
  })? ListSeparator? __ {
    return {
      type: 'enumField',
      identifier,
      value: enumValue
    }
  }

FieldID         = v:Int ':' _? {return v}
FieldReq        = option:('required' / 'optional' {return text()}) _ {return option}
XsdFieldOptions = 'xsd_optional'? (_ 'xsd_nillable')? (_ XsdAttrs)?
XsdAttrs        = 'xsd_attrs' __ '{' __ Field* __ '}'

//Functions
Function      
  =  __ oneway:(v:'oneway' _ {
    return v
  })? functionType:FunctionType _ identifier:Identifier __ '(' args:Field* ')' throws:Throws? ListSeparator? __ {
    return {
      type: 'function',
      functionType,
      identifier,
      oneway,
      args,
      throws: throws ||[]
    }
  }
FunctionType = 'void' / FieldType
Throws "throws"       
  = __ 'throws' _? '(' fields:Field* ')' __ {
    return fields
  } 

//Types
FieldType       =  ContainerType / BaseType / Identifier
DefinitionType  =  BaseType / ContainerType
BaseType        =  'bool' / 'byte' / 'i8' / 'i16' / 'i32' / 'i64' / 'double' / 'string' / 'binary'
ContainerType   =  MapType / SetType / ListType
MapType         
  = 'map' CppType? '<' keyFieldType:FieldType _? ',' _? valueFieldType:FieldType '>' {
    return {
      type: 'map',
      keyFieldType,
      valueFieldType
    }
  }

SetType        
  = 'set' CppType? '<' fieldType:FieldType '>' {
    return {
      type: 'set',
      fieldType
    }
  }

ListType       
  = 'list' '<' fieldType:FieldType '>' CppType? {
    return {
      type: 'list',
      fieldType
    }
  }
CppType         = 'cpp_type' _ Literal

//Constant Values
ConstValue      
  = Literal / Identifier / ConstMap / ConstList / DoubleConstant / IntConstant 

IntConstant = __ v:Int __ {return v}

DoubleConstant 
  = __ sign:('+' / '-')? digits:Digit+ decimal:('.' decimalDigits:Digit+  {
    return '.' + decimalDigits.join('')
  })? exponent:( ('E' / 'e') Int )? __ {
    return (sign || '') + digits.join('') + (decimal || '') + (exponent ? exponent.join('') : '')
  }

ConstMap        
  = __ '{' values:(key:ConstValue ':' value:ConstValue ListSeparator? {
    return {key, value}
  })* '}' __ {
    return values
  } 

ConstList       
  = __ '[' values:(v:ConstValue ListSeparator? {return v})* ']' __ {
    return values
  }

// Basic Definitions
Literal         
  = (('"' [^"]* '"') / ("'" [^']* "'")) {return text()}
Letter          = [A-Z] / [a-z]
Digit           = [0-9]
ListSeparator "','/';'"   = __ (',' / ';') __
Identifier "identifier"      
  = (Letter / '_') (Letter / Digit / '.' / '_')* {
    return text()
  }
//STIdentifier    =  ( Letter / '_' ) ( Letter / Digit / '.' / '_' / '-' )*
Int     
  = sign:('+' / '-')? digits:Digit+ {
    return (sign || '') + digits.join('')
  }

WhiteSpace "whitespace"
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\u00A0"
  / "\uFEFF"

LineTerminator = [\n\r\u2028\u2029] 
LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

Comment "comment"
  = MultiLineComment
  / SingleLineComment

MultiLineComment = "/*" (!"*/" .)* "*/"
SingleLineBlokComment 'single line blok comment'
  = "/*" (!("*/" / LineTerminator) .)* "*/"
SingleLineComment = ("//" / "#") (!LineTerminator .)*

__ "white space or break line"
 = (WhiteSpace / LineTerminatorSequence / Comment)*

_ 'white space'
 = (WhiteSpace / SingleLineBlokComment)+