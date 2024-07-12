#!/bin/bash

ver=v0.15.3
curl -s https://repo.haplat.net/go/golang.org/x/tools/gopls/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v golang.org/x/tools/gopls@$ver"
read -rp "OK?"
go install -v golang.org/x/tools/gopls@$ver
echo

ver=v1.6.0
curl -s https://repo.haplat.net/go/github.com/cweill/gotests/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v github.com/cweill/gotests/gotests@$ver"
read -rp "OK?"
go install -v github.com/cweill/gotests/gotests@$ver
echo

ver=v1.16.0
curl -s https://repo.haplat.net/go/github.com/fatih/gomodifytags/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v github.com/fatih/gomodifytags@$ver"
read -rp "OK?"
go install -v github.com/fatih/gomodifytags@$ver
echo

ver=v1.2.0
curl -s https://repo.haplat.net/go/github.com/josharian/impl/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v github.com/josharian/impl@$ver"
read -rp "OK?"
go install -v github.com/josharian/impl@$ver
echo

ver=v1.0.0
curl -s https://repo.haplat.net/go/github.com/haya14busa/goplay/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v github.com/haya14busa/goplay/cmd/goplay@$ver"
read -rp "OK?"
go install -v github.com/haya14busa/goplay/cmd/goplay@$ver
echo

ver=v1.22.1
curl -s https://repo.haplat.net/go/github.com/go-delve/delve/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v github.com/go-delve/delve/cmd/dlv@$ver"
read -rp "OK?"
go install -v github.com/go-delve/delve/cmd/dlv@$ver
echo

ver=v0.4.7
curl -s https://repo.haplat.net/go/honnef.co/go/tools/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v honnef.co/go/tools/cmd/staticcheck@$ver"
read -rp "OK?"
go install -v honnef.co/go/tools/cmd/staticcheck@$ver
echo

ver=v0.3.28
curl -s https://repo.haplat.net/go/github.com/google/gops/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v github.com/google/gops@$ver"
read -rp "OK?"
go install -v github.com/google/gops@$ver
echo

ver=v0.0.0-20210508222113-6edffad5e616
curl -s https://repo.haplat.net/go/golang.org/x/lint/@v/ | grep 'v[0-9a-f.-]*info'
echo "go install -v golang.org/x/lint/golint@$ver"
read -rp "OK?"
go install -v golang.org/x/lint/golint@$ver
echo
