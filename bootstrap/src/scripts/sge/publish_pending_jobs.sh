#!/bin/sh

# Copyright 2013-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the
# License. A copy of the License is located at
#
# http://aws.amazon.com/asl/
#
# or in the "LICENSE.txt" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES 
# OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions and
# limitations under the License.

. /opt/cfncluster/cfnconfig

ec2_region_url="http://169.254.169.254/latest/meta-data/placement/availability-zone"
ec2_region=$(curl --retry 3 --retry-delay 0 --silent --fail ${ec2_region_url})

. /opt/sge/default/common/settings.sh
pending=$(qstat -g d -s p -u '*' | tail -n+3 | awk '$5 == "qw" {total = total+ $8} END {print total}')

if [ "${pending}x" == "x" ]; then
pending=0
fi

aws --region ${ec2_region%?} cloudwatch put-metric-data --namespace cfncluster --metric-name pending --unit Count --value ${pending} --dimensions Stack=${stack_name}