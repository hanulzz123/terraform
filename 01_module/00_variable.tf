# Network Variable

variable name {
	description = "Name Index"
	type		= string
	default		= "jypark"
}

variable region {
	description = "Select Region"
	type        = string
	default     = "ap-northeast-2"
}

variable vpc_cidr {
	description = "VPC CIDR"
	type        = string
	default     = "10.0.0.0/16"
}

variable pub_sub {
	description = "Public Subnet"
	type        = list
}

variable pri_sub {
	description = "Private Subnet"
	type        = list
}

variable zones {
	description = "Availability Zone"
	type        = list
} 

variable all_cidr4 {
	description = "ALL Traffic CIDR IPv4"
	type        = string
	default     = "0.0.0.0/0"
}

variable all_cidr6 {
	description = "ALL Traffic CIDR IPv6"
	type        = string
	default     = "::/0"
}

# Protocol & Port Variable

variable protocol {
	description = "Protocol Name"
	type        = map(string)
	default     = {
		tcp		= "tcp"
		udp		= "udp"
		http	= "HTTP"
	}
}

variable port_num {
	description = "Port Number"
	type		= map(number)
	default		= {
		http	= 80
		https	= 443
		ssh 	= 22
		all 	= 0
		sql		= 3306
	}
}

# Instance Variable

variable pri_ip {
	description = "Deploy Private IP for Instance"
	type        = string
}

variable ami_type {
	description = "Select Instance AMI"
	type        = string
}

variable ins_type {
	description = "Select Instance Type"
	type        = string
}

variable keyname {
	description = "Public Key Name"
	type		= string
}

variable keypath {
	description = "Public Key Path"
	type 		= string
}

variable usrdata {
	description = "Select User Data"
	type 		= string
}

# DB Variable

variable database {
	description = "Database Setting"
	type 		= object({
		storage			= number
		eng				= string
		eng_ver			= string
		ins_class		= string
		idtf			= string
		name			= string
		dbusr			= string
		dbpswd			= string
		para 			= string
	})
}