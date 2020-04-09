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
ansible_path=../../../provision/ansible/playbooks/files/ssh
# add addtional public keys to tmp file
if [[ -s ${var.additional_public_keys_path} ]]; then 
  cp ${var.additional_public_keys_path} $ansible_path/additional_public_keys.tmp; 
fi;
# add to primary public key to tmp file
cat ${var.public_key_path} >> $ansible_path/additional_public_keys.tmp;
# dedup tmp file and create additional_public_keys
cat $ansible_path/additional_public_keys.tmp | sort | uniq > $ansible_path/additional_public_keys
# remove tmp file
rm $ansible_path/additional_public_keys.tmp
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
