module "ansible" {
  source = "../../../provision/ansible"
}

resource "null_resource" "cassandra_waitfor" {
  count = var.provision_count

  triggers = {
    triggers = join(",", var.triggers)
    vm_id    = var.vm_ids[count.index]
  }

  connection {
    bastion_host = var.bastion_host_ip
    host         = var.host_list[count.index]
    user         = var.user_name
    agent        = var.use_agent
    private_key  = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["echo cassandra host up"]
  }
}

resource "null_resource" "cassandra" {
  count      = var.provision_count
  depends_on = [null_resource.cassandra_waitfor]

  triggers = {
    triggers = var.vm_ids[count.index]
  }

  connection {
    host        = var.bastion_host_ip
    user        = var.user_name
    agent       = var.use_agent
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${module.ansible.remote_playbook_path}",
      "echo '${var.cassy_public_key}' > cassandra.pub",
      "ansible-playbook -u ${var.user_name} -i ${var.host_list[count.index]}, cassandra-server.yml --extra-vars=CASSANDRA_MEMTABLE_THRESHOLD=${var.memtable_threshold} --extra-vars=CASSANDRA_SEEDS=${join(",", var.host_seed_list)} --extra-vars=enable_tdagent=${var.enable_tdagent ? 1 : 0} --extra-vars=CASSANDRA_STATE=${var.start_on_initial_boot ? "started" : "stopped"}",
    ]
  }
}
