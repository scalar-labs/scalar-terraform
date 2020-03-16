locals {
  config_path = var.custom_config_path != "" ? var.custom_config_path : "${path.module}/provision"
}

module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "envoy_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo envoy host up"]
  }
}

resource "null_resource" "docker_install" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.envoy_waitfor[count.index].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${module.ansible.remote_playbook_path}",
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, docker-server.yml -e enable_tdagent=${var.enable_tdagent ? 1 : 0} -e monitor_host=monitor.${var.internal_root_dns}",
    ]
  }
}

resource "null_resource" "envoy_tls" {
  count = var.envoy_tls && ! var.envoy_cert_auto_gen ? 1 : 0

  provisioner "local-exec" {
    command = "cp ${var.key} ${path.module}/provision/key.pem"
  }

  provisioner "local-exec" {
    command = "cp ${var.cert} ${path.module}/provision/cert.pem"
  }
}

resource "null_resource" "envoy_container" {
  count      = var.provision_count
  depends_on = [null_resource.envoy_tls]

  triggers = {
    triggers            = null_resource.docker_install.*.id[count.index]
    envoy_image         = var.envoy_image
    envoy_tag           = var.envoy_tag
    envoy_tls           = var.envoy_tls
    envoy_cert_auto_gen = var.envoy_cert_auto_gen
    envoy_port          = var.envoy_port
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p $HOME/provision"]
  }

  provisioner "file" {
    # This ensures the source ends with "/" and copied to the destination as a directory
    # https://www.terraform.io/docs/provisioners/file.html#directory-uploads
    source      = replace(local.config_path, "/\\/?$/", "/")
    destination = "$HOME/provision"
  }

  provisioner "remote-exec" {
    inline = [
      "cd $HOME/provision",
      "echo export ENVOY_CERT_AUTO_GEN=${var.envoy_cert_auto_gen}",
      "echo export ENVOY_IMAGE=${var.envoy_image} > env",
      "echo export ENVOY_TAG=${var.envoy_tag} >> env",
      "echo export ENVOY_CONF=${var.envoy_tls ? "envoy-tls.yaml" : "envoy.yaml"} >> env",
      "echo export ENVOY_PORT=${var.envoy_port} >> env",
      "source ./env",
      "chmod 755 ./auto_gen_cert.sh",
      "./auto_gen_cert.sh",
      "docker-compose up -d",
    ]
  }
}
