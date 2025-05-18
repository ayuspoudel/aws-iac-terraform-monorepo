data "external" "public_ip" {
  program = ["bash", "${path.root}/scripts/get_my_ip.sh"]
}