module "ansible" {
  source = "../../../provision/ansible"
}

resource "tls_private_key" "cassy_private_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "cassy_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
    vm_id    = var.vm_ids[count.index]
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo cassy host up"]
  }
}

resource "null_resource" "docker_install" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.cassy_waitfor[count.index].id
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = true
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${module.ansible.remote_playbook_path}/playbooks",
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, docker-server.yml -e enable_tdagent=${var.enable_tdagent ? 1 : 0} -e monitor_host=monitor.${var.internal_domain}",
    ]
  }
}

resource "null_resource" "cassy_container" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.docker_install[0].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/provision"
    destination = "$HOME"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.cassy_private_key.private_key_pem}' > $HOME/.ssh/cassy.pem",
      "chmod 600 $HOME/.ssh/cassy.pem",
      "cd $HOME/provision",
      "echo export IMAGE_TAG=${var.image_tag} > env",
      "export storage_base_uri=${var.storage_base_uri}",
      "export storage_type=${var.storage_type}",
      "export internal_domain=${var.internal_domain}",
      "j2 ./conf/cassy.properties.j2 > ./conf/cassy.properties",
      "source ./env",
      "docker-compose up -d",
    ]
  }
}
