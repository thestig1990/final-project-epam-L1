#!/bin/bash

WEBSITE=index.html

# Install Apache HTTP Server 
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd


# Set AWS region
aws configure set default.region eu-central-1

# Copy and unzip build artifact from s3
sudo aws s3 cp s3://"${ARTIFACT}"/"${UNIQUE_IDENTIFIER}"-build-artifacts.zip ./
sudo unzip "${UNIQUE_IDENTIFIER}"-build-artifacts.zip


# Inserting a Private IP DNS name of instance to the index.html file
echo "Private IP DNS name - (hostname -f)" >> $WEBSITE

# Copy index.html file to the /var/www/html directory
cp $WEBSITE /var/www/html