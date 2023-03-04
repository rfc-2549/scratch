#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unbound.h>

int main(int argc, char **argv) {
  struct ub_ctx *ctx = ub_ctx_create();
  struct ub_result *result;
  int retval;


  if (!ctx) {
    printf("error: could not create unbound context\n");
    return -1;
  }

  retval = ub_resolve(ctx, argv[1], 1, 1, &result);
  
  if (retval != 0) {
    printf("resolve error: %s\n", ub_strerror(retval));
    return -1;
  }

  if (result->havedata) {
	  char addr[128];
	  inet_ntop(AF_INET, result->data[0], addr, 128);
	  puts(addr);
  }
  ub_resolve_free(result);
  ub_ctx_delete(ctx);
  return 0;
}
