#!/bin/bash

UNIQUE_IDENTIFIER=$1

DOMAIN=$(aws elb describe-load-balancers --query "LoadBalancerDescriptions[?LoadBalancerName == '${UNIQUE_IDENTIFIER}-webserver'].DNSName" --output text)


echo "Application successfully deployed! Please visit http://$DOMAIN in your browser to view it."