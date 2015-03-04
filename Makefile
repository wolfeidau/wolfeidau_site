sync:
	# s3cmd sync --dry-run --skip-existing --delete-removed public/ s3://www.wolfe.id.au
	hugo
	s3cmd sync --delete-removed public/ s3://www.wolfe.id.au --acl-public
