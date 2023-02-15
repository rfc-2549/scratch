#include <libssh/libssh.h>
#include <stdio.h>

int main(void) {

	ssh_session ssh;
	ssh = ssh_new();
	if(ssh == NULL)
		return -1;
	ssh_options_set(ssh, SSH_OPTIONS_HOST, "192.168.1.57");
	
	ssh_userauth_privatekey_file(ssh, "root", "/home/diego/.ssh/id_ed25519", NULL);
	int rc = ssh_connect(ssh);

	ssh_channel ch = ssh_channel_new(ssh);
	ssh_channel_open_session(ch);
	rc = ssh_channel_request_exec(ch, "ps aux");
	if(rc != SSH_OK) {
		puts(ssh_get_error(ssh));
	}
	int c;
	char buf[256];
	while((c = ssh_channel_read(ch, buf, 256, 0)) > 0) {
		write(1, buf, c);
	}

	ssh_free(ssh);
	return 0;
}
