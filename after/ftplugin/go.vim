set shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab autoindent smartindent

setlocal path=.,**,$GOPATH/src
setlocal include=^\\s*import\\s*[\"']\\zs[^\"']*

compiler go

