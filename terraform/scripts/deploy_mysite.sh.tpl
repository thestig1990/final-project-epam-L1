#!/bin/bash

set -x

WEBSITE="index.html"
ARTIFACT="thestig-artifact-bucket"
UNIQUE_IDENTIFIER="fp-mysite"

# Install Apache HTTP Server 
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd


# Set AWS region
aws configure set default.region eu-central-1


# Copy and unzip build artifact from s3
sudo echo "website - ${WEBSITE}"
sudo echo "S3 bucket name - ${ARTIFACT}"
sudo echo "UNIQUE_IDENTIFIER - ${UNIQUE_IDENTIFIER}"
sudo aws s3 cp s3://${ARTIFACT}/${UNIQUE_IDENTIFIER}-build-artifacts.zip ./
sudo unzip ${UNIQUE_IDENTIFIER}-build-artifacts.zip


# Inserting a Private IP DNS name of instance to the index.html file
echo "Private IP DNS name - $(hostname -f)" >> $WEBSITE


# Copy index.html file to the /var/www/html directory
cp $WEBSITE /var/www/html