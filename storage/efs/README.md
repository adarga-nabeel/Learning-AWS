Bootstrap Elastic File System (EFS) to an EC2

For further information please visit:

https://medium.com/avmconsulting-blog/creating-efs-file-system-and-mount-targets-using-terraform-6f8890201b13

To enable EFS filesystem even after reboot, you can do as follows:

<file_system_id>.us-east-1.amazonaws.com:/ /efs nfs4 defaults,_netdev 0 0