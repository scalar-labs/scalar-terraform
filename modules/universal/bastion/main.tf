module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "ansible_playbooks_copy" {
  count = var.provision_count

  triggers = {
    triggers = var.triggers[count.index]
  }

  connection {
    host        = var.bastion_host_ips[count.index]
    user        = var.user_name
    private_key = file(var.private_key_path)
  }

  provisioner "local-exec" {
    command = <<EOT
for i in ${var.public_key_folder_path}/*;
  do if [[ -e $i ]]; then 
    mkdir -p ../../../provision/ansible/playbooks/files/ssh_public; 
    cp $i ../../../provision/ansible/playbooks/files/ssh_public/; 
  fi; 
done
  EOT
  }

  provisioner "file" {
    source      = module.ansible.local_playbook_path
    destination = module.ansible.remote_playbook_path
  }
}

resource "null_resource" "ansible" {
  depends_on = [null_resource.ansible_playbooks_copy]

  triggers = {
    triggers = join(",", var.triggers)
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -u ${var.user_name} -i ${join(",", var.bastion_host_ips)}, bastion-server.yml -e enable_tdagent=${var.enable_tdagent ? 1 : 0} -e monitor_host=monitor.${var.internal_domain}"
    working_dir = module.ansible.local_playbook_path
  }
}
