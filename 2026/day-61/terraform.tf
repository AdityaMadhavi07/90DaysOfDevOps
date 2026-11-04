/*
block parameters{
    arguments
}

hashicorp configuration language

blocks:
    - resource
    - output
    - variable
    - data
    - terraform

parameters:
    - resource name
    - resource type

arguments:
- configurations

*/

resource aws_s3_bucket my_s3_bucket{

bucket = "udaan-demo-bucket"

}


