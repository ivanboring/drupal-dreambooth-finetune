echo "$EXTRA_PUBLIC_SSH" >> /root/.ssh/authorized_keys
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -q -N ''
    echo "RSA key fingerprint:"
    ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub
fi
service ssh start
