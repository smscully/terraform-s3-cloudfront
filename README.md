# Terraform Static S3 Website with CloudFront 
The Terraform scripts in this repository create the resources for a static S3 website with a CloudFront distribution. Components include S3 buckets to store website content and logging data; a CloudFront distribution pointing to the S3 origin bucket; Route 53 records to associate the domain with the CloudFront distribution; and an ACM x.509 certificate to enable secure communications via TLS/SSL.

The architectural diagram below shows the resources created by the script.

![S3-CloudFront diagram](./img/s3-cloudfront.png)

Before launching the script, review the resources that will be created, as the NAT gateways are not free tier eligible. Please refer to the [Amazon Pricing](https://aws.amazon.com/pricing/) page for specific regional pricing.  

## Script Overview
The [main.tf](./main.tf) script calls the `s3_website` module, which creates the AWS resources described below. The root module `variables.tf` file declares the following variables:

|Variable|Description|
|--------|-----------|
|zone_id|ID of the AWS Hosted Zone where the Route 53 records will be created.|
|domain|Domain name of the website.|
|source_files|Directory location of the website files.|
|profile|Profile for the Terraform AWS provider.| 
|env|DevOps environment.|
|region|Region for the Terraform AWS provider.|

Variable values are stored in the `dev.tfvars` file. Following Terraform best practices, variables for other environments should be stored in separate files, e.g. `test.tfvars`, `prod.tfvars`, or similar.

### S3 Buckets
The script creates two S3 Buckets, one for website files and another for log files. For the website files bucket, the script uses a Terraform `for_each` meta-argument to read the contents of the source files directory, and then upload each file to the S3 bucket. The bucket is configured as a static website, with index.html identified as the index document and error.html as the custom error document. Following security best practices, public access is blocked on the bucket, and an IAM policy document is applied, which policy limits access to the CloudFront service. Bucket actions are restricted to GetObject and ListBucket.

To provide a complete stand-alone solution, the Terraform script creates a logging bucket specifically for the CloudFront distribution. The script should be modified to point to an existing logging bucket if preferred. Moreover, the logging bucket `force_destroy` argument is set to `true` so that all of the script resources are deleted when the `terraform destroy` command is issued. To avoid losing log files, this argument can be changed to `false`. 

### CloudFront Distribution
The code uses a `for_each` to create custom error responses for HTTP response codes. All responses return the same error page, following the principle of providing the least information disclosure as possible. (provide link to OWASP)

### Route 53 Records
Two Route 53 records are created, both in the Hosted Zone identified by the `zone_id` variable in the `dev.tfvars` file. The first record added is a CNAME record. This record is created by mapping the name, record, and type fields from the ACM certificate's corresponding CNAME record, which record is automatically created because the ACM certificate's validation method is set to DNS.

The second record added is an A record for the domain identified by the `domain` variable in the `dev.tfvars` file. This record serves as an alias to the CloudFront distribution.

To reduce costs, there is no resource block to create a Hosted Zone. Instead, the script assumes that a Hosted Zone for the primary domain already exits and that the domain being created is a subdomain, e.g. subdomain.primarydomain.com. 

### ACM X.509 Certificate
One X.509 certificate is created for the domain. Because the validation method is DNS, a CNAME record is created for the certificate. (See the [AWS Documentation](https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html) for more information.)

The resource block includes a Terraform `lifecycle` meta-argument that sets `create_before_destroy` to `true`. This prevents any outage when a new certificate replaces an old certificate.

## Getting Started

### Dependencies

+ Terraform (For installation instructions, [click here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).)
+ AWS CLI (For installation instructions, [click here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).)
+ Established connection to an AWS account

### Installation
To install the script, either clone the [terraform-s3-website](.) repo or download the files to the local host. 

## Usage
To run the script, follow standard Terraform practices by navigating to the directory that holds the `main.tf` script, then running the commands to initialize and apply the script:

```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

## License
Licensed under the [GNU General Public License v3.0](./LICENSE).
