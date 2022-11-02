import boto3

EC2_RESOURCE = boto3.resource('ec2')
new_ec2 = EC2_RESOURCE.create_instances(
    LaunchTemplate={'LaunchTemplateId': 'lt-'},
    MinCount=2,
    MaxCount=2,
    SecurityGroupIds=['sg-'],
    SubnetId='subnet-'

    )


for instance in new_ec2:
    print(instance.id)