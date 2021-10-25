module "test" {
    source      = "../01_module"

    region      = "ap-northeast-1"
    vpc_cidr    = "10.1.0.0/16"
    zones       = ["a","c"]
    pub_sub     = ["10.1.0.0/24","10.1.2.0/24"]
    pri_sub     = ["10.1.1.0/24","10.1.3.0/24"]
    
    # Instance Option
    pri_ip      = "10.1.0.11"
    ami_type    = "ami-0701e21c502689c31"
    ins_type    = "t2.micro"
    keyname     = "tf key"
    keypath     = file("../id_rsa.pem.pub")
    usrdata     = file("../install.sh")

    # Database Option
    database = {
        storage         = 10
        eng             = "mysql"
        eng_ver         = "8.0"
        ins_class       = "db.t2.micro"
        name            = "wordpress"
        idtf            = "test-db"
        dbusr           = "root"
        dbpswd          = "It12345!"
        para            = "default.mysql8.0"
    }
}