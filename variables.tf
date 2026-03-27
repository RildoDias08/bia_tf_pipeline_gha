variable "vpc_cidr" {
  type = string
}

variable "subnets_public" {
  type = map(object({
    cidr_block = string
    az = string
    public = bool
  }))
}

variable "subnets_private" {
  type = map(object({
    cidr_block = string
    az = string
    public = bool
  }))
}

