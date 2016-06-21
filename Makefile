BUCKET=s3://languageorstartup.com

all:
	git push origin master
	s3cmd mb $(BUCKET)
	s3cmd put --acl-public --guess-mime-type --recursive * $(BUCKET)
