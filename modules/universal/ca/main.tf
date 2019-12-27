module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "ca_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = element(var.host_list, count.index)
    user         = var.user_name
    agent        = true
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo ca host up"]
  }
}

resource "null_resource" "docker_install" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.ca_waitfor[count.index].id
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
      "ansible-playbook -u ${var.user_name} -i ${element(var.host_list, count.index)}, docker-server.yml cfssl.yml --extra-vars='enable_tdagent=${var.enable_tdagent ? 1 : 0}'",
    ]
  }
}

resource "null_resource" "ca_container" {
  count = var.provision_count

  triggers = {
    triggers = null_resource.docker_install[0].id
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = element(var.host_list, count.index)
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
      "cd $HOME/provision",
      "docker-compose up -d",
    ]
  }
}

