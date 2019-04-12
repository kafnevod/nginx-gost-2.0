# Add to PATH CryptoPro SCP utilities paths 

p="$(find /opt/cprocsp/ -name amd64 | grep bin | tr '\n' ':' 2>/dev/null|tr '\n' ':')"

if [ -n "$p" -a -z "$(echo $PATH|grep "$p")" ]; then
	export PATH="$p$PATH"
fi
