# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  tags = merge(
    var.tags,
    {
      Name = format("%s-VPC", var.name)
    },
  )

}
# Get list of availability zones
data "aws_availability_zones" "available" {
    state = "available"
}



# Create public subnets
resource "aws_subnet" "public" { #so if preffered is null the number of subnets is = to AZ, could be 3
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  #cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index)
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.tags,
    {
      Name = format("Public-Subnet-%s", count.index + 1) #Inex starts with 0
    } 
  )
}

# Create private subnets 
resource "aws_subnet" "private" {
  count                   = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets   
  vpc_id                  = aws_vpc.main.id
  #cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + 2)
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.tags,
    {
      Name = format("Private-Subnet-%s", count.index + 1) #Inex starts with 0
    } 
  )

}




