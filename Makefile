sync:
	# s3cmd sync --dry-run --skip-existing --delete-removed public/ s3://wolfe.id.au
	hugo
	s3cmd sync --delete-removed public/ s3://wolfe.id.au --acl-public
