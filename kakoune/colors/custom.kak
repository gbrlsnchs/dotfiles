declare-option -hidden str bg_color %sh{printf "rgb:%s\n" "$BG_COLOR"}
declare-option -hidden str fg_color %sh{printf "rgb:%s\n" "$FG_COLOR"}

# code
set-face global value              magenta+b
set-face global type               bright-blue+b
set-face global variable           blue
set-face global module             bright-cyan
set-face global function           bright-magenta+b
set-face global string             bright-green
set-face global keyword            bright-red
set-face global operator           default
set-face global attribute          magenta+b
set-face global comment            white+i
set-face global documentation      comment
set-face global meta               bright-yellow+b
set-face global builtin            cyan+b

# markup
set-face global title              blue+b
set-face global header             blue
set-face global bold               bright-blue+b
set-face global italic             bright-blue+i
set-face global mono               bright-cyan
set-face global block              cyan
set-face global link               bright-cyan
set-face global bullet             yellow
set-face global list               green

# builtin
set-face global Default            %sh{ printf "%s,%s\n" "$kak_opt_fg_color" "$kak_opt_bg_color" }
set-face global PrimarySelection   black,white+fg
set-face global SecondarySelection black,magenta+fg
set-face global PrimaryCursor      %sh{ printf "%s,yellow+fg\n" "$kak_opt_bg_color" }
set-face global SecondaryCursor    black,bright-green+fg
set-face global PrimaryCursorEol   bright-black,white+fg
set-face global SecondaryCursorEol bright-black,bright-white+fg
set-face global LineNumbers        %sh{ printf "white,%s\n" "$kak_opt_bg_color" }
set-face global LineNumberCursor   %sh{ printf "bright-white,%s+b\n" "$kak_opt_bg_color" }
set-face global LineNumbersWrapped black,black
set-face global MenuBackground     black,white
set-face global MenuForeground     black,yellow
set-face global MenuInfo           black+bi
set-face global Information        black,yellow
set-face global Error              red,default+b
set-face global StatusLine         white,black+b
set-face global StatusLineMode     blue
set-face global StatusLineInfo     bright-yellow
set-face global StatusLineValue    green
set-face global StatusCursor       black,yellow
set-face global Prompt             yellow+b
set-face global MatchingChar       black,bright-blue+fg
set-face global BufferPadding      %sh{ printf"black,%s\n" "$kak_opt_bg_color" }
set-face global Whitespace         blue+f
set-face global InlayHint          white,black
set-face global SnippetsNextPlaceholders  blue,default
set-face global SnippetsOtherPlaceholders bright-black,default
