include ../make/Makefile
NAME=tor-browser
VERSION=11.5a1

verify-hash:
	bash download_and_verify_hash $(VERSION)

