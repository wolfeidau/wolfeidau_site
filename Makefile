sync:
	hugo
	s3cmd sync --delete-removed public/ s3://www.wolfe.id.au --acl-public
